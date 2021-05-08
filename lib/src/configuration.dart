import 'exceptions.dart' show MissingConfiguration;

import 'models/node.dart';

class Configuration {
  final Set<Node> nodes;
  final Node nearestNode;
  final Duration connectionTimeout;
  final Duration healthcheckInterval;
  final int numRetries;
  final Duration retryInterval;
  final String apiKey;
  final bool sendApiKeyAsQueryParam;

  const Configuration._({
    this.nodes,
    this.nearestNode,
    this.connectionTimeout,
    this.healthcheckInterval,
    this.numRetries,
    this.retryInterval,
    this.apiKey,
    this.sendApiKeyAsQueryParam,
  });

  factory Configuration({
    Set<Node> nodes,
    Node nearestNode,
    Duration connectionTimeout,
    Duration healthcheckInterval,
    int numRetries,
    Duration retryInterval,
    String apiKey,
    bool sendApiKeyAsQueryParam,
  }) {
    if (nodes == null || nodes.isEmpty) {
      throw MissingConfiguration('Ensure that Configuration.nodes is set');
    }

    if (apiKey == null || apiKey.isEmpty) {
      throw MissingConfiguration('Ensure that Configuration.apiKey is set');
    }
    return Configuration._(
      nodes: nodes,
      nearestNode: nearestNode,
      connectionTimeout: connectionTimeout ??= Duration(seconds: 10),
      healthcheckInterval: healthcheckInterval ??= Duration(seconds: 15),
      numRetries: numRetries ??= nodes.length + (nearestNode == null ? 0 : 1),
      retryInterval: retryInterval ??= Duration(milliseconds: 100),
      apiKey: apiKey,
      sendApiKeyAsQueryParam: sendApiKeyAsQueryParam ??= false,
    );
  }
}
