import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

import 'package:typesense/src/api_call.dart';
import 'package:typesense/src/models/node.dart';
import 'package:typesense/src/exceptions.dart';

import 'config_factory.dart';

final companyCollection = {
  "name": "companies",
  "num_documents": 0,
  "fields": [
    {"name": "company_name", "type": "string"},
    {"name": "num_employees", "type": "int32"},
    {"name": "country", "type": "string", "facet": true}
  ],
  "default_sorting_field": "num_employees"
};

void main() {
  HttpServer nearestMockServer, mockServer, unresponsiveServer;
  final companiesCollectionEndpoint = '$collections/companies';

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
    final config = ConfigurationFactory.withNearestNode(),
        companiesAlias = {
          'name': 'companies',
          'collection_name': 'companies_june11',
        };

    test('has a CONTENT_TYPE', () {
      expect(ApiCall.CONTENT_TYPE, equals('Content-Type'));
    });
    test('has a get method', () async {
      final res = await ApiCall(config).get(companiesCollectionEndpoint);

      expect(res, equals(companyCollection));
    });
    test('has a put method', () async {
      final res = await ApiCall(config).put(
        '$aliases/companies',
        bodyParameters: {'collection_name': 'companies_june11'},
      );

      expect(res, equals(companiesAlias));
    });
    test('has a delete method', () async {
      await ApiCall(config).put(
        '$aliases/companies',
        bodyParameters: {'collection_name': 'companies_june11'},
      );
      final res = await ApiCall(config).delete('$aliases/companies');

      expect(res, equals(companiesAlias));
    });
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
          res = await ApiCall(config).get(companiesCollectionEndpoint);

      expect(res, equals(companyCollection));
    });
    test('requests the nodes when nearest node is not present', () async {
      final config = ConfigurationFactory.withoutNearestNode(),
          res = await ApiCall(config).get(companiesCollectionEndpoint);

      expect(res, equals(companyCollection));
    });
    test('sends api key in the header or query according to the configuration',
        () async {
      // Defaults to sending api key in the header
      var config = ConfigurationFactory.withNearestNode(),
          res = await ApiCall(config).get(companiesCollectionEndpoint);
      expect(res, equals(companyCollection));

      config =
          ConfigurationFactory.withNearestNode(sendApiKeyAsQueryParam: true);
      res = await ApiCall(config).get(companiesCollectionEndpoint);
      expect(res, equals(companyCollection));
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
          res = await ApiCall(config).get(companiesCollectionEndpoint);

      expect(res, equals(companyCollection));
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
          await ApiCall(config).get(companiesCollectionEndpoint);
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
          await ApiCall(config).get(companiesCollectionEndpoint);
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
          await ApiCall(config).get(companiesCollectionEndpoint);
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
  final aliases = <String, Map<String, String>>{};
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
        if (path == '/path/to/service/collections/companies') {
          request.response
            ..statusCode = HttpStatus.ok
            ..headers.contentType = ContentType.json
            ..write(jsonEncode(companyCollection))
            ..close();
        } else if (aliases.containsKey(path)) {
          request.response
            ..statusCode = HttpStatus.ok
            ..headers.contentType = ContentType.json
            ..write(json.encode(aliases[path]))
            ..close();
        } else {
          request.response
            ..statusCode = HttpStatus.badRequest
            ..write('{}')
            ..close();
        }
        break;
      case 'DELETE':
        if (aliases.containsKey(path)) {
          final map = aliases[path];
          aliases.remove(path);
          request.response
            ..statusCode = HttpStatus.ok
            ..headers.contentType = ContentType.json
            ..write(json.encode(map))
            ..close();
        }
        break;
      case 'POST':
        break;
      case 'PUT':
        final map = (jsonDecode(await utf8.decoder.bind(request).join()) as Map)
            .cast<String, String>();
        map['name'] = request.uri.pathSegments.last;
        aliases[path] = map;

        request.response
          ..statusCode = HttpStatus.ok
          ..headers.contentType = ContentType.json
          ..write(json.encode(map))
          ..close();
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
