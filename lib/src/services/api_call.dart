import 'dart:async';
import 'dart:convert';
import 'dart:collection';

import 'package:http/http.dart' as http;

import 'base_api_call.dart';
import 'request_cache.dart';
import '../configuration.dart';
import '../models/models.dart';

export 'base_api_call.dart' show contentType;

/// Handles requests that expect JSON data of `Map<String, dynamic>` type from
/// the server.
class ApiCall extends BaseApiCall<Map<String, dynamic>> {
  final RequestCache _requestCache;

  ApiCall(super.config, super.nodePool, RequestCache requestCache)
      : _requestCache = requestCache;

  /// Sends an HTTP GET request to the URL constructed using the [Node.uri],
  /// [endpoint] and [queryParams].
  ///
  /// Set [shouldCacheResult] to `true` if the response is supposed to be cached.
  /// For caching to take effect, [Configuration.cachedSearchResultsTTL] needs
  /// to be set.
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    bool shouldCacheResult = false,
  }) {
    if (shouldCacheResult && config.cachedSearchResultsTTL != Duration.zero) {
      // SplayTreeMap ensures order of the parameters is maintained so
      // cache key won't differ because of different ordering of
      // parameters.
      final queryParamsSplay =
          queryParams == null ? null : SplayTreeMap.from(queryParams);

      return _requestCache.cache(
        '$endpoint${queryParamsSplay ?? ''}',
        send,
        (node) => node.client!.get(
          getRequestUri(node, endpoint, queryParams: queryParams),
          headers: defaultHeaders,
        ),
      );
    } else {
      return send((node) => node.client!.get(
            getRequestUri(node, endpoint, queryParams: queryParams),
            headers: defaultHeaders,
          ));
    }
  }

  /// Sends an HTTP GET request that expects a JSON array response.
  /// Logic mirrors [get], only the response decoding differs.
  Future<List<dynamic>> getList(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    bool shouldCacheResult = false,
  }) {
    if (shouldCacheResult && config.cachedSearchResultsTTL != Duration.zero) {
      final queryParamsSplay =
          queryParams == null ? null : SplayTreeMap.from(queryParams);

      return _requestCache.cacheList(
        '$endpoint${queryParamsSplay ?? ''}',
        sendList,
        (node) => node.client!.get(
          getRequestUri(node, endpoint, queryParams: queryParams),
          headers: defaultHeaders,
        ),
      );
    } else {
      return sendList((node) => node.client!.get(
            getRequestUri(node, endpoint, queryParams: queryParams),
            headers: defaultHeaders,
          ));
    }
  }

  /// Sends an HTTP DELETE request to the URL constructed using the [Node.uri],
  /// [endpoint] and [queryParams].
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, dynamic>? queryParams,
  }) =>
      send((node) => node.client!.delete(
            getRequestUri(node, endpoint, queryParams: queryParams),
            headers: defaultHeaders,
          ));

  /// Sends an HTTP POST request with the given [additionalHeaders] and
  /// [bodyParameters] to the URL constructed using the [Node.uri], [endpoint]
  /// and [queryParams].
  ///
  /// [bodyParameters] is json encoded and sent as the body of the request. The
  /// content-type of the request is "application/json".
  /// If [bodyParameters] contains objects that are not directly encodable to a
  /// JSON string (a value that is not a number, boolean, string, null, list or
  /// a map with string keys), it defaults to a function that returns the result
  /// of calling `.toJson()` on the unencodable object.
  ///
  /// Set [shouldCacheResult] to `true` if the response is supposed to be cached.
  /// For caching to take effect, [Configuration.cachedSearchResultsTTL] needs
  /// to be set.
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? additionalHeaders,
    Object? bodyParameters,
    bool shouldCacheResult = false,
  }) {
    final headers = {...defaultHeaders, ...?additionalHeaders};
    final encodedBody = json.encode(bodyParameters);

    Future<http.Response> request(Node node) => node.client!.post(
          getRequestUri(node, endpoint, queryParams: queryParams),
          headers: headers,
          body: encodedBody,
        );

    if (shouldCacheResult && config.cachedSearchResultsTTL != Duration.zero) {
      // SplayTreeMap ensures order of the parameters is maintained so the cache
      // key won't differ because of different ordering of parameters.
      final queryParamsSplay =
          queryParams == null ? null : SplayTreeMap.from(queryParams);
      final additionalHeadersSplay = additionalHeaders == null
          ? null
          : SplayTreeMap.from(additionalHeaders);

      return _requestCache.cache(
        '$endpoint${queryParamsSplay ?? ''}${additionalHeadersSplay ?? ''}$encodedBody',
        send,
        request,
      );
    } else {
      return send(request);
    }
  }

  /// Sends an HTTP PUT request with the given [bodyParameters] to the URL
  /// constructed using the [Node.uri], [endpoint] and [queryParams].
  ///
  /// [bodyParameters] is json encoded and sent as the body of the request. The
  /// content-type of the request is "application/json".
  /// If [bodyParameters] contains objects that are not directly encodable to a
  /// JSON string (a value that is not a number, boolean, string, null, list or
  /// a map with string keys), it defaults to a function that returns the result
  /// of calling `.toJson()` on the unencodable object.
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    Object? bodyParameters,
  }) =>
      send((node) => node.client!.put(
            getRequestUri(node, endpoint, queryParams: queryParams),
            headers: defaultHeaders,
            body: json.encode(bodyParameters),
          ));

  /// Sends an HTTP PATCH request with the given [bodyParameters] to the URL
  /// constructed using the [Node.uri], [endpoint] and [queryParams].
  ///
  /// [bodyParameters] is json encoded and sent as the body of the request. The
  /// content-type of the request is "application/json".
  /// If [bodyParameters] contains objects that are not directly encodable to a
  /// JSON string (a value that is not a number, boolean, string, null, list or
  /// a map with string keys), it defaults to a function that returns the result
  /// of calling `.toJson()` on the unencodable object.
  Future<Map<String, dynamic>> patch(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    Object? bodyParameters,
  }) =>
      send((node) => node.client!.patch(
            getRequestUri(node, endpoint, queryParams: queryParams),
            headers: defaultHeaders,
            body: json.encode(bodyParameters),
          ));

  /// The [responseBody] is parsed as JSON and returned if no exceptions are
  /// raised.
  @override
  @override
  Map<String, dynamic> decode(String responseBody) =>
      responseBody.isEmpty
          ? {}
          : json.decode(responseBody) as Map<String, dynamic>;

  List<dynamic> decodeList(String responseBody) =>
      responseBody.isEmpty ? [] : json.decode(responseBody) as List<dynamic>;

  Future<List<dynamic>> sendList(
      Future<http.Response> Function(Node) request) async {
    final response = await sendRaw(request);
    return decodeList(response.body);
  }
}
