import 'package:http/http.dart' as http;

import '../exceptions/exceptions.dart';

class Node {
  late final Uri uri;

  bool isHealthy = true;

  /// Records the latest timestamp when the [Node] was accessed to complete a
  /// request.
  ///
  /// Nodes are assumed to be healthy at start. So the node is used and
  /// [lastAccessTimestamp] is set before getting it's value.
  late DateTime lastAccessTimestamp;

  /// http [client] associated with the [Node], used to complete requests.
  http.Client? client;

  Node(
    Protocol protocol,
    String host, {
    int? port,
    String path = '',
    this.client,
  }) {
    if (host.isEmpty) {
      throw MissingConfiguration('Ensure that Node.host is not empty');
    }

    if (port == null) {
      switch (protocol) {
        case Protocol.https:
          port = 443;
          break;
        case Protocol.http:
          port = 80;
          break;
      }
    }

    uri = Uri(
      scheme: protocol.value(),
      host: host,
      port: port,
      path: path,
    );
  }

  Node.withUri(this.uri, {this.client}) {
    if (host.isEmpty) {
      throw MissingConfiguration('Ensure that Node.host is not empty');
    }
  }

  Protocol get protocol => _Protocol.fromValue(uri.scheme);
  String get host => uri.host;
  int get port => uri.port;
  String get path => uri.path;

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

enum Protocol {
  http,
  https,
}

extension _Protocol on Protocol {
  String value() => toString().split('.')[1];

  static Protocol fromValue(String value) {
    switch (value) {
      case 'http':
        return Protocol.http;

      case 'https':
        return Protocol.https;

      default:
        throw ArgumentError('$value is an unsupported protocol');
    }
  }
}
