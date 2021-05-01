import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'configuration.dart';
import 'exceptions.dart' hide MissingConfiguration;

class ApiCall {
  final Configuration _config;
  List<Node> _nodes;
  int _nodeIndex = -1;
  bool _nearestNodeIsPresent;

  ApiCall(this._config) {
    _nodes = List.from(_config.nodes);

    _nearestNodeIsPresent = _config.nearestNode != null;
    if (_nearestNodeIsPresent) {
      _config.nearestNode.client ??= http.Client();
    }
  }

  Future<Map<String, dynamic>> get(String endpoint,
      {Map<String, String> queryParams = const {}}) async {
    http.Response response;
    for (var triesLeft = _config.numRetries;;) {
      final node = _nextNode();
      try {
        response = await node.client
            .get(
              _requestUri(node, endpoint, queryParams),
              headers: _defaultHeaders(),
            )
            .timeout(
              _config.connectionTimeout,
            );
        return _handleNodeResponse(node, response);
      } catch (e) {
        if (--triesLeft == 0) {
          // We've exhausted our tries, rethrow.
          rethrow;
        }

        if (!(e is TimeoutException) && response.statusCode < 500) {
          // If response is anything but 5xx, rethrow.
          rethrow;
        } else {
          // Retry all other HTTP errors (HTTPStatus > 500) after [retryInterval].
          await Future.delayed(_config.retryInterval);
        }
      }
    }
  }

  Future<Map<String, dynamic>> delete(String endpoint,
      {Map<String, String> queryParams = const {}}) async {
    http.Response response;
    for (var triesLeft = _config.numRetries;;) {
      final node = _nextNode();
      try {
        response = await node.client
            .delete(
              _requestUri(node, endpoint, queryParams),
              headers: _defaultHeaders(),
            )
            .timeout(
              _config.connectionTimeout,
            );
        return _handleNodeResponse(node, response);
      } catch (e) {
        if (--triesLeft == 0) {
          // We've exhausted our tries, rethrow.
          rethrow;
        }

        if (!(e is TimeoutException) && response.statusCode < 500) {
          // If response is anything but 5xx, rethrow.
          rethrow;
        } else {
          // Retry all other HTTP errors (HTTPStatus > 500) after [retryInterval].
          await Future.delayed(_config.retryInterval);
        }
      }
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, String> queryParams = const {},
    Map<String, String> additionalHeaders = const {},
    Map<String, String> bodyParameters = const {},
  }) async {
    http.Response response;
    for (var triesLeft = _config.numRetries;;) {
      final node = _nextNode();
      try {
        response = await node.client
            .post(
              _requestUri(node, endpoint, queryParams),
              headers: {..._defaultHeaders(), ...additionalHeaders},
              body: bodyParameters,
            )
            .timeout(
              _config.connectionTimeout,
            );
        return _handleNodeResponse(node, response);
      } catch (e) {
        if (--triesLeft == 0) {
          // We've exhausted our tries, rethrow.
          rethrow;
        }

        if (!(e is TimeoutException) && response.statusCode < 500) {
          // If response is anything but 5xx, rethrow.
          rethrow;
        } else {
          // Retry all other HTTP errors (HTTPStatus > 500) after [retryInterval].
          await Future.delayed(_config.retryInterval);
        }
      }
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, String> queryParams = const {},
    Map<String, String> bodyParameters = const {},
  }) async {
    http.Response response;
    for (var triesLeft = _config.numRetries;;) {
      final node = _nextNode();
      try {
        response = await node.client
            .put(
              _requestUri(node, endpoint, queryParams),
              headers: _defaultHeaders(),
              body: bodyParameters,
            )
            .timeout(
              _config.connectionTimeout,
            );
        return _handleNodeResponse(node, response);
      } catch (e) {
        if (--triesLeft == 0) {
          // We've exhausted our tries, rethrow.
          rethrow;
        }

        if (!(e is TimeoutException) && response.statusCode < 500) {
          // If response is anything but 5xx, rethrow.
          rethrow;
        } else {
          // Retry all other HTTP errors (HTTPStatus > 500) after [retryInterval].
          await Future.delayed(_config.retryInterval);
        }
      }
    }
  }

  Future<Map<String, dynamic>> patch(
    String endpoint, {
    Map<String, String> queryParams = const {},
    Map<String, String> bodyParameters = const {},
  }) async {
    http.Response response;
    for (var triesLeft = _config.numRetries;;) {
      final node = _nextNode();
      try {
        response = await node.client
            .patch(
              _requestUri(node, endpoint, queryParams),
              headers: _defaultHeaders(),
              body: bodyParameters,
            )
            .timeout(
              _config.connectionTimeout,
            );
        return _handleNodeResponse(node, response);
      } catch (e) {
        if (--triesLeft == 0) {
          // We've exhausted our tries, rethrow.
          rethrow;
        }

        if (!(e is TimeoutException) && response.statusCode < 500) {
          // If response is anything but 5xx, rethrow.
          rethrow;
        } else {
          // Retry all other HTTP errors (HTTPStatus > 500) after [retryInterval].
          await Future.delayed(_config.retryInterval);
        }
      }
    }
  }

  Uri _requestUri(
    Node node,
    String endpoint,
    Map<String, String> queryParams,
  ) =>
      Uri(
        scheme: node.uri.scheme,
        host: node.uri.host,
        port: node.uri.port,
        path: '${node.uri.path}$endpoint',
        queryParameters: {..._defaultQueryParameters(), ...queryParams},
      );

  Map<String, String> _defaultHeaders() {
    final defaultHeaders = <String, String>{};
    if (!_config.sendApiKeyAsQueryParam) {
      defaultHeaders['X-TYPESENSE-API-KEY'] = _config.apiKey;
    }
    defaultHeaders['Content-Type'] = 'application/json';
    return defaultHeaders;
  }

  Map<String, String> _defaultQueryParameters() {
    final defaultQueryParameters = <String, String>{};
    if (_config.sendApiKeyAsQueryParam) {
      defaultQueryParameters['x-typesense-api-key'] = _config.apiKey;
    }
    return defaultQueryParameters;
  }

  /// Attempts to find a healthy node, looping through the list of nodes
  /// once. But if no healthy nodes are found, it will just return the next
  /// node, even if it's unhealthy so we can try the request for good measure,
  /// in case that node has become healthy since.
  Node _nextNode() {
    if (_nearestNodeIsPresent && _canUse(_config.nearestNode)) {
      return _config.nearestNode;
    } else {
      for (var i = 0; i < _nodes.length; i++) {
        _nodeIndex = (_nodeIndex + 1) % _nodes.length;
        final candidateNode = _nodes[_nodeIndex]..client ??= http.Client();

        if (_canUse(candidateNode)) {
          return candidateNode;
        }
      }
    }

    // None of the nodes can be used, returning the next node.
    return _nodes[++_nodeIndex];
  }

  /// Returns if the [node] can be used to complete the request.
  ///
  /// Unhealthy nodes can also be used if [healthcheckInterval] durtation has
  /// passed since the last request was failed by the [node].
  bool _canUse(Node node) =>
      node.isHealthy || node.isDueForHealthCheck(_config.healthcheckInterval);

  /// Handels the [response] from the [node] for a request.
  ///
  /// The [response.body] is parsed as JSON and returned if no exceptions are
  /// raised.
  Map<String, dynamic> _handleNodeResponse(Node node, http.Response response) {
    final responseBody = json.decode(response.body),
        responseStatus = response.statusCode;
    if (responseStatus >= 1 && responseStatus <= 499) {
      // Treat any status code > 0 and < 500 to be an indication that node is healthy.
      // We exclude 0 since some clients return 0 when request fails.
      _setNodeHealthStatus(node, true);
    } else {
      _setNodeHealthStatus(node, false);
    }
    if (responseStatus >= 200 && responseStatus < 300) {
      // If response is 2xx return the body.
      return responseBody;
    } else {
      throw _customExceptionForResponse(responseBody, responseStatus);
    }
  }

  void _setNodeHealthStatus(Node node, bool status) {
    node.isHealthy = status;
    node.lastAccessTimestamp = DateTime.now();
  }

  Exception _customExceptionForResponse(String body, int status) {
    if (status == 400) {
      return RequestMalformed(body, status);
    } else if (status == 401) {
      return RequestUnauthorized(body, status);
    } else if (status == 404) {
      return ObjectNotFound(body, status);
    } else if (status == 409) {
      return ObjectAlreadyExists(body, status);
    } else if (status == 422) {
      return ObjectUnprocessable(body, status);
    } else if (status >= 500 && status <= 599) {
      return ServerError(body, status);
    } else {
      return HttpError(body, status);
    }
  }
}
