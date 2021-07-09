import 'package:http/http.dart' as http;

import '../configuration.dart';
import '../models/node.dart';

/// Regulates the ciculation of the nodes specified in the [Configuration].
class NodePool {
  final Configuration _config;
  final List<Node> _nodes;
  final bool _isNearestNodePresent;

  int _index = -1;

  NodePool(Configuration config)
      : _config = config,
        _nodes = List.from(config.nodes),
        _isNearestNodePresent = config.nearestNode != null;

  /// Returns a node from the circulation of healthy nodes.
  ///
  /// An unhealthy node is returned when no healthy nodes are found, so it can
  /// be checked if it has become healthy since.
  ///
  /// [Configuration.nearestNode] is preferred over nodes in
  /// [Configuration.nodes] and is returned when present and healthy.
  ///
  /// Unhealthy node is put back in circulation if
  /// [Configuration.healthcheckInterval] has passed since it was last accessed.
  Node get nextNode {
    if (_isNearestNodePresent && _canUse(_config.nearestNode)) {
      return _config.nearestNode..client ??= http.Client();
    } else {
      _incrementNodeIndex(); // Keep rotating the nodes for each request.
      for (var i = 0; i < _nodes.length; i++, _incrementNodeIndex()) {
        final candidateNode = _nodes[_index]..client ??= http.Client();

        if (_canUse(candidateNode)) {
          return candidateNode;
        }
      }
    }

    // None of the nodes can be used, returning the next node.
    return _nodes[_index];
  }

  /// Sets [node]'s health as [isHealthy] along with it's last [accessTime].
  static setNodeHealthStatus(Node node, bool isHealthy, DateTime accessTime) {
    node.isHealthy = isHealthy;
    node.lastAccessTimestamp = accessTime;
  }

  /// Returns if the [node] can be used to complete the request.
  ///
  /// Unhealthy nodes can also be used if [healthcheckInterval] durtation has
  /// passed since the last request was failed by the [node].
  bool _canUse(Node node) =>
      node.isHealthy || node.isDueForHealthCheck(_config.healthcheckInterval);

  void _incrementNodeIndex() => _index = (_index + 1) % _nodes.length;
}
