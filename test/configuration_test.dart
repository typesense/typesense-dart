import 'package:test/test.dart';

import 'package:typesense/typesense.dart';

import 'test_utils.dart';

void main() {
  final config = Configuration(
    'abc123',
    nodes: {
      Node(
        Protocol.https,
        'localhost',
        path: pathToService,
      ),
    },
    nearestNode: Node(
      Protocol.http,
      'localhost',
      path: pathToService,
    ),
    connectionTimeout: Duration(seconds: 10),
    healthcheckInterval: Duration(seconds: 5),
    numRetries: 5,
    retryInterval: Duration(seconds: 3),
    sendApiKeyAsQueryParam: true,
    cachedSearchResultsTTL: Duration(seconds: 30),
  );

  group('Configuration', () {
    test('has an apiKey field', () {
      expect(config.apiKey, equals('abc123'));
    });
    test('has a nodes field', () {
      expect(config.nodes, isNotEmpty);
      expect(config.nodes!.length, equals(1));

      expect(config.nodes!.first.uri.port, equals(443));
      expect(config.nodes!.first.uri.toString(),
          equals('https://localhost/path/to/service'));
    });
    test('has a nearestNode field', () {
      expect(config.nearestNode!.port, equals(80));
      expect(config.nearestNode!.uri.toString(),
          equals('http://localhost/path/to/service'));
    });
    test('has a numRetries field', () {
      expect(config.numRetries, equals(5));
    });
    test('has a retryInterval field', () {
      expect(config.retryInterval, equals(Duration(seconds: 3)));
    });
    test('has a connectionTimeout field', () {
      expect(config.connectionTimeout, equals(Duration(seconds: 10)));
    });
    test('has a healthcheckInterval field', () {
      expect(config.healthcheckInterval, equals(Duration(seconds: 5)));
    });
    test('has a cacheSearchResults field', () {
      expect(config.cachedSearchResultsTTL, equals(Duration(seconds: 30)));
    });
    test('has a sendApiKeyAsQueryParam field', () {
      expect(config.sendApiKeyAsQueryParam, isTrue);
    });
    test('has a copyWith method', () {
      var updatedConfig = config.copyWith(
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
      expect(updatedConfig.cachedSearchResultsTTL,
          equals(config.cachedSearchResultsTTL));
    });
  });

  group('Configuration initialization', () {
    test('with an empty apiKey throws', () {
      expect(
        () => Configuration(
          '',
          connectionTimeout: Duration(seconds: 10),
          healthcheckInterval: Duration(seconds: 5),
          nearestNode: NearestNode,
          nodes: {MockNode},
          numRetries: 5,
          retryInterval: Duration(seconds: 3),
          sendApiKeyAsQueryParam: true,
        ),
        throwsA(
          isA<MissingConfiguration>().having(
            (e) => e.message,
            'message',
            'Ensure that Configuration.apiKey is not empty',
          ),
        ),
      );
    });
    test('with null nodes and nearestNode throws', () {
      expect(
        () => Configuration(
          'abc123',
          connectionTimeout: Duration(seconds: 10),
          healthcheckInterval: Duration(seconds: 5),
          numRetries: 5,
          retryInterval: Duration(seconds: 3),
          sendApiKeyAsQueryParam: true,
        ),
        throwsA(
          isA<MissingConfiguration>().having(
            (e) => e.message,
            'message',
            'Ensure that at least one node is present in Configuration',
          ),
        ),
      );
    });
    test(
        'with missing numRetries, sets numRetries to number of nodes in Configuration.nodes + number of nearest node',
        () {
      final config = Configuration(
        'abc123',
        connectionTimeout: Duration(seconds: 10),
        healthcheckInterval: Duration(seconds: 5),
        nearestNode: NearestNode,
        nodes: {MockNode},
        retryInterval: Duration(seconds: 3),
        sendApiKeyAsQueryParam: true,
      );
      expect(config.numRetries, equals(config.nodes!.length + 1));
    });
    test(
        'with missing retryIntervalSeconds, sets retryIntervalSeconds to 100 milliseconds',
        () {
      final config = Configuration(
        'abc123',
        connectionTimeout: Duration(seconds: 10),
        healthcheckInterval: Duration(seconds: 5),
        nearestNode: NearestNode,
        nodes: {MockNode},
        numRetries: 5,
        sendApiKeyAsQueryParam: true,
      );
      expect(config.retryInterval, equals(Duration(milliseconds: 100)));
    });
    test('with missing connectionTimeout, sets connectionTimeout to 5 seconds',
        () {
      final config = Configuration(
        'abc123',
        healthcheckInterval: Duration(seconds: 5),
        nearestNode: NearestNode,
        nodes: {MockNode},
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
        'abc123',
        connectionTimeout: Duration(seconds: 10),
        nearestNode: NearestNode,
        nodes: {MockNode},
        numRetries: 5,
        retryInterval: Duration(seconds: 3),
        sendApiKeyAsQueryParam: true,
      );
      expect(config.healthcheckInterval, equals(Duration(seconds: 15)));
    });
    test(
        'with missing cachedSearchResultsTTL, sets cachedSearchResultsTTL to 0',
        () {
      final config = Configuration(
        'abc123',
        nearestNode: NearestNode,
        nodes: {MockNode},
        connectionTimeout: Duration(seconds: 10),
        healthcheckInterval: Duration(seconds: 5),
        numRetries: 5,
        retryInterval: Duration(seconds: 3),
        sendApiKeyAsQueryParam: true,
      );
      expect(config.cachedSearchResultsTTL, equals(Duration.zero));
    });
    test(
        'with missing sendApiKeyAsQueryParam, sets sendApiKeyAsQueryParam to false',
        () {
      final config = Configuration(
        'abc123',
        connectionTimeout: Duration(seconds: 10),
        healthcheckInterval: Duration(seconds: 5),
        nearestNode: NearestNode,
        nodes: {MockNode},
        numRetries: 5,
        retryInterval: Duration(seconds: 3),
      );
      expect(config.sendApiKeyAsQueryParam, isFalse);
    });
  });
}
