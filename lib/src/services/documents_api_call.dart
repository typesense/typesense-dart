import 'dart:async';

import './base_api_call.dart';

export './base_api_call.dart' show contentType;

/// Handles requests that expect JSONL data of `String` type from the server.
class DocumentsApiCall extends BaseApiCall<String> {
  DocumentsApiCall(super.config, super.nodePool);

  /// Sends an HTTP GET request to the URL constructed using the [Node.uri],
  /// [endpoint] and [queryParams].
  Future<String> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
  }) =>
      send((node) => node.client!.get(
            getRequestUri(node, endpoint, queryParams: queryParams),
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
    Map<String, dynamic>? queryParams,
    Map<String, String>? additionalHeaders,
    String? bodyParameters,
  }) =>
      send((node) => node.client!.post(
            getRequestUri(node, endpoint, queryParams: queryParams),
            headers: {...defaultHeaders, ...?additionalHeaders},
            body: bodyParameters,
          ));

  /// The [responseBody] is returned as is.
  @override
  String decode(String responseBody) => responseBody;
}
