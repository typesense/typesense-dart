import 'package:http/http.dart' as http;

import '../exceptions/exceptions.dart';

class Node {
  final String protocol;
  final String host;
  final int port;
  final String path;
  final Uri uri;

  bool isHealthy = true;

  /// Records the latest timestamp when the [Node] was accessed to complete a
  /// request.
  DateTime lastAccessTimestamp;

  /// http [client] associated with the [Node], used to complete requests.
  http.Client client;

  Node._(
      {this.protocol, this.host, this.port, this.path, this.uri, this.client});

  factory Node({
    String protocol,
    String host,
    int port,
    String path = '',
    http.Client client,
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
          port = 443;
          break;
        case 'http':
          port = 80;
          break;
        default:
          throw MissingConfiguration('Ensure that Node.protocol is valid');
      }
    } else {
      port = port;
    }

    if (path == null) {
      throw MissingConfiguration('Ensure that Node.path is set');
    }

    return Node._(
        protocol: protocol,
        host: host,
        port: port,
        path: path,
        uri: Uri.parse('$protocol://$host:$port$path'),
        client: client);
  }

  @override
  int get hashCode => uri.hashCode;

  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Node && runtimeType == other.runtimeType && uri == other.uri);

  @override
  String toString() => uri.toString();

  bool isDueForHealthCheck(Duration healthcheckInterval) =>
      DateTime.now().difference(lastAccessTimestamp) > healthcheckInterval;
}
