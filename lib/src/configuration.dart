import 'exceptions.dart' show MissingConfiguration;

class Configuration {
  final List<Node> nodes;
  final Node nearestNode;
  final Duration connectionTimeout;
  final Duration healthcheckInterval;
  int numRetries;
  final Duration retryIntervalSeconds;
  final String apiKey;
  final bool sendApiKeyAsQueryParam;

  Configuration({
    this.nodes,
    this.nearestNode,
    this.connectionTimeout = const Duration(seconds: 10),
    this.healthcheckInterval = const Duration(seconds: 15),
    this.numRetries,
    this.retryIntervalSeconds = const Duration(milliseconds: 100),
    this.apiKey,
    this.sendApiKeyAsQueryParam = false,
  }) {
    if (nodes == null || nodes.isEmpty)
      throw MissingConfiguration('Ensure that Configuration.nodes is set');

    if (numRetries == null)
      numRetries = nodes.length + (nearestNode == null ? 0 : 1);

    if (apiKey == null || apiKey.isEmpty)
      throw MissingConfiguration('Ensure that Configuration.apiKey is set');
  }
}

class Node {
  final String protocol;
  final String host;
  int port;
  final String path;
  bool isHealthy = true;

  Node({
    this.protocol,
    this.host,
    this.port,
    this.path = '',
  }) {
    if (protocol == null)
      throw MissingConfiguration('Ensure that Node.protocol is set');

    if (host == null)
      throw MissingConfiguration('Ensure that Node.host is set');

    if (port == null) {
      switch (protocol) {
        case 'https':
          port = 443;
          break;
        case 'http':
          port = 80;
          break;
        default:
          throw MissingConfiguration('Ensure that Node.protocol is valid');
      }
    }

    if (path == null)
      throw MissingConfiguration('Ensure that Node.path is set');
  }

  String get url => '$protocol://$host:$port$path';
}
