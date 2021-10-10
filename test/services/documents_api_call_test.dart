import 'dart:async';

import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:typesense/src/services/documents_api_call.dart';
import 'package:typesense/src/services/node_pool.dart';
import 'package:typesense/src/exceptions/exceptions.dart';

import '../test_utils.dart';

void main() {
  group('DocumentsApiCall', () {
    test('has a contentType constant', () {
      expect(contentType, equals('Content-Type'));
    });
    test('has a defaultHeaders field', () {
      final config = ConfigurationFactory.withNearestNode(),
          nodePool = NodePool(config),
          docsApiCall = DocumentsApiCall(config, nodePool);
      expect(docsApiCall.defaultHeaders,
          equals({apiKeyLabel: apiKey, contentType: 'application/json'}));
    });
    test('has a defaultQueryParameters field', () {
      final config = ConfigurationFactory.withNearestNode(
              sendApiKeyAsQueryParam: true),
          nodePool = NodePool(config),
          docsApiCall = DocumentsApiCall(config, nodePool);
      expect(docsApiCall.defaultQueryParameters, equals({apiKeyLabel: apiKey}));
    });
    test('has a get method', () async {
      final jsonlData =
              '''{"id": "124", "company_name": "Stark Industries", "num_employees": 5215, "country": "US"}
{"id": "125", "company_name": "Future Technology", "num_employees": 1232, "country": "UK"}
{"id": "126", "company_name": "Random Corp.", "num_employees": 531, "country": "AU"}
''',
          client = MockClient(
            (request) async {
              expect(
                  request.url.toString(),
                  equals(
                      'http://$host:$mockServerPort$pathToService/documents/export?'));
              expect(request.method, equals('GET'));
              expect(request.headers[apiKeyLabel], equals(apiKey));

              return http.Response(jsonlData, 200, request: request);
            },
          ),
          config = ConfigurationFactory.withoutNearestNode(mockClient: client),
          nodePool = NodePool(config);

      expect(
          await DocumentsApiCall(config, nodePool).get(
            '/documents/export',
          ),
          equals(jsonlData));
    });
    test('has a post method', () async {
      final client = MockClient(
            (request) async {
              expect(
                  request.url.toString(),
                  equals(
                      'http://$host:$mockServerPort$pathToService/documents/import?action=create'));
              expect(request.method, equals('POST'));
              expect(request.headers[apiKeyLabel], equals(apiKey));
              expect(request.headers[contentType], contains('text/plain'));

              return http.Response('''{"success": true}
{"success": true}
{"success": true}
''', 200, request: request);
            },
          ),
          config = ConfigurationFactory.withoutNearestNode(mockClient: client),
          nodePool = NodePool(config),
          jsonlData =
              '''{"id": "124", "company_name": "Stark Industries", "num_employees": 5215, "country": "US"}
{"id": "125", "company_name": "Future Technology", "num_employees": 1232, "country": "UK"}
{"id": "126", "company_name": "Random Corp.", "num_employees": 531, "country": "AU"}
''';

      expect(
          await DocumentsApiCall(config, nodePool).post(
            '/documents/import',
            queryParams: {
              'action': 'create',
            },
            additionalHeaders: {
              contentType: 'text/plain',
            },
            bodyParameters: jsonlData,
          ),
          contains('{"success": true}'));
    });
    test('has a send method', () async {
      final client = MockClient(
            (request) async {
              return http.Response('{"success": true}', 200, request: request);
            },
          ),
          config = ConfigurationFactory.withNearestNode(mockClient: client),
          nodePool = NodePool(config),
          docsApiCall = DocumentsApiCall(config, nodePool);

      expect(
          await docsApiCall.send((node) => node.client!.post(
                Uri.http("example.org", "/path"),
              )),
          equals('{"success": true}'));
    });
    test('has a decode method', () {
      final config = ConfigurationFactory.withNearestNode(),
          nodePool = NodePool(config),
          docsApiCall = DocumentsApiCall(config, nodePool);

      expect(
          docsApiCall.decode('{"success": true}'), equals('{"success": true}'));
    });
    test('has a requestUri method', () {
      final config = ConfigurationFactory.withNearestNode(),
          nodePool = NodePool(config);
      expect(
          DocumentsApiCall(config, nodePool).getRequestUri(
              NearestNode, '/endpoint',
              queryParams: {'howCool': 'isThat'}).toString(),
          equals(
              'http://$host:$nearestServerPort$pathToService/endpoint?howCool=isThat'));
    });
  });

  group('DocumentsApiCall', () {
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
      await DocumentsApiCall(config, nodePool).post('/api/key/test');

      // Sending api key as query parameter now
      sendApiKeyAsQueryParam = true;
      config = ConfigurationFactory.withoutNearestNode(
        sendApiKeyAsQueryParam: sendApiKeyAsQueryParam,
        mockClient: client,
      );
      nodePool = NodePool(config);
      await DocumentsApiCall(config, nodePool).post('/api/key/test');
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
          node1 = NearestNode.copyWith(client: client),
          node2 = MockNode.copyWith(client: client),
          node3 = UnavailableNode.copyWith(client: client),
          config = ConfigurationFactory.withoutNearestNode(
            nodes: {node1, node2, node3},
            retryInterval: Duration.zero,
          ),
          nodePool = NodePool(config);

      expect(node1.isHealthy, isTrue);
      expect(node2.isHealthy, isTrue);
      expect(node3.isHealthy, isTrue);

      final now = DateTime.now();
      await DocumentsApiCall(config, nodePool).post('/health/status/test');

      expect(node1.isHealthy, isFalse); // returned 500 status
      expect(node1.lastAccessTimestamp.compareTo(now) > 0, isTrue);
      expect(node2.isHealthy, isFalse); // returned 0 status
      expect(node2.lastAccessTimestamp.compareTo(now) > 0, isTrue);
      expect(node3.isHealthy, isTrue);
      expect(node3.lastAccessTimestamp.compareTo(now) > 0, isTrue);
    });
    test('retries a request after Configuration.retryInterval duration',
        () async {
      DateTime? firstRequestTime, secondRequestTime;
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

      await DocumentsApiCall(config, nodePool).post('/retry/interval/test');
      // Atleast [retryInterval] delay between requests.
      expect(secondRequestTime!.difference(firstRequestTime!) > retryInterval,
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
          await DocumentsApiCall(config, nodePool).post('/retries/test');
        } catch (e) {
          // Exception is rethrown when Configuration.numRetries run out
          expect(e, isA<ServerError>());
          expect(numTries, equals(5));
        }
      },
    );
  });

  group('DocumentsApiCall throws', () {
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
          await DocumentsApiCall(config, nodePool).post('/timeout/test');
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
        var numTries = 0, requestNumber = 0;
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
          await DocumentsApiCall(config, nodePool).post('/retries/test');
        } catch (e) {
          expect(e, isA<RequestMalformed>());
          expect(numTries, equals(1));
        }

        numTries = 0;
        try {
          await DocumentsApiCall(config, nodePool).post('/retries/test');
        } catch (e) {
          expect(e, isA<RequestUnauthorized>());
          expect(numTries, equals(1));
        }

        numTries = 0;
        try {
          await DocumentsApiCall(config, nodePool).post('/retries/test');
        } catch (e) {
          expect(e, isA<ObjectNotFound>());
          expect(numTries, equals(1));
        }

        numTries = 0;
        try {
          await DocumentsApiCall(config, nodePool).post('/retries/test');
        } catch (e) {
          expect(e, isA<ObjectAlreadyExists>());
          expect(numTries, equals(1));
        }

        numTries = 0;
        try {
          await DocumentsApiCall(config, nodePool).post('/retries/test');
        } catch (e) {
          expect(e, isA<ObjectUnprocessable>());
          expect(numTries, equals(1));
        }

        numTries = 0;
        try {
          await DocumentsApiCall(config, nodePool).post('/retries/test');
        } catch (e) {
          expect(e, isA<HttpError>());
          expect(numTries, equals(1));
        }
      },
    );
  });
}
