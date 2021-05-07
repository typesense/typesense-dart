import 'dart:io';

import 'package:typesense/src/configuration.dart';

String host = InternetAddress.loopbackIPv4.address;
const protocol = 'http',
    apiKey = 'abc123',
    nearestServerPort = 8080,
    mockServerPort = 8081,
    unresponsiveServerPort = 9090,
    pathToService = '/path/to/service',
    collections = '/collections';

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
  }) =>
      Configuration(
        nearestNode: nearestNode ??
            Node(
              protocol: protocol,
              host: host,
              port: nearestServerPort,
              path: pathToService,
            ),
        nodes: nodes ??
            {
              Node(
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
    Duration connectionTimeout = const Duration(seconds: 10),
    Duration healthcheckInterval = const Duration(seconds: 15),
    int numRetries = 5,
    Duration retryInterval = const Duration(milliseconds: 100),
    String apiKey = apiKey,
    bool sendApiKeyAsQueryParam = false,
  }) =>
      Configuration(
        nodes: nodes ??
            {
              Node(
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
