import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';

import './base_api_call.dart';
import './node_pool.dart';
import '../configuration.dart';

export './base_api_call.dart' show CONTENT_TYPE;

/// Handles requests that expect JSON data of `Map<String, dynamic>` type from
/// the server.
class ApiCall extends BaseApiCall<Map<String, dynamic>> {
  ApiCall(Configuration config, NodePool nodePool) : super(config, nodePool);

  /// Sends an HTTP GET request to the URL constructed using the [Node.uri],
  /// [endpoint] and [queryParams].
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic> queryParams = const {},
  }) =>
      send((node) => node.client.get(
            requestUri(node, endpoint, queryParams),
            headers: defaultHeaders,
          ));

  /// Sends an HTTP DELETE request to the URL constructed using the [Node.uri],
  /// [endpoint] and [queryParams].
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, dynamic> queryParams = const {},
  }) =>
      send((node) => node.client.delete(
            requestUri(node, endpoint, queryParams),
            headers: defaultHeaders,
          ));

  /// Sends an HTTP POST request with the given [additionalHeaders] and
  /// [bodyParameters] to the URL constructed using the [Node.uri], [endpoint]
  /// and [queryParams].
  ///
  /// [bodyParameters] sets the body of the request. It's encoded as json and
  /// used as the body of the request. The content-type of the request is
  /// "application/json".
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic> queryParams = const {},
    Map<String, String> additionalHeaders = const {},
    Object bodyParameters,
  }) =>
      send((node) => node.client.post(
            requestUri(node, endpoint, queryParams),
            headers: {...defaultHeaders, ...additionalHeaders},
            body: json.encode(bodyParameters),
          ));

  /// Sends an HTTP PUT request with the given [bodyParameters] to the URL
  /// constructed using the [Node.uri], [endpoint] and [queryParams].
  ///
  /// [bodyParameters] sets the body of the request. It's encoded as json and
  /// used as the body of the request. The content-type of the request is
  /// "application/json".
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic> queryParams = const {},
    Object bodyParameters,
  }) =>
      send((node) => node.client.put(
            requestUri(node, endpoint, queryParams),
            headers: defaultHeaders,
            body: json.encode(bodyParameters),
          ));

  /// Handels the [response] from the [node] for a request.
  ///
  /// The [response.body] is parsed as JSON and returned if no exceptions are
  /// raised.
  @override
  Map<String, dynamic> handleNodeResponse(Response response) {
    final responseBody = json.decode(response.body),
        responseStatus = response.statusCode;

    if (responseStatus >= 200 && responseStatus < 300) {
      // If response is 2xx return the body.
      return responseBody;
    } else {
      throw exception(responseBody.toString(), responseStatus);
    }
  }
}
