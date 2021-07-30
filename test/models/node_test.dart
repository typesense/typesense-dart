import 'package:test/test.dart';
import 'package:http/http.dart' as http;

import 'package:typesense/src/models/node.dart';
import 'package:typesense/src/exceptions/exceptions.dart'
    show MissingConfiguration;

void main() {
  group('Node', () {
    late Node node;
    setUp(() {
      node = Node(
        Protocol.http,
        'localhost',
        port: 8080,
        path: '/path/to/service',
        client: http.Client(),
      );
    });

    test('has a protocol field', () {
      expect(node.protocol, equals(Protocol.http));
    });
    test('has a host field', () {
      expect(node.host, equals('localhost'));
    });
    test('has a port field', () {
      expect(node.port, equals(8080));
    });
    test('has a path field', () {
      expect(node.path, equals('/path/to/service'));
    });
    test('has a uri field', () {
      expect(
          node.uri.toString(), equals('http://localhost:8080/path/to/service'));
    });
    test('has a isHealthy field', () {
      expect(node.isHealthy, isTrue);
    });
    test('has a lastAccessTimestamp field', () {
      final dateTime = DateTime.now();
      node.lastAccessTimestamp = dateTime;

      expect(node.lastAccessTimestamp, equals(dateTime));
    });
    test('has a client field', () {
      expect(node.client, isA<http.BaseClient>());
    });
    test('has a isDueForHealthCheck method', () async {
      final healthcheckInterval = Duration(seconds: 2);

      node.lastAccessTimestamp = DateTime.now();
      await Future.delayed(Duration(seconds: 1, milliseconds: 100));
      expect(node.isDueForHealthCheck(healthcheckInterval), isFalse);

      node.lastAccessTimestamp = DateTime.now();
      await Future.delayed(Duration(seconds: 2, milliseconds: 100));
      expect(node.isDueForHealthCheck(healthcheckInterval), isTrue);
    });
  });

  group('Node initialization', () {
    test('with missing port and http protocol, sets port to 80', () {
      final node = Node(
        Protocol.http,
        'localhost',
        path: '/path/to/service',
      );

      expect(node.port, equals(80));
    });
    test('with missing port and https protocol, sets port to 443', () {
      final node = Node(
        Protocol.https,
        'localhost',
        path: '/path/to/service',
      );

      expect(node.port, equals(443));
    });
    test('with missing path, sets path as empty String', () {
      final node = Node(
        Protocol.http,
        'localhost',
        port: 80,
      );

      expect(node.path, equals(''));
    });
    test('with empty host throws', () {
      expect(
        () => Node(
          Protocol.http,
          '',
          port: 80,
          path: '/path/to/service',
        ),
        throwsA(
          isA<MissingConfiguration>().having(
            (e) => e.message,
            'message',
            'Ensure that Node.host is set',
          ),
        ),
      );
    });
  });
}
