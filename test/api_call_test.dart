import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

import 'package:typesense/src/api_call.dart';
import 'package:typesense/src/configuration.dart';

import 'config_factory.dart';

void main() {
  group('ApiCall', () {
    HttpServer nearestMockServer, mockServer, unresponsiveServer;

    setUp(() async {
      print('');
      unresponsiveServer = await HttpServer.bind(host, unresponsiveServerPort);
      nearestMockServer = await HttpServer.bind(host, nearestServerPort);
      mockServer = await HttpServer.bind(host, mockServerPort);
      handleRequests(nearestMockServer);
      handleRequests(mockServer);
      handleRequests(unresponsiveServer);
    });

    tearDown(() async {
      await nearestMockServer.close();
      await mockServer.close();
      await unresponsiveServer.close();
    });

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
    test('requests the nodes if nearest node is not present', () async {
      final config = ConfigurationFactory.withoutNearestNode(),
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
}

Future<void> handleRequests(HttpServer server) async {
  await for (final HttpRequest request in server) {
    final port = request.connectionInfo.localPort, url = request.uri.toString();

    assert(request.headers['x-typesense-api-key'].first == apiKey);

    print('Incoming request for port: $port and resource: $url');

    if (port == unresponsiveServerPort) {
      request.response
        ..statusCode = HttpStatus.serviceUnavailable
        ..write('{}')
        ..close();
      return;
    }

    switch (request.method) {
      case 'GET':
        if (url == '/path/to/service/collections?') {
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
