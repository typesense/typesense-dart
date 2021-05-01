import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

import 'package:typesense/src/api_call.dart';
import 'package:typesense/src/configuration.dart';

void main() {
  group('ApiCall', () {
    Configuration config;
    ApiCall apiCall;
    HttpServer mockServer;

    setUp(() async {
      mockServer = await HttpServer.bind('localhost', 8080);
      config = Configuration(
        apiKey: 'abc123',
        connectionTimeout: Duration(seconds: 10),
        healthcheckInterval: Duration(seconds: 5),
        nearestNode: Node(
          protocol: 'http',
          host: 'localhost',
          port: 8080,
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
        sendApiKeyAsQueryParam: false,
      );
      apiCall = ApiCall(config);
      handleRequests(mockServer);
    });
    tearDown(() async {
      await mockServer.close();
    });

    test('requests the nearest node, if present.', () async {
      final res = await apiCall.get('/collections');
      expect(res.isNotEmpty, isTrue);
      expect((res['fields'] as List).isNotEmpty, isTrue);
    });
  });
}

Future<void> handleRequests(HttpServer server) async {
  await for (final HttpRequest request in server) {
    final url = request.uri.toString();
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
        ..statusCode = HttpStatus.ok
        ..close();
    }
  }
}
