import 'dart:async';

import 'package:http/http.dart';

import './base_api_call.dart';
import './node_pool.dart';
import '../configuration.dart';

export './base_api_call.dart' show CONTENT_TYPE;

/// Handles requests that expect JSONL data of `String` type from the server.
class DocumentsApiCall extends BaseApiCall<String> {
  DocumentsApiCall(Configuration config, NodePool nodePool)
      : super(config, nodePool);

  /// Sends an HTTP GET request to the URL constructed using the [Node.uri],
  /// [endpoint] and [queryParams].
  Future<String> get(
    String endpoint, {
    Map<String, dynamic> queryParams = const {},
  }) =>
      send((node) => node.client.get(
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
  Future<String> post(
    String endpoint, {
    Map<String, dynamic> queryParams = const {},
    Map<String, String> additionalHeaders = const {},
    String bodyParameters,
  }) =>
      send((node) => node.client.post(
            requestUri(node, endpoint, queryParams),
            headers: {...defaultHeaders, ...additionalHeaders},
            body: bodyParameters,
          ));

  /// Handels the [response] from the [node] for a request.
  ///
  /// The [response.body] is returned if no exceptions are raised.
  @override
  String handleNodeResponse(Response response) {
    final responseBody = response.body, responseStatus = response.statusCode;

    if (responseStatus >= 200 && responseStatus < 300) {
      // If response is 2xx return the body.
      return responseBody;
    } else {
      throw exception(responseBody.toString(), responseStatus);
    }
  }
}
