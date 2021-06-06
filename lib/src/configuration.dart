import 'package:collection/collection.dart';

import 'exceptions/exceptions.dart' show MissingConfiguration;
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

  factory Configuration.updateParameters(
    Configuration original, {
    Set<Node> nodes,
    Node nearestNode,
    Duration connectionTimeout,
    Duration healthcheckInterval,
    int numRetries,
    Duration retryInterval,
    String apiKey,
    bool sendApiKeyAsQueryParam,
  }) =>
      Configuration._(
        nodes: nodes ?? original.nodes,
        nearestNode: nearestNode ?? original.nearestNode,
        connectionTimeout: connectionTimeout ?? original.connectionTimeout,
        healthcheckInterval:
            healthcheckInterval ?? original.healthcheckInterval,
        numRetries: numRetries ?? original.numRetries,
        retryInterval: retryInterval ?? original.retryInterval,
        apiKey: apiKey ?? original.apiKey,
        sendApiKeyAsQueryParam:
            sendApiKeyAsQueryParam ?? original.sendApiKeyAsQueryParam,
      );

  @override
  String toString() => '''
{
  Nodes: $nodes
  Nearest node: $nearestNode
  Connection timeout: $connectionTimeout
  Health check interval: $healthcheckInterval
  Retries: $numRetries
  Retry interval: $retryInterval
  Api key: $apiKey
  Send api key in query: $sendApiKeyAsQueryParam
}
''';

  @override
  bool operator ==(Object o) =>
      identical(this, o) ||
      (o is Configuration &&
          runtimeType == o.runtimeType &&
          SetEquality<Node>().equals(this.nodes, o.nodes) &&
          this.nearestNode == o.nearestNode &&
          this.connectionTimeout == o.connectionTimeout &&
          this.healthcheckInterval == o.healthcheckInterval &&
          this.numRetries == o.numRetries &&
          this.retryInterval == o.retryInterval &&
          this.apiKey == o.apiKey &&
          this.sendApiKeyAsQueryParam == o.sendApiKeyAsQueryParam);

  @override
  int get hashCode =>
      nodes.hashCode ^
      nearestNode.hashCode ^
      connectionTimeout.hashCode ^
      healthcheckInterval.hashCode ^
      numRetries.hashCode ^
      retryInterval.hashCode ^
      apiKey.hashCode ^
      sendApiKeyAsQueryParam.hashCode;
}
