import 'package:equatable/equatable.dart';

import 'exceptions/exceptions.dart' show MissingConfiguration;
import 'models/node.dart';

class Configuration extends Equatable {
  final String apiKey;
  final Set<Node>? nodes;
  final Node? nearestNode;
  late final int numRetries;
  final Duration retryInterval;
  final Duration connectionTimeout;
  final Duration healthcheckInterval;
  final Duration cachedSearchResultsTTL;
  final bool sendApiKeyAsQueryParam;

  Configuration(
    this.apiKey, {
    this.nodes,
    this.nearestNode,
    int? numRetries,
    this.retryInterval = const Duration(milliseconds: 100),
    this.connectionTimeout = const Duration(seconds: 10),
    this.healthcheckInterval = const Duration(seconds: 15),
    this.cachedSearchResultsTTL = Duration.zero,
    this.sendApiKeyAsQueryParam = false,
  }) {
    if (apiKey.isEmpty) {
      throw MissingConfiguration(
          'Ensure that Configuration.apiKey is not empty');
    }
    if (nodes?.isEmpty ?? false) {
      throw MissingConfiguration(
          'Ensure that Configuration.nodes is not empty');
    }
    if (nodes == null && nearestNode == null) {
      throw MissingConfiguration(
          'Ensure that at least one node is present in Configuration');
    }
    this.numRetries =
        numRetries ?? (nodes?.length ?? 0) + (nearestNode == null ? 0 : 1);
  }

  /// Returns a new [Configuration] object which differs only in the specified
  /// values from this object.
  Configuration copyWith({
    String? apiKey,
    Set<Node>? nodes,
    Node? nearestNode,
    int? numRetries,
    Duration? retryInterval,
    Duration? connectionTimeout,
    Duration? healthcheckInterval,
    Duration? cachedSearchResultsTTL,
    bool? sendApiKeyAsQueryParam,
  }) =>
      Configuration(
        apiKey ?? this.apiKey,
        nodes: nodes ?? this.nodes,
        nearestNode: nearestNode ?? this.nearestNode,
        numRetries: numRetries ?? this.numRetries,
        retryInterval: retryInterval ?? this.retryInterval,
        connectionTimeout: connectionTimeout ?? this.connectionTimeout,
        healthcheckInterval: healthcheckInterval ?? this.healthcheckInterval,
        cachedSearchResultsTTL:
            cachedSearchResultsTTL ?? this.cachedSearchResultsTTL,
        sendApiKeyAsQueryParam:
            sendApiKeyAsQueryParam ?? this.sendApiKeyAsQueryParam,
      );

  @override
  String toString() => '''
{
  Api key: $apiKey
  Nodes: $nodes
  Nearest node: $nearestNode
  Retries: $numRetries
  Retry interval: $retryInterval
  Connection timeout: $connectionTimeout
  Health check interval: $healthcheckInterval
  Cached search results Time To Live: $cachedSearchResultsTTL
  Send api key in query: $sendApiKeyAsQueryParam
}
''';

  @override
  List<Object> get props {
    return [
      apiKey,
      nodes ?? '',
      nearestNode ?? '',
      numRetries,
      retryInterval,
      connectionTimeout,
      healthcheckInterval,
      cachedSearchResultsTTL,
      sendApiKeyAsQueryParam,
    ];
  }
}
