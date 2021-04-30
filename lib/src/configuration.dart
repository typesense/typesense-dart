import 'package:http/http.dart' as http;

import 'exceptions.dart' show MissingConfiguration;

class Configuration {
  final Set<Node> nodes;
  final Node nearestNode;
  final Duration connectionTimeout;
  final Duration healthcheckInterval;
  int numRetries;
  final Duration retryInterval;
  final String apiKey;
  final bool sendApiKeyAsQueryParam;

  Configuration({
    this.nodes,
    this.nearestNode,
    this.connectionTimeout = const Duration(seconds: 10),
    this.healthcheckInterval = const Duration(seconds: 15),
    this.numRetries,
    this.retryInterval = const Duration(milliseconds: 100),
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
  Uri _uri;

  bool isHealthy = true;

  /// Records the latest timestamp when the [Node] was accessed to complete a
  /// request.
  DateTime lastAccessTimestamp;

  /// http [client] associated with the [Node], used to complete requests.
  http.Client client;

  Node({
    this.protocol,
    this.host,
    int port,
    this.path = '',
    this.client,
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

    _uri = Uri.parse('$protocol://$host:$_port$path');
  }

  int get port => _port;

  Uri get uri => _uri;

  @override
  int get hashCode => uri.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Node && this.uri == other.uri);

  @override
  String toString() => uri.toString();

  bool isDueForHealthCheck(Duration healthcheckInterval) =>
      DateTime.now().difference(lastAccessTimestamp) > healthcheckInterval;
}
