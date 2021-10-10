import 'dart:async';

import 'package:http/http.dart' as http;

import 'node_pool.dart';
import '../configuration.dart';
import '../models/models.dart';
import '../exceptions/exceptions.dart';

/// Key to set the content-type of the request in `additionalHeaders` map.
///
/// The content-type of the request will default to "application/json".
const contentType = 'Content-Type';

/// Key to set the api key in either `_defaultQueryParameters` or
/// `_defaultHeaders` map depending on `Configuration.sendApiKeyAsQueryParam`.
const _apiKey = 'X-TYPESENSE-API-KEY';

/// A generic abstract class which implements the core logic of using [NodePool]
/// to complete the requests.
///
/// [R] stands for the response type that the sub-class implementing
/// [BaseApiCall] promises.
abstract class BaseApiCall<R> {
  final Configuration config;
  final NodePool _nodePool;
  final Map<String, String> _defaultHeaders = {};
  final Map<String, String> _defaultQueryParameters = {};

  BaseApiCall(this.config, NodePool nodePool) : _nodePool = nodePool {
    if (config.sendApiKeyAsQueryParam) {
      _defaultQueryParameters[_apiKey] = config.apiKey;
    } else {
      _defaultHeaders[_apiKey] = config.apiKey;
    }

    _defaultHeaders[contentType] = 'application/json';
  }

  /// Headers that are common in majority requests.
  ///
  /// Holds the api key if [Configuration.sendApiKeyAsQueryParam] is `false`.
  Map<String, String> get defaultHeaders => Map.from(_defaultHeaders);

  /// Holds the api key if [Configuration.sendApiKeyAsQueryParam] is `true`.
  Map<String, String> get defaultQueryParameters =>
      Map.from(_defaultQueryParameters);

  /// Retries the [request] untill a node responds or [Configuration.numRetries]
  /// run out.
  ///
  /// Also sets the health status of nodes after each request so it can be put
  /// in/out of [NodePool]'s circulation.
  Future<R> send(Future<http.Response> Function(Node) request) async {
    http.Response response;
    Node node;
    for (var triesLeft = config.numRetries;;) {
      node = _nodePool.nextNode;
      try {
        response = await request(node).timeout(
          config.connectionTimeout,
        );

        if (response.statusCode >= 1 && response.statusCode <= 499) {
          // Treat any status code > 0 and < 500 to be an indication that the
          // node is healthy.
          // We exclude 0 since some clients return 0 when
          // request fails.
          NodePool.setNodeHealthStatus(node, true, DateTime.now());
        }

        if (response.statusCode >= 200 && response.statusCode < 300) {
          // If response is 2xx return a resolved promise.
          return decode(response.body);
        } else if (response.statusCode < 500) {
          // Next, if response is anything but 5xx, don't retry, return a custom
          // error.
          return Future.error(_exception(response.body, response.statusCode));
        } else {
          // Retry all other HTTP errors (HTTPStatus > 500).
          // This will get caught by the catch block below.
          throw ServerError(response.body, response.statusCode);
        }
      } catch (e) {
        // This block handles retries for HTTPStatus > 500 and network layer
        // issues like connection timeouts.
        NodePool.setNodeHealthStatus(node, false, DateTime.now());

        if (--triesLeft <= 0) {
          // We've exhausted our tries, rethrow.
          rethrow;
        } else {
          await Future.delayed(config.retryInterval);
        }
      }
    }
  }

  /// [responseBody] decoder specific to the sub-class.
  R decode(String responseBody);

  /// Constructs the final [Uri] by combining the [Node.uri] with [endpoint] and
  /// [queryParams].
  Uri getRequestUri(
    Node node,
    String endpoint, {
    Map<String, dynamic>? queryParams,
  }) =>
      Uri(
        scheme: node.uri.scheme,
        host: node.host,
        port: node.port,
        path: '${node.path}$endpoint',
        queryParameters: {..._defaultQueryParameters, ...?queryParams},
      );

  /// Returns a [RequestException] according to [status] received in a response.
  ///
  /// [message] usually contains the response body received.
  RequestException _exception(String message, int status) {
    if (status == 400) {
      return RequestMalformed(message);
    } else if (status == 401) {
      return RequestUnauthorized(message);
    } else if (status == 404) {
      return ObjectNotFound(message);
    } else if (status == 409) {
      return ObjectAlreadyExists(message);
    } else if (status == 422) {
      return ObjectUnprocessable(message);
    } else if (status >= 500 && status <= 599) {
      return ServerError(message, status);
    } else {
      return HttpError(message, status);
    }
  }
}
