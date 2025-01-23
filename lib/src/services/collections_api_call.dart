import 'dart:async';
import 'dart:convert';

import './base_api_call.dart';

export './base_api_call.dart' show contentType;

/// Handles requests that expect JSON data of `List<Map<String, dynamic>>` type
/// from the server.
class CollectionsApiCall extends BaseApiCall<List<Map<String, dynamic>>> {
  CollectionsApiCall(super.config, super.nodePool);

  /// Sends an HTTP GET request to the URL constructed using the [Node.uri],
  /// [endpoint] and [queryParams].
  Future<List<Map<String, dynamic>>> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
  }) =>
      send((node) => node.client!.get(
            getRequestUri(node, endpoint, queryParams: queryParams),
            headers: defaultHeaders,
          ));

  /// The [responseBody] is parsed as list of JSON objects and returned if no
  /// exceptions are raised.
  @override
  List<Map<String, dynamic>> decode(String responseBody) => responseBody.isEmpty
      ? []
      : (json.decode(responseBody) as List).cast<Map<String, dynamic>>();
}
