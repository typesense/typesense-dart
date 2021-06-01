import 'package:test/test.dart';

import 'package:typesense/src/configuration.dart';
import 'package:typesense/src/models/node.dart';
import 'package:typesense/src/exceptions.dart' show MissingConfiguration;

import 'test_utils.dart';

void main() {
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
    retryInterval: Duration(seconds: 3),
    sendApiKeyAsQueryParam: true,
  );

  group('Configuration', () {
    test('has a nodes field', () {
      expect(config.nodes, isNotEmpty);
      expect(config.nodes.length, equals(1));

      expect(config.nodes.first.uri.port, equals(443));
      expect(config.nodes.first.uri.toString(),
          equals('https://localhost/path/to/service'));
    });
    test('has a nearestNode field', () {
      expect(config.nearestNode.uri.port, equals(80));
      expect(config.nearestNode.uri.toString(),
          equals('http://localhost/path/to/service'));
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
      expect(config.retryInterval, equals(Duration(seconds: 3)));
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
        retryInterval: Duration(seconds: 3),
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
        retryInterval: Duration(seconds: 3),
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
        retryInterval: Duration(seconds: 3),
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
        retryInterval: Duration(seconds: 3),
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
      expect(config.retryInterval, equals(Duration(milliseconds: 100)));
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
        retryInterval: Duration(seconds: 3),
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
          retryInterval: Duration(seconds: 3),
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
          retryInterval: Duration(seconds: 3),
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
    test(
        'using updateParameters factory constructor returns a new Configuration object with changes',
        () {
      var updatedConfig = Configuration.updateParameters(config,
          apiKey: 'newKey',
          healthcheckInterval: Duration(minutes: 1),
          sendApiKeyAsQueryParam: false);
      expect(config.apiKey == updatedConfig.apiKey, isFalse);
      expect(updatedConfig.apiKey, equals('newKey'));
      expect(config.healthcheckInterval == updatedConfig.healthcheckInterval,
          isFalse);
      expect(
          config.sendApiKeyAsQueryParam == updatedConfig.sendApiKeyAsQueryParam,
          isFalse);
      expect(updatedConfig.sendApiKeyAsQueryParam, isFalse);

      expect(updatedConfig.connectionTimeout, equals(config.connectionTimeout));
      expect(updatedConfig.nearestNode, equals(config.nearestNode));
      expect(updatedConfig.nodes, equals(config.nodes));
      expect(updatedConfig.numRetries, equals(config.numRetries));
      expect(updatedConfig.retryInterval, equals(config.retryInterval));
    });
  });

  test('Configurations are equatable', () {
    expect(
        ConfigurationFactory.withNearestNode ==
            ConfigurationFactory.withNearestNode,
        isTrue);
    expect(
        ConfigurationFactory.withoutNearestNode ==
            ConfigurationFactory.withoutNearestNode,
        isTrue);
  });
}
