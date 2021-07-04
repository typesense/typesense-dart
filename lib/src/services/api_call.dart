import 'dart:async';
import 'dart:convert';
import 'dart:collection';

import 'base_api_call.dart';
import 'node_pool.dart';
import 'request_cache.dart';
import '../configuration.dart';

export 'base_api_call.dart' show CONTENT_TYPE;

/// Handles requests that expect JSON data of `Map<String, dynamic>` type from
/// the server.
class ApiCall extends BaseApiCall<Map<String, dynamic>> {
  final RequestCache _requestCache;

  ApiCall(Configuration config, NodePool nodePool, RequestCache requestCache)
      : _requestCache = requestCache,
        super(config, nodePool);

  /// Sends an HTTP GET request to the URL constructed using the [Node.uri],
  /// [endpoint] and [queryParams].
  ///
  /// Set [shouldCacheResult] to `true` if the response is supposed to be cached.
  /// For caching to take effect, [Configuration.cachedSearchResultsTTL] needs
  /// to be set.
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic> queryParams = const {},
    bool shouldCacheResult = false,
  }) =>
      shouldCacheResult && config.cachedSearchResultsTTL != Duration.zero
          ? _requestCache.cache(
              // SplayTreeMap ensures order of the parameters is maintained so
              // cache key won't differ because of different ordering of
              // parameters.
              '${endpoint}${SplayTreeMap.from(queryParams)}'.hashCode,
              send,
              (node) => node.client.get(
                requestUri(node, endpoint, queryParams),
                headers: defaultHeaders,
              ),
              config.cachedSearchResultsTTL,
            )
          : send((node) => node.client.get(
                requestUri(node, endpoint, queryParams),
                headers: defaultHeaders,
              ));

  /// Sends an HTTP DELETE request to the URL constructed using the [Node.uri],
  /// [endpoint] and [queryParams].
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, dynamic> queryParams,
  }) =>
      send((node) => node.client.delete(
            requestUri(node, endpoint, queryParams),
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
    Map<String, dynamic> queryParams = const {},
    Map<String, String> additionalHeaders = const {},
    Object bodyParameters,
    bool shouldCacheResult = false,
  }) =>
      shouldCacheResult && config.cachedSearchResultsTTL != Duration.zero
          ? _requestCache.cache(
              // SplayTreeMap ensures order of the parameters is maintained so
              // cache key won't differ because of different ordering of
              // parameters.
              '${endpoint}${SplayTreeMap.from(queryParams)}${SplayTreeMap.from(additionalHeaders)}${json.encode(bodyParameters)}'
                  .hashCode,
              send,
              (node) => node.client.post(
                requestUri(node, endpoint, queryParams),
                headers: {...defaultHeaders, ...additionalHeaders},
                body: json.encode(bodyParameters),
              ),
              config.cachedSearchResultsTTL,
            )
          : send((node) => node.client.post(
                requestUri(node, endpoint, queryParams),
                headers: {...defaultHeaders, ...additionalHeaders},
                body: json.encode(bodyParameters),
              ));

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
    Map<String, dynamic> queryParams,
    Object bodyParameters,
  }) =>
      send((node) => node.client.put(
            requestUri(node, endpoint, queryParams),
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
    Map<String, dynamic> queryParams,
    Object bodyParameters,
  }) =>
      send((node) => node.client.patch(
            requestUri(node, endpoint, queryParams),
            headers: defaultHeaders,
            body: json.encode(bodyParameters),
          ));

  /// The [responseBody] is parsed as JSON and returned if no exceptions are
  /// raised.
  @override
  Map<String, dynamic> decode(String responseBody) =>
      responseBody.isEmpty ? {} : json.decode(responseBody);
}
