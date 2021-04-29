import 'dart:convert';

import 'package:http/http.dart' as http;

import 'configuration.dart';
import 'exceptions.dart' hide MissingConfiguration;

class ApiCall {
  final Configuration _config;
  List<Node> _nodes;
  int _nodeIndex = 0;
  bool _nearestNodeIsPresent;

  ApiCall(this._config) {
    _nodes = List.from(_config.nodes);

    _nearestNodeIsPresent = _config.nearestNode != null;
    if (_config.nearestNode != null) {
      _config.nearestNode.client = http.Client();
    }
  }

  Future<String> get(String endpoint) async {
    final node = _getNextNode();
    final response =
        await node.client.get(Uri.parse('${node.uri}$endpoint'), headers: {});
    return _handleNodeResponse(node, response);
  }

  Future<String> post(String endpoint, Object bodyParameters) async {
    final node = _getNextNode();
    final response = await node.client.post(Uri.parse('${node.uri}$endpoint'));
    return _handleNodeResponse(node, response);
  }

  /// Attempts to find a healthy node, looping through the list of nodes
  /// once. But if no healthy nodes are found, it will just return the next
  /// node, even if it's unhealthy so we can try the request for good measure,
  /// in case that node has become healthy since.
  Node _getNextNode() {
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

  String _handleNodeResponse(Node node, http.Response response) {
    for (var tries = 0; tries < _config.numRetries; tries++) {
      try {
        if (response.statusCode >= 1 && response.statusCode <= 499) {
          // Treat any status code > 0 and < 500 to be an indication that node is healthy.
          // We exclude 0 since some clients return 0 when request fails.
          _setNodeHealthStatus(node, true);
        }

        if (response.statusCode >= 200 && response.statusCode < 300) {
          // If response is 2xx return a resolved promise
          return response.body;
        } else if (response.statusCode < 500) {
          // Next, if response is anything but 5xx, don't retry.
          return '';
        } else {
          // Retry all other HTTP errors (HTTPStatus > 500)
          // This will get caught by the catch block below
          throw _customExceptionForResponse(response);
        }
      } catch (e) {}
    }
  }

  void _setNodeHealthStatus(Node node, bool status) {
    node.isHealthy = status;
    node.lastAccessTimestamp = DateTime.now();
  }

  Exception _customExceptionForResponse(http.Response response) {
    final status = response.statusCode;
    if (status == 400) {
      return RequestMalformed(json.decode(response.body), status);
    } else if (status == 401) {
      return RequestUnauthorized(json.decode(response.body), status);
    } else if (status == 404) {
      return ObjectNotFound(json.decode(response.body), status);
    } else if (status == 409) {
      return ObjectAlreadyExists(json.decode(response.body), status);
    } else if (status == 422) {
      return ObjectUnprocessable(json.decode(response.body), status);
    } else if (status >= 500 && status <= 599) {
      return ServerError(json.decode(response.body), status);
    } else {
      return HttpError(json.decode(response.body), status);
    }
  }
}
