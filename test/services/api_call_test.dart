import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'package:typesense/src/services/api_call.dart';
import 'package:typesense/src/services/node_pool.dart';
import 'package:typesense/src/models/node.dart';
import 'package:typesense/src/exceptions.dart';

import '../test_utils.dart';

class MockResponse extends Mock implements http.Response {}

void main() {
  int unresponsivePort = 9091;
  HttpServer

      // serving on port 8080, used as nearest node
      nearestServer,

      // serving on port 8081, passed in Configuration.nodes
      mockServer,

      // serving on port 9090, only returns HTTP 503 status
      unavailableServer,

      // serving on port 9091, does not have any handler
      unresponsiveServer;

  setUp(() async {
    nearestServer = await HttpServer.bind(host, nearestServerPort);
    mockServer = await HttpServer.bind(host, mockServerPort);
    unavailableServer = await HttpServer.bind(host, unavailableServerPort);
    unresponsiveServer = await HttpServer.bind(host, unresponsivePort);
    handleHttpRequests(nearestServer);
    handleHttpRequests(mockServer);
    handleHttpRequests(unavailableServer);
  });

  tearDown(() async {
    await nearestServer.close();
    await mockServer.close();
    await unavailableServer.close();
    await unresponsiveServer.close();
  });
  group('ApiCall', () {
    final config = ConfigurationFactory.withNearestNode(),
        nodePool = NodePool(config);
    test('has a CONTENT_TYPE constant', () {
      expect(CONTENT_TYPE, equals('Content-Type'));
    });
    test('has a get method', () async {
      expect(await ApiCall(config, nodePool).get(companiesCollectionEndpoint),
          equals(companyCollection));
    });
    test('has a put method', () async {
      expect(
          await ApiCall(config, nodePool).put(
            '$aliases/companies',
            bodyParameters: {'collection_name': 'companies_june11'},
          ),
          equals(companiesAlias));
    });
    test('has a delete method', () async {
      expect(await ApiCall(config, nodePool).delete('$aliases/companies'),
          equals(companiesAlias));
    });
    test('has a post method', () async {
      expect(await ApiCall(config, nodePool).post(collections),
          equals(companyCollection));
    });
    test('has a send method', () async {
      final apiCall = ApiCall(config, nodePool), mockReponse = MockResponse();
      when(mockReponse.statusCode).thenAnswer((realInvocation) => 200);
      when(mockReponse.body)
          .thenAnswer((realInvocation) => json.encode({'return': 'data'}));

      expect(await apiCall.send((node) => Future.value(mockReponse)),
          equals({'return': 'data'}));
    });
    test('has a handleNodeResponse method', () {
      final apiCall = ApiCall(config, nodePool), mockReponse = MockResponse();
      when(mockReponse.statusCode).thenAnswer((realInvocation) => 200);
      when(mockReponse.body)
          .thenAnswer((realInvocation) => json.encode({'return': 'data'}));

      expect(
          apiCall.handleNodeResponse(mockReponse), equals({'return': 'data'}));
    });
    test('has a requestUri method', () {
      expect(
          ApiCall(config, nodePool).requestUri(
              Node(protocol: protocol, host: host, path: pathToService),
              aliases,
              {'query': 'how'}).toString(),
          equals('http://$host/path/to/service/aliases?query=how'));
    });
    test('has an exception method', () {
      final apiCall = ApiCall(config, nodePool);
      var exception = apiCall.exception('foo', 401);
      expect(exception, isA<RequestUnauthorized>());
      expect(exception.message, equals('foo'));
      expect(exception.statusCode, equals(401));

      exception = apiCall.exception('', 404);
      expect(exception, isA<ObjectNotFound>());

      exception = apiCall.exception('', 409);
      expect(exception, isA<ObjectAlreadyExists>());

      exception = apiCall.exception('', 422);
      expect(exception, isA<ObjectUnprocessable>());

      exception = apiCall.exception('', 405);
      expect(exception, isA<HttpError>());
    });
  });

  group('ApiCall', () {
    setUp(() async {});
    test('sends api key in the header or query according to the configuration',
        () async {
      // Defaults to sending api key in the header
      var config = ConfigurationFactory.withoutNearestNode(),
          res = await ApiCall(config, NodePool(config))
              .get(companiesCollectionEndpoint);
      expect(res, equals(companyCollection));

      config =
          ConfigurationFactory.withNearestNode(sendApiKeyAsQueryParam: true);
      res = await ApiCall(config, NodePool(config))
          .get(companiesCollectionEndpoint);
      expect(res, equals(companyCollection));
    });
    test(
      'retries a request Configuration.numRetries times if an exception occurs (except RequestException HTTP status < 500)',
      () async {
        final config = ConfigurationFactory.withoutNearestNode(nodes: {
              Node(
                protocol: protocol,
                host: host,
                port: unavailableServerPort,
                path: pathToService,
              ),
            }),
            res = await ApiCall(config, NodePool(config))
                .get(companiesCollectionEndpoint);

        expect(res, equals(companyCollection));
      },
      // Skipping since HttpServer returns "Connection refused" when request is
      // sent multiple times to unresponsiveServerPort.
      // TODO: Fix this test.
      skip: true,
    );
  });

  group('ApiCall throws', () {
    test('if a request fails with response code < 500', () {
      final config = ConfigurationFactory.withoutNearestNode(nodes: {
        Node(
          protocol: protocol,
          host: host,
          port: mockServerPort,
          path: '/wrong/path',
        ),
      });

      expect(
        () async {
          await ApiCall(config, NodePool(config))
              .get(companiesCollectionEndpoint);
        },
        throwsA(
          isA<RequestMalformed>()
              .having(
                (e) => e.message,
                'message',
                equals('{}'),
              )
              .having(
                (e) => e.statusCode,
                'statusCode',
                equals(400),
              ),
        ),
      );
    });
    test('RequestUnauthorized when apiKey is incorrect', () {
      final config =
          ConfigurationFactory.withoutNearestNode(apiKey: 'wrongKey');

      expect(
        () async {
          await ApiCall(config, NodePool(config))
              .get(companiesCollectionEndpoint);
        },
        throwsA(
          isA<RequestUnauthorized>()
              .having(
                (e) => e.message,
                'message',
                equals('{}'),
              )
              .having(
                (e) => e.statusCode,
                'statusCode',
                equals(401),
              ),
        ),
      );
    });
    test('ServerError for response code 5xx', () {
      final config = ConfigurationFactory.withoutNearestNode(
        nodes: {
          Node(
            protocol: protocol,
            host: host,
            port: unavailableServerPort,
            path: pathToService,
          )
        },
        numRetries: 0, // To avoid retrying the only node multiple times.
      );

      expect(
        () async {
          await ApiCall(config, NodePool(config))
              .get(companiesCollectionEndpoint);
        },
        throwsA(
          isA<ServerError>()
              .having(
                (e) => e.message,
                'message',
                equals('{}'),
              )
              .having(
                (e) => e.statusCode,
                'statusCode',
                equals(503),
              ),
        ),
      );
    });
    test(
        'TimeoutException when no response is received for Configuration.connectionTimeout duration',
        () {
      final timeoutDuration = Duration(seconds: 1, milliseconds: 850),
          config = ConfigurationFactory.withoutNearestNode(
            nodes: {
              Node(
                protocol: protocol,
                host: host,
                port: unresponsivePort,
                path: pathToService,
              ),
            },
            connectionTimeout: timeoutDuration,
            numRetries: 0,
          );
      expect(
        () async {
          await ApiCall(config, NodePool(config))
              .get(companiesCollectionEndpoint);
        },
        throwsA(isA<TimeoutException>().having(
          (e) => e.duration,
          'duration',
          equals(timeoutDuration),
        )),
      );
    });
  });
}
