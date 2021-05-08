import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

import 'package:typesense/src/api_call.dart';
import 'package:typesense/src/models/node.dart';
import 'package:typesense/src/exceptions.dart';

import 'config_factory.dart';

void main() {
  HttpServer nearestMockServer, mockServer, unresponsiveServer;

  setUp(() async {
    // print('');
    nearestMockServer = await HttpServer.bind(host, nearestServerPort);
    mockServer = await HttpServer.bind(host, mockServerPort);
    unresponsiveServer = await HttpServer.bind(host, unresponsiveServerPort);
    handleRequests(nearestMockServer);
    handleRequests(mockServer);
    handleRequests(unresponsiveServer);
  });

  tearDown(() async {
    await nearestMockServer.close();
    await mockServer.close();
    await unresponsiveServer.close();
  });
  group('ApiCall', () {
    test('requests the nearest node, if present.', () async {
      final config = ConfigurationFactory.withNearestNode(
            nodes: {
              Node(
                protocol: protocol,
                host: host,
                port: mockServerPort,
                path: '/wrong/path', // Would not receive any data.
              ),
            },
          ),
          res = await ApiCall(config).get(collections);

      expect(res.isNotEmpty, isTrue);
      expect((res['fields'] as List).isNotEmpty, isTrue);
    });
    test('requests the nodes when nearest node is not present', () async {
      final config = ConfigurationFactory.withoutNearestNode(),
          res = await ApiCall(config).get(collections);

      expect(res.isNotEmpty, isTrue);
      expect((res['fields'] as List).isNotEmpty, isTrue);
    });
    test('sends api key in the header or query according to the configuration',
        () async {
      // Defaults to sending api key in the header
      var config = ConfigurationFactory.withNearestNode(),
          res = await ApiCall(config).get(collections);
      expect(res.isNotEmpty, isTrue);
      expect((res['fields'] as List).isNotEmpty, isTrue);

      config =
          ConfigurationFactory.withNearestNode(sendApiKeyAsQueryParam: true);
      res = await ApiCall(config).get(collections);
      expect(res.isNotEmpty, isTrue);
      expect((res['fields'] as List).isNotEmpty, isTrue);
    });
    test('loops through the nodes to complete the request', () async {
      final config = ConfigurationFactory.withoutNearestNode(nodes: {
            Node(
              protocol: protocol,
              host: host,
              port: unresponsiveServerPort,
              path: pathToService,
            ),
            Node(
              protocol: protocol,
              host: host,
              port: mockServerPort,
              path: pathToService, // Would receive the data.
            ),
          }),
          res = await ApiCall(config).get(collections);

      expect(res.isNotEmpty, isTrue);
      expect((res['fields'] as List).isNotEmpty, isTrue);
    });
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
          var res = await ApiCall(config).get(collections);
          print(res);
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
          var res = await ApiCall(config).get(collections);
          print(res);
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
            port: unresponsiveServerPort,
            path: pathToService,
          )
        },
        numRetries: 0, // To avoid retrying the only node multiple times.
      );

      expect(
        () async {
          var res = await ApiCall(config).get(collections);
          print(res);
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
  });
}

Future<void> handleRequests(HttpServer server) async {
  await for (final HttpRequest request in server) {
    final port = request.connectionInfo.localPort,
        path = request.uri.path,
        headers = request.headers,
        // ignore: unused_local_variable
        host = headers['host']?.first,
        _headerApiKey = headers['x-typesense-api-key']?.first;

    // print(
    //     'Requested host: $host  headerkey: $_headerApiKey  path: $path  queryparams: ${request.uri.queryParameters}');

    if (port == unresponsiveServerPort) {
      request.response
        ..statusCode = HttpStatus.serviceUnavailable
        ..write('{}')
        ..close();
      return;
    }

    if (_headerApiKey != apiKey &&
        request.uri.queryParameters['x-typesense-api-key'] != apiKey) {
      request.response
        ..statusCode = HttpStatus.unauthorized
        ..write('{}')
        ..close();
      return;
    }

    switch (request.method) {
      case 'GET':
        if (path == '/path/to/service/collections') {
          final jsonString = jsonEncode({
            "name": "companies",
            "num_documents": 0,
            "fields": [
              {"name": "company_name", "type": "string"},
              {"name": "num_employees", "type": "int32"},
              {"name": "country", "type": "string", "facet": true}
            ],
            "default_sorting_field": "num_employees"
          });
          request.response
            ..statusCode = HttpStatus.ok
            ..headers.contentType = ContentType.json
            ..write(jsonString)
            ..close();
        } else {
          request.response
            ..statusCode = HttpStatus.badRequest
            ..write('{}')
            ..close();
        }
        break;
      case 'DELETE':
        break;
      case 'POST':
        break;
      case 'PUT':
        break;
      case 'PATCH':
        break;
      default:
        request.response
          ..statusCode = HttpStatus.methodNotAllowed
          ..write('{}')
          ..close();
    }
  }
}
