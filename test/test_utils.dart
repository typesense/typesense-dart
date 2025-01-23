import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';

import 'package:typesense/src/configuration.dart';
import 'package:typesense/src/models/models.dart';
import 'package:typesense/src/services/api_call.dart';
import 'package:typesense/src/services/documents_api_call.dart';
import 'package:typesense/src/services/collections_api_call.dart';

final String host = InternetAddress.loopbackIPv4.address;
const protocol = Protocol.http,
    nearestServerPort = 8080,
    mockServerPort = 8081,
    unavailableServerPort = 9090,
    pathToService = '/path/to/service';

extension EnhancedNode on Node {
  /// Returns a new [Node] object which differs only in the specified values
  /// from this object, except for [client].
  ///
  /// [client] is not copied by default assuming the new [Node] would interface
  /// with some other server.
  Node copyWith({
    Protocol? protocol,
    String? host,
    int? port,
    String? path,
    http.Client? client,
  }) =>
      Node(
        protocol ?? this.protocol,
        host ?? this.host,
        port: port ?? this.port,
        path: path ?? this.path,
        client: client,
      );
}

/// Mostly used for the nearestNode in the config.
// ignore: non_constant_identifier_names
final NearestNode = Node(
  protocol,
  host,
  port: nearestServerPort,
  path: pathToService,
);

/// Mostly used for the nodes set in the config.
// ignore: non_constant_identifier_names
final MockNode = NearestNode.copyWith(port: mockServerPort);

/// Used to represent an unresponsive node.
// ignore: non_constant_identifier_names
final UnavailableNode = NearestNode.copyWith(port: unavailableServerPort);

const apiKeyLabel = 'X-TYPESENSE-API-KEY',
    apiKey = 'abc123',
    collections = '/collections',
    aliases = '/aliases',
    companiesCollectionEndpoint = '$collections/companies';

class ConfigurationFactory {
  ConfigurationFactory._();

  static Configuration withNearestNode({
    Node? nearestNode,
    Set<Node>? nodes,
    Duration connectionTimeout = const Duration(seconds: 10),
    Duration healthcheckInterval = const Duration(seconds: 15),
    int numRetries = 5,
    Duration retryInterval = const Duration(milliseconds: 100),
    String apiKey = apiKey,
    bool sendApiKeyAsQueryParam = false,
    MockClient? mockClient,
    Duration? cachedSearchResultsTTL,
  }) =>
      Configuration(
        apiKey,
        nodes: nodes ?? {MockNode.copyWith(client: mockClient)},
        nearestNode: nearestNode ?? NearestNode.copyWith(client: mockClient),
        numRetries: numRetries,
        retryInterval: retryInterval,
        connectionTimeout: connectionTimeout,
        healthcheckInterval: healthcheckInterval,
        cachedSearchResultsTTL: cachedSearchResultsTTL ?? Duration.zero,
        sendApiKeyAsQueryParam: sendApiKeyAsQueryParam,
      );

  static Configuration withoutNearestNode({
    Set<Node>? nodes,
    Duration connectionTimeout = const Duration(seconds: 1),
    Duration healthcheckInterval = const Duration(seconds: 15),
    int numRetries = 5,
    Duration retryInterval = const Duration(milliseconds: 100),
    String apiKey = apiKey,
    bool sendApiKeyAsQueryParam = false,
    MockClient? mockClient,
    Duration? cachedSearchResultsTTL,
  }) =>
      Configuration(
        apiKey,
        nodes: nodes ?? {MockNode.copyWith(client: mockClient)},
        numRetries: numRetries,
        retryInterval: retryInterval,
        connectionTimeout: connectionTimeout,
        healthcheckInterval: healthcheckInterval,
        cachedSearchResultsTTL: cachedSearchResultsTTL ?? Duration.zero,
        sendApiKeyAsQueryParam: sendApiKeyAsQueryParam,
      );
}

@GenerateMocks([],
    customMocks: [MockSpec<GenerateMockApiCall>(as: #MockApiCall)])
class GenerateMockApiCall extends ApiCall {
  GenerateMockApiCall(
      super.config, super.nodePool, super.requestCache);
}

@GenerateMocks([], customMocks: [
  MockSpec<GenerateMockCollectionsApiCall>(as: #MockCollectionsApiCall)
])
class GenerateMockCollectionsApiCall extends CollectionsApiCall {
  GenerateMockCollectionsApiCall(super.config, super.nodePool);
}

@GenerateMocks([], customMocks: [
  MockSpec<GenerateMockDocumentsApiCall>(as: #MockDocumentsApiCall)
])
class GenerateMockDocumentsApiCall extends DocumentsApiCall {
  GenerateMockDocumentsApiCall(super.config, super.nodePool);
}
