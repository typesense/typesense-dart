import 'dart:async';
import 'dart:convert';

import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mockito/mockito.dart';

import 'package:typesense/src/services/collections_api_call.dart';
import 'package:typesense/src/services/node_pool.dart';
import 'package:typesense/src/models/node.dart';
import 'package:typesense/src/exceptions.dart';

import '../test_utils.dart';

class MockResponse extends Mock implements http.Response {}

void main() {
  group('CollectionsApiCall', () {
    const schemas = [
      {
        "num_documents": 1250,
        "name": "companies",
        "fields": [
          {"name": "company_name", "type": "string"},
          {"name": "num_employees", "type": "int32"},
          {"name": "country", "type": "string", "facet": true}
        ],
        "default_sorting_field": "num_employees"
      },
      {
        "num_documents": 1250,
        "name": "ceos",
        "fields": [
          {"name": "company_name", "type": "string"},
          {"name": "full_name", "type": "string"},
          {"name": "from_year", "type": "int32"}
        ],
        "default_sorting_field": "from_year"
      }
    ];
    test('has a CONTENT_TYPE constant', () {
      expect(CONTENT_TYPE, equals('Content-Type'));
    });
    test('has a defaultHeaders field', () {
      final config = ConfigurationFactory.withNearestNode(),
          nodePool = NodePool(config),
          collectionsApiCall = CollectionsApiCall(config, nodePool);
      expect(collectionsApiCall.defaultHeaders,
          equals({apiKeyLabel: apiKey, CONTENT_TYPE: 'application/json'}));
    });
    test('has a defaultQueryParameters field', () {
      final config = ConfigurationFactory.withNearestNode(
              sendApiKeyAsQueryParam: true),
          nodePool = NodePool(config),
          collectionsApiCall = CollectionsApiCall(config, nodePool);
      expect(collectionsApiCall.defaultQueryParameters,
          equals({apiKeyLabel: apiKey}));
    });
    test('has a get method', () async {
      final client = MockClient(
            (request) async {
              expect(
                  request.url.toString(),
                  equals(
                      '$protocol://$host:$mockServerPort$pathToService/collections?'));
              expect(request.method, equals('GET'));
              expect(request.headers[apiKeyLabel], equals(apiKey));

              return http.Response(json.encode(schemas), 200, request: request);
            },
          ),
          config = ConfigurationFactory.withoutNearestNode(mockClient: client),
          nodePool = NodePool(config);

      expect(
          await CollectionsApiCall(config, nodePool).get(
            '/collections',
          ),
          equals(schemas));
    });
    test('has a send method', () async {
      final config = ConfigurationFactory.withNearestNode(),
          nodePool = NodePool(config),
          collectionsApiCall = CollectionsApiCall(config, nodePool),
          mockReponse = MockResponse();
      when(mockReponse.statusCode).thenAnswer((realInvocation) => 200);
      when(mockReponse.body)
          .thenAnswer((realInvocation) => json.encode(schemas));

      expect(await collectionsApiCall.send((node) => Future.value(mockReponse)),
          equals(schemas));
    });
    test('has a handleNodeResponse method', () {
      final config = ConfigurationFactory.withNearestNode(),
          nodePool = NodePool(config),
          collectionsApiCall = CollectionsApiCall(config, nodePool),
          mockReponse = MockResponse();
      when(mockReponse.statusCode).thenAnswer((realInvocation) => 200);
      when(mockReponse.body)
          .thenAnswer((realInvocation) => json.encode(schemas));

      expect(collectionsApiCall.decode(mockReponse.body), equals(schemas));
    });
    test('has a requestUri method', () {
      final config = ConfigurationFactory.withNearestNode(),
          nodePool = NodePool(config);
      expect(
          CollectionsApiCall(config, nodePool).requestUri(
              Node(
                  protocol: protocol,
                  host: host,
                  port: nearestServerPort,
                  path: pathToService),
              '/endpoint',
              {'howCool': 'isThat'}).toString(),
          equals(
              '$protocol://$host:$nearestServerPort$pathToService/endpoint?howCool=isThat'));
    });
  });

  group('CollectionsApiCall', () {
    setUp(() async {});
    test('sends api key in the header or query according to the configuration',
        () async {
      var sendApiKeyAsQueryParam = false;
      final client = MockClient(
        (request) async {
          expect(request.url.path, equals('$pathToService/api/key/test'));

          if (sendApiKeyAsQueryParam) {
            expect(request.url.queryParameters[apiKeyLabel], equals(apiKey));
          } else {
            expect(request.headers[apiKeyLabel], equals(apiKey));
          }
          return http.Response('', 200, request: request);
        },
      );

      // Defaults to sending api key in the header
      var config = ConfigurationFactory.withoutNearestNode(
            sendApiKeyAsQueryParam: sendApiKeyAsQueryParam,
            mockClient: client,
          ),
          nodePool = NodePool(config);
      await CollectionsApiCall(config, nodePool).get('/api/key/test');

      // Sending api key as query parameter now
      sendApiKeyAsQueryParam = true;
      config = ConfigurationFactory.withoutNearestNode(
        sendApiKeyAsQueryParam: sendApiKeyAsQueryParam,
        mockClient: client,
      );
      nodePool = NodePool(config);
      await CollectionsApiCall(config, nodePool).get('/api/key/test');
    });
    test(
        'sets the health status of a node according to completion of the request',
        () async {
      var requestNumber = 0;
      final client = MockClient(
            (request) async {
              expect(request.url.path,
                  equals('$pathToService/health/status/test'));
              switch (++requestNumber) {
                case 1:
                  return http.Response('', 500, request: request);
                case 2:
                  return http.Response('', 0, request: request);
                default:
                  return http.Response('', 200, request: request);
              }
            },
          ),
          node1 = Node(
            client: client,
            protocol: protocol,
            host: host,
            port: nearestServerPort,
            path: pathToService,
          ),
          node2 = Node(
            client: client,
            protocol: protocol,
            host: host,
            port: mockServerPort,
            path: pathToService,
          ),
          node3 = Node(
            client: client,
            protocol: protocol,
            host: host,
            port: unavailableServerPort,
            path: pathToService,
          ),
          config = ConfigurationFactory.withoutNearestNode(
            nodes: {node1, node2, node3},
            retryInterval: Duration.zero,
          ),
          nodePool = NodePool(config);

      expect(node1.isHealthy, isTrue);
      expect(node1.lastAccessTimestamp, isNull);
      expect(node2.isHealthy, isTrue);
      expect(node2.lastAccessTimestamp, isNull);
      expect(node3.isHealthy, isTrue);
      expect(node3.lastAccessTimestamp, isNull);

      final now = DateTime.now();
      await CollectionsApiCall(config, nodePool).get('/health/status/test');

      expect(node1.isHealthy, isFalse); // returned 500 status
      expect(node1.lastAccessTimestamp.compareTo(now) > 0, isTrue);
      expect(node2.isHealthy, isFalse); // returned 0 status
      expect(node2.lastAccessTimestamp.compareTo(now) > 0, isTrue);
      expect(node3.isHealthy, isTrue);
      expect(node3.lastAccessTimestamp.compareTo(now) > 0, isTrue);
    });
    test('retries a request after Configuration.retryInterval duration',
        () async {
      DateTime firstRequestTime, secondRequestTime;
      final retryInterval = Duration(milliseconds: 900),
          client = MockClient(
            (request) async {
              expect(request.url.path,
                  equals('$pathToService/retry/interval/test'));
              if (firstRequestTime == null) {
                firstRequestTime = DateTime.now();
                return http.Response('', 500, request: request);
              } else {
                secondRequestTime = DateTime.now();
                return http.Response('', 200, request: request);
              }
            },
          ),
          config = ConfigurationFactory.withoutNearestNode(
              mockClient: client, retryInterval: retryInterval),
          nodePool = NodePool(config);

      await CollectionsApiCall(config, nodePool).get('/retry/interval/test');
      // Atleast [retryInterval] delay between requests.
      expect(secondRequestTime.difference(firstRequestTime) > retryInterval,
          isTrue);
    });
    test(
      'retries a request Configuration.numRetries times if an exception occurs',
      () async {
        var numTries = 0;
        final client = MockClient(
              (request) async {
                expect(request.url.path, equals('$pathToService/retries/test'));
                numTries++;
                return http.Response('', 500, request: request);
              },
            ),
            config = ConfigurationFactory.withoutNearestNode(
              mockClient: client,
              numRetries: 5,
            ),
            nodePool = NodePool(config);

        try {
          await CollectionsApiCall(config, nodePool).get('/retries/test');
        } catch (e) {
          // Exception is rethrown when Configuration.numRetries run out
          expect(e, isA<ServerError>());
          expect(numTries, equals(5));
        }
      },
    );
  });

  group('CollectionsApiCall throws', () {
    test(
        'TimeoutException when no response is received for Configuration.connectionTimeout duration',
        () {
      final client = MockClient(
            (request) async {
              expect(request.url.path, equals('$pathToService/timeout/test'));

              return await Future.delayed(
                      Duration(seconds: 1, milliseconds: 10))
                  .then((_) => http.Response('', 200, request: request));
            },
          ),
          config = ConfigurationFactory.withoutNearestNode(mockClient: client),
          nodePool = NodePool(config);

      expect(
        () async {
          await CollectionsApiCall(config, nodePool).get('/timeout/test');
        },
        throwsA(isA<TimeoutException>().having(
          (e) => e.duration,
          'duration',
          equals(Duration(seconds: 1)),
        )),
      );
    });
    test(
      'immediately for Http response code < 500',
      () async {
        var numTries, requestNumber = 0;
        final client = MockClient(
              (request) async {
                expect(request.url.path, equals('$pathToService/retries/test'));
                numTries++;
                requestNumber++;

                switch (requestNumber) {
                  case 1:
                    return http.Response('', 400, request: request);
                  case 2:
                    return http.Response('', 401, request: request);
                  case 3:
                    return http.Response('', 404, request: request);
                  case 4:
                    return http.Response('', 409, request: request);
                  case 5:
                    return http.Response('', 422, request: request);
                  case 6:
                    return http.Response('', 0, request: request);
                }

                return http.Response('', 200, request: request);
              },
            ),
            config = ConfigurationFactory.withoutNearestNode(
              mockClient: client,
            ),
            nodePool = NodePool(config);

        numTries = 0;
        try {
          await CollectionsApiCall(config, nodePool).get('/retries/test');
        } catch (e) {
          expect(e, isA<RequestMalformed>());
          expect(numTries, equals(1));
        }

        numTries = 0;
        try {
          await CollectionsApiCall(config, nodePool).get('/retries/test');
        } catch (e) {
          expect(e, isA<RequestUnauthorized>());
          expect(numTries, equals(1));
        }

        numTries = 0;
        try {
          await CollectionsApiCall(config, nodePool).get('/retries/test');
        } catch (e) {
          expect(e, isA<ObjectNotFound>());
          expect(numTries, equals(1));
        }

        numTries = 0;
        try {
          await CollectionsApiCall(config, nodePool).get('/retries/test');
        } catch (e) {
          expect(e, isA<ObjectAlreadyExists>());
          expect(numTries, equals(1));
        }

        numTries = 0;
        try {
          await CollectionsApiCall(config, nodePool).get('/retries/test');
        } catch (e) {
          expect(e, isA<ObjectUnprocessable>());
          expect(numTries, equals(1));
        }

        numTries = 0;
        try {
          await CollectionsApiCall(config, nodePool).get('/retries/test');
        } catch (e) {
          expect(e, isA<HttpError>());
          expect(numTries, equals(1));
        }
      },
    );
  });
}
