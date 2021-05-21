import 'dart:io';
import 'dart:convert';

import 'package:http/testing.dart';

import 'package:typesense/src/configuration.dart';
import 'package:typesense/src/models/node.dart';

String host = InternetAddress.loopbackIPv4.address;
const protocol = 'http',
    apiKeyLabel = 'x-typesense-api-key',
    apiKey = 'abc123',
    nearestServerPort = 8080,
    mockServerPort = 8081,
    unavailableServerPort = 9090,
    pathToService = '/path/to/service',
    collections = '/collections',
    aliases = '/aliases',
    companiesAlias = {
      'name': 'companies',
      'collection_name': 'companies_june11',
    },
    companiesCollectionEndpoint = '$collections/companies',
    companyCollection = {
      "name": "companies",
      "num_documents": 0,
      "fields": [
        {"name": "company_name", "type": "string"},
        {"name": "num_employees", "type": "int32"},
        {"name": "country", "type": "string", "facet": true}
      ],
      "default_sorting_field": "num_employees"
    };

class ConfigurationFactory {
  ConfigurationFactory._();

  static Configuration withNearestNode({
    Node nearestNode,
    Set<Node> nodes,
    Duration connectionTimeout = const Duration(seconds: 10),
    Duration healthcheckInterval = const Duration(seconds: 15),
    int numRetries = 5,
    Duration retryInterval = const Duration(milliseconds: 100),
    String apiKey = apiKey,
    bool sendApiKeyAsQueryParam = false,
    MockClient mockClient,
  }) =>
      Configuration(
        nearestNode: nearestNode ??
            Node(
              client: mockClient,
              protocol: protocol,
              host: host,
              port: nearestServerPort,
              path: pathToService,
            ),
        nodes: nodes ??
            {
              Node(
                client: mockClient,
                protocol: protocol,
                host: host,
                port: mockServerPort,
                path: pathToService,
              ),
            },
        connectionTimeout: connectionTimeout,
        healthcheckInterval: healthcheckInterval,
        numRetries: numRetries,
        apiKey: apiKey,
        retryInterval: retryInterval,
        sendApiKeyAsQueryParam: sendApiKeyAsQueryParam,
      );

  static Configuration withoutNearestNode({
    Set<Node> nodes,
    Duration connectionTimeout = const Duration(seconds: 1),
    Duration healthcheckInterval = const Duration(seconds: 15),
    int numRetries = 5,
    Duration retryInterval = const Duration(milliseconds: 100),
    String apiKey = apiKey,
    bool sendApiKeyAsQueryParam = false,
    MockClient mockClient,
  }) =>
      Configuration(
        nodes: nodes ??
            {
              Node(
                client: mockClient,
                protocol: protocol,
                host: host,
                port: mockServerPort,
                path: pathToService,
              ),
            },
        connectionTimeout: connectionTimeout,
        healthcheckInterval: healthcheckInterval,
        numRetries: numRetries,
        apiKey: apiKey,
        retryInterval: retryInterval,
        sendApiKeyAsQueryParam: sendApiKeyAsQueryParam,
      );
}

Future<void> handleHttpRequests(HttpServer server) async {
  // print('New HTTP server at ${server.address.host}:${server.port}');

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

    if (port == unavailableServerPort) {
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
        if (path == '/path/to/service/aliases/companies') {
          request.response
            ..statusCode = HttpStatus.ok
            ..headers.contentType = ContentType.json
            ..write(json.encode(companiesAlias))
            ..close();
        } else if (aliases.containsKey(path)) {
          final map = aliases[path];
          aliases.remove(path);
          request.response
            ..statusCode = HttpStatus.ok
            ..headers.contentType = ContentType.json
            ..write(json.encode(map))
            ..close();
        } else {
          request.response
            ..statusCode = HttpStatus.badRequest
            ..write('{}')
            ..close();
        }
        break;
      case 'POST':
        if (path == '/path/to/service/collections') {
          request.response
            ..statusCode = HttpStatus.ok
            ..headers.contentType = ContentType.json
            ..write(json.encode(companyCollection))
            ..close();
        } else {
          request.response
            ..statusCode = HttpStatus.badRequest
            ..write('{}')
            ..close();
        }
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
