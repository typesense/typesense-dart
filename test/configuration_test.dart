import 'package:test/test.dart';

import 'package:typesense/src/configuration.dart';
import 'package:typesense/src/exceptions.dart' show MissingConfiguration;

void main() {
  group('Node', () {
    Node node;
    setUp(() {
      node = Node(
        protocol: 'http',
        host: 'localhost',
        port: 80,
        path: '/path/to/service',
      );
    });

    test('has a protocol field', () {
      expect(node.protocol, equals('http'));
    });
    test('has a host field', () {
      expect(node.host, equals('localhost'));
    });
    test('has a port field', () {
      expect(node.port, equals(80));
    });
    test('has a path field', () {
      expect(node.path, equals('/path/to/service'));
    });
    test('has a url field', () {
      expect(node.url, equals('http://localhost:80/path/to/service'));
    });
    test('has a isHealthy field', () {
      expect(node.isHealthy, isTrue);
    });
  });
  group('Node initialization', () {
    test('with missing port and http protocol, sets port to 80', () {
      final node = Node(
        protocol: 'http',
        host: 'localhost',
        path: '/path/to/service',
      );
      expect(node.protocol, equals('http'));
      expect(node.port, equals(80));
    });
    test('with missing port and https protocol, sets port to 443', () {
      final node = Node(
        protocol: 'https',
        host: 'localhost',
        path: '/path/to/service',
      );
      expect(node.protocol, equals('https'));
      expect(node.port, equals(443));
    });
    test('with missing path, sets path as empty String', () {
      final node = Node(
        protocol: 'http',
        host: 'localhost',
        port: 80,
      );
      expect(node.protocol, equals('http'));
      expect(node.host, equals('localhost'));
      expect(node.port, equals(80));
      expect(node.path, equals(''));
    });

    test('with missing protocol throws', () {
      expect(
        () => Node(
          host: 'localhost',
          port: 80,
          path: '/path/to/service',
        ),
        throwsA(
          isA<MissingConfiguration>().having(
            (e) => e.message,
            'message',
            'Ensure that Node.protocol is set',
          ),
        ),
      );
    });
    test('with missing host throws', () {
      expect(
        () => Node(
          protocol: 'http',
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
    test('with missing port and invalid protocol throws', () {
      expect(
        () => Node(
          protocol: 'ws',
          host: 'localhost',
          path: '/path/to/service',
        ),
        throwsA(
          isA<MissingConfiguration>().having(
            (e) => e.message,
            'message',
            'Ensure that Node.protocol is valid',
          ),
        ),
      );
    });
    test('with null path throws', () {
      expect(
        () => Node(
          protocol: 'http',
          host: 'localhost',
          port: 80,
          path: null,
        ),
        throwsA(
          isA<MissingConfiguration>().having(
            (e) => e.message,
            'message',
            'Ensure that Node.path is set',
          ),
        ),
      );
    });
  });

  group('Configuration', () {
    Configuration config;
    setUp(() {
      config = Configuration(
        apiKey: 'abc123',
        connectionTimeout: Duration(seconds: 10),
        healthcheckInterval: Duration(seconds: 5),
        nearestNode: Node(
          protocol: 'http',
          host: 'localhost',
          path: '/path/to/service',
        ),
        nodes: {
          Node(
            protocol: 'https',
            host: 'localhost',
            path: '/path/to/service',
          ),
        },
        numRetries: 5,
        retryIntervalSeconds: Duration(seconds: 3),
        sendApiKeyAsQueryParam: true,
      );
    });
    test('has a nodes field', () {
      expect(config.nodes, isNotEmpty);
      expect(config.nodes.length, equals(1));
      expect(config.nodes.first.url,
          equals('https://localhost:443/path/to/service'));
    });
    test('has a nearestNode field', () {
      expect(config.nearestNode.url,
          equals('http://localhost:80/path/to/service'));
    });
    test('has a connectionTimeout field', () {
      expect(config.connectionTimeout, equals(Duration(seconds: 10)));
    });
    test('has a healthcheckInterval field', () {
      expect(config.healthcheckInterval, equals(Duration(seconds: 5)));
    });
    test('has a numRetries field', () {
      expect(config.numRetries, equals(5));
    });
    test('has a retryIntervalSeconds field', () {
      expect(config.retryIntervalSeconds, equals(Duration(seconds: 3)));
    });
    test('has a apiKey field', () {
      expect(config.apiKey, equals('abc123'));
    });
    test('has a sendApiKeyAsQueryParam field', () {
      expect(config.sendApiKeyAsQueryParam, isTrue);
    });
  });

  group('Configuration initialization', () {
    test('with missing nearestNode, sets nearestNode to null', () {
      final config = Configuration(
        apiKey: 'abc123',
        connectionTimeout: Duration(seconds: 10),
        healthcheckInterval: Duration(seconds: 5),
        nodes: {
          Node(
            protocol: 'https',
            host: 'localhost',
            path: '/path/to/service',
          ),
        },
        numRetries: 5,
        retryIntervalSeconds: Duration(seconds: 3),
        sendApiKeyAsQueryParam: true,
      );
      expect(config.nearestNode, isNull);
    });
    test('with missing connectionTimeout, sets connectionTimeout to 5 seconds',
        () {
      final config = Configuration(
        apiKey: 'abc123',
        healthcheckInterval: Duration(seconds: 5),
        nearestNode: Node(
          protocol: 'http',
          host: 'localhost',
          path: '/path/to/service',
        ),
        nodes: {
          Node(
            protocol: 'https',
            host: 'localhost',
            path: '/path/to/service',
          ),
        },
        numRetries: 5,
        retryIntervalSeconds: Duration(seconds: 3),
        sendApiKeyAsQueryParam: true,
      );
      expect(config.connectionTimeout, equals(Duration(seconds: 10)));
    });
    test(
        'with missing healthcheckInterval, sets healthcheckInterval to 15 seconds',
        () {
      final config = Configuration(
        apiKey: 'abc123',
        connectionTimeout: Duration(seconds: 10),
        nearestNode: Node(
          protocol: 'http',
          host: 'localhost',
          path: '/path/to/service',
        ),
        nodes: {
          Node(
            protocol: 'https',
            host: 'localhost',
            path: '/path/to/service',
          ),
        },
        numRetries: 5,
        retryIntervalSeconds: Duration(seconds: 3),
        sendApiKeyAsQueryParam: true,
      );
      expect(config.healthcheckInterval, equals(Duration(seconds: 15)));
    });
    test(
        'with missing numRetries, sets numRetries to number of nodes in Configuration.nodes + number of nearest node',
        () {
      final config = Configuration(
        apiKey: 'abc123',
        connectionTimeout: Duration(seconds: 10),
        healthcheckInterval: Duration(seconds: 5),
        nearestNode: Node(
          protocol: 'http',
          host: 'localhost',
          path: '/path/to/service',
        ),
        nodes: {
          Node(
            protocol: 'https',
            host: 'localhost',
            path: '/path/to/service',
          ),
        },
        retryIntervalSeconds: Duration(seconds: 3),
        sendApiKeyAsQueryParam: true,
      );
      expect(config.numRetries, equals(config.nodes.length + 1));
    });
    test(
        'with missing retryIntervalSeconds, sets retryIntervalSeconds to 100 milliseconds',
        () {
      final config = Configuration(
        apiKey: 'abc123',
        connectionTimeout: Duration(seconds: 10),
        healthcheckInterval: Duration(seconds: 5),
        nearestNode: Node(
          protocol: 'http',
          host: 'localhost',
          path: '/path/to/service',
        ),
        nodes: {
          Node(
            protocol: 'https',
            host: 'localhost',
            path: '/path/to/service',
          ),
        },
        numRetries: 5,
        sendApiKeyAsQueryParam: true,
      );
      expect(config.retryIntervalSeconds, equals(Duration(milliseconds: 100)));
    });
    test(
        'with missing sendApiKeyAsQueryParam, sets sendApiKeyAsQueryParam to false',
        () {
      final config = Configuration(
        apiKey: 'abc123',
        connectionTimeout: Duration(seconds: 10),
        healthcheckInterval: Duration(seconds: 5),
        nearestNode: Node(
          protocol: 'http',
          host: 'localhost',
          path: '/path/to/service',
        ),
        nodes: {
          Node(
            protocol: 'https',
            host: 'localhost',
            path: '/path/to/service',
          ),
        },
        numRetries: 5,
        retryIntervalSeconds: Duration(seconds: 3),
      );
      expect(config.sendApiKeyAsQueryParam, isFalse);
    });
    test('with missing nodes throws', () {
      expect(
        () => Configuration(
          apiKey: 'abc123',
          connectionTimeout: Duration(seconds: 10),
          healthcheckInterval: Duration(seconds: 5),
          nearestNode: Node(
            protocol: 'http',
            host: 'localhost',
            path: '/path/to/service',
          ),
          numRetries: 5,
          retryIntervalSeconds: Duration(seconds: 3),
          sendApiKeyAsQueryParam: true,
        ),
        throwsA(
          isA<MissingConfiguration>().having(
            (e) => e.message,
            'message',
            'Ensure that Configuration.nodes is set',
          ),
        ),
      );
    });
    test('with missing apiKey throws', () {
      expect(
        () => Configuration(
          connectionTimeout: Duration(seconds: 10),
          healthcheckInterval: Duration(seconds: 5),
          nearestNode: Node(
            protocol: 'http',
            host: 'localhost',
            path: '/path/to/service',
          ),
          nodes: {
            Node(
              protocol: 'https',
              host: 'localhost',
              path: '/path/to/service',
            ),
          },
          numRetries: 5,
          retryIntervalSeconds: Duration(seconds: 3),
          sendApiKeyAsQueryParam: true,
        ),
        throwsA(
          isA<MissingConfiguration>().having(
            (e) => e.message,
            'message',
            'Ensure that Configuration.apiKey is set',
          ),
        ),
      );
    });
  });
}
