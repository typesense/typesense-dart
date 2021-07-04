import 'dart:async';
import 'dart:convert';

import './base_api_call.dart';
import './node_pool.dart';
import '../configuration.dart';

export './base_api_call.dart' show CONTENT_TYPE;

/// Handles requests that expect JSON data of `List<Map<String, dynamic>>` type
/// from the server.
class CollectionsApiCall extends BaseApiCall<List<Map<String, dynamic>>> {
  CollectionsApiCall(Configuration config, NodePool nodePool)
      : super(config, nodePool);

  /// Sends an HTTP GET request to the URL constructed using the [Node.uri],
  /// [endpoint] and [queryParams].
  Future<List<Map<String, dynamic>>> get(
    String endpoint, {
    Map<String, dynamic> queryParams,
  }) =>
      send((node) => node.client.get(
            requestUri(node, endpoint, queryParams),
            headers: defaultHeaders,
          ));

  /// The [responseBody] is parsed as list of JSON objects and returned if no
  /// exceptions are raised.
  @override
  List<Map<String, dynamic>> decode(String responseBody) => responseBody.isEmpty
      ? []
      : (json.decode(responseBody) as List).cast<Map<String, dynamic>>();
}
