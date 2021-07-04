import 'package:equatable/equatable.dart';

import 'exceptions/exceptions.dart' show MissingConfiguration;
import 'models/node.dart';

class Configuration extends Equatable {
  final Set<Node> nodes;
  final Node nearestNode;
  final Duration connectionTimeout;
  final Duration healthcheckInterval;
  final int numRetries;
  final Duration retryInterval;
  final String apiKey;
  final bool sendApiKeyAsQueryParam;
  final Duration cachedSearchResultsTTL;

  const Configuration._({
    this.nodes,
    this.nearestNode,
    this.connectionTimeout,
    this.healthcheckInterval,
    this.numRetries,
    this.retryInterval,
    this.apiKey,
    this.sendApiKeyAsQueryParam,
    this.cachedSearchResultsTTL,
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
    Duration cachedSearchResultsTTL,
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
      cachedSearchResultsTTL: cachedSearchResultsTTL ??=
          Duration.zero, // Disable cache by default
    );
  }

  /// Returns a new [Configuration] object which differs only in the specified
  /// values from the [original] object.
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
    Duration cachedSearchResultsTTL,
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
        cachedSearchResultsTTL:
            cachedSearchResultsTTL ?? original.cachedSearchResultsTTL,
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
  Cached search results Time To Live: $cachedSearchResultsTTL
}
''';

  @override
  List<Object> get props {
    return [
      nodes,
      nearestNode,
      connectionTimeout,
      healthcheckInterval,
      numRetries,
      retryInterval,
      apiKey,
      sendApiKeyAsQueryParam,
      cachedSearchResultsTTL,
    ];
  }
}
