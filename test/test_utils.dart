import 'dart:io';
import 'package:http/testing.dart';

import 'package:typesense/src/configuration.dart';
import 'package:typesense/src/models/node.dart';

String host = InternetAddress.loopbackIPv4.address;
const protocol = 'http',
    apiKeyLabel = 'X-TYPESENSE-API-KEY',
    apiKey = 'abc123',
    nearestServerPort = 8080,
    mockServerPort = 8081,
    unavailableServerPort = 9090,
    pathToService = '/path/to/service',
    collections = '/collections',
    aliases = '/aliases',
    companiesCollectionEndpoint = '$collections/companies';

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
    Duration cachedSearchResultsTTL,
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
        cachedSearchResultsTTL: cachedSearchResultsTTL,
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
    Duration cachedSearchResultsTTL,
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
        cachedSearchResultsTTL: cachedSearchResultsTTL,
      );
}
