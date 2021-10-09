import 'package:test/test.dart';
import 'package:http/http.dart' as http;

import 'package:typesense/src/models/models.dart';
import 'package:typesense/src/exceptions/exceptions.dart'
    show MissingConfiguration;

const host = 'localhost';
const path = '/path/to/service';

void main() {
  group('Node', () {
    final n1 = Node(
      Protocol.http,
      host,
      port: 8080,
      path: path,
      client: http.Client(),
    );
    final n2 = Node.withUri(
      Uri(
        scheme: 'http',
        host: host,
        port: 8080,
        path: path,
      ),
      client: http.Client(),
    );

    test('has a protocol field', () {
      expect(n1.protocol, equals(Protocol.http));
      expect(n2.protocol, equals(Protocol.http));
    });
    test('has a host field', () {
      expect(n1.host, equals('localhost'));
      expect(n2.host, equals('localhost'));
    });
    test('has a port field', () {
      expect(n1.port, equals(8080));
      expect(n2.port, equals(8080));
    });
    test('has a path field', () {
      expect(n1.path, equals('/path/to/service'));
      expect(n2.path, equals('/path/to/service'));
    });
    test('has a uri field', () {
      expect(
          n1.uri.toString(), equals('http://localhost:8080/path/to/service'));
      expect(
          n2.uri.toString(), equals('http://localhost:8080/path/to/service'));
    });
    test('has a isHealthy field', () {
      expect(n1.isHealthy, isTrue);
      expect(n2.isHealthy, isTrue);
    });
    test('has a lastAccessTimestamp field', () {
      final dateTime = DateTime.now();
      n1.lastAccessTimestamp = dateTime;
      n2.lastAccessTimestamp = dateTime;

      expect(n1.lastAccessTimestamp, equals(dateTime));
      expect(n2.lastAccessTimestamp, equals(dateTime));
    });
    test('has a client field', () {
      expect(n1.client, isA<http.BaseClient>());
      expect(n2.client, isA<http.BaseClient>());
    });
    test('has a isDueForHealthCheck method', () async {
      final healthcheckInterval = Duration(seconds: 2);

      n1.lastAccessTimestamp = DateTime.now();
      await Future.delayed(Duration(seconds: 1, milliseconds: 100));
      expect(n1.isDueForHealthCheck(healthcheckInterval), isFalse);

      n1.lastAccessTimestamp = DateTime.now();
      await Future.delayed(Duration(seconds: 2, milliseconds: 100));
      expect(n1.isDueForHealthCheck(healthcheckInterval), isTrue);
    });
  });

  group('Node initialization', () {
    test('with missing port and http protocol, sets port to 80', () {
      final n1 = Node(Protocol.http, host, path: path);
      final n2 = Node.withUri(Uri(scheme: 'http', host: host, path: path));

      expect(n1.port, equals(80));
      expect(n2.port, equals(80));
    });
    test('with missing port and https protocol, sets port to 443', () {
      final n1 = Node(Protocol.https, 'localhost', path: '/path/to/service');
      final n2 = Node.withUri(Uri(scheme: 'https', host: host, path: path));

      expect(n1.port, equals(443));
      expect(n2.port, equals(443));
    });
    test('with missing path, sets path as empty String', () {
      final n1 = Node(Protocol.http, 'localhost', port: 80);
      final n2 = Node.withUri(Uri(scheme: 'http', host: host, port: 80));

      expect(n1.path, isEmpty);
      expect(n2.path, isEmpty);
    });
    test('with empty host throws', () {
      expect(
        () => Node(Protocol.http, '', port: 80, path: path),
        throwsA(
          isA<MissingConfiguration>().having(
            (e) => e.message,
            'message',
            'Ensure that Node.host is not empty',
          ),
        ),
      );
      expect(
        () => Node.withUri(Uri(scheme: 'http', host: '', port: 80, path: path)),
        throwsA(
          isA<MissingConfiguration>().having(
            (e) => e.message,
            'message',
            'Ensure that Node.host is not empty',
          ),
        ),
      );
    });
  });
}
