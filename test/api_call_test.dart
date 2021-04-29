import 'package:test/test.dart';

import 'package:typesense/src/api_call.dart';
import 'package:typesense/src/configuration.dart';

void main() {
  group('ApiCall', () {
    Configuration config;
    ApiCall apiCall;

    setUp(() {
      config = Configuration(
        apiKey: 'abc123',
        connectionTimeout: Duration(seconds: 10),
        healthcheckInterval: Duration(seconds: 5),
        nearestNode: Node(
          protocol: 'http',
          host: 'localhost',
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
        retryIntervalSeconds: Duration(seconds: 3),
        sendApiKeyAsQueryParam: true,
      );
      apiCall = ApiCall(config);
    });
  });
}
