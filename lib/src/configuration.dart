import 'exceptions.dart' show MissingConfiguration;

class Configuration {
  final Set<Node> nodes;
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
    if (nodes == null || nodes.isEmpty) {
      throw MissingConfiguration('Ensure that Configuration.nodes is set');
    }

    if (numRetries == null) {
      numRetries = nodes.length + (nearestNode == null ? 0 : 1);
    }

    if (apiKey == null || apiKey.isEmpty) {
      throw MissingConfiguration('Ensure that Configuration.apiKey is set');
    }
  }
}

class Node {
  final String protocol;
  final String host;
  int _port;
  final String path;
  String _url;
  bool isHealthy = true;

  Node({
    this.protocol,
    this.host,
    int port,
    this.path = '',
  }) {
    if (protocol == null) {
      throw MissingConfiguration('Ensure that Node.protocol is set');
    }

    if (host == null) {
      throw MissingConfiguration('Ensure that Node.host is set');
    }

    if (port == null) {
      switch (protocol) {
        case 'https':
          _port = 443;
          break;
        case 'http':
          _port = 80;
          break;
        default:
          throw MissingConfiguration('Ensure that Node.protocol is valid');
      }
    } else {
      _port = port;
    }

    if (path == null) {
      throw MissingConfiguration('Ensure that Node.path is set');
    }

    _url = '$protocol://$host:$_port$path';
  }

  int get port => _port;

  String get url => _url;

  @override
  int get hashCode => url.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Node && this.url == other.url);

  @override
  String toString() => url;
}
