import 'dart:io';

import 'package:typesense/typesense.dart';
import 'package:logging/logging.dart';

import 'bin/collections.dart' as collections;
import 'bin/documents.dart' as documents;
import 'bin/search.dart' as search;
import 'bin/keys.dart' as keys;

void main() async {
  final config = Configuration(
      nodes: {
        Node(
          protocol: 'http',
          host: InternetAddress.loopbackIPv4.address,
          port: 8108,
        ),
        Node(
          protocol: 'http',
          host: InternetAddress.loopbackIPv4.address,
          port: 7108,
        ),
        Node(
          protocol: 'http',
          host: InternetAddress.loopbackIPv4.address,
          port: 9108,
        ),
      },
      apiKey: 'xyz',
      numRetries: 3, // A total of 4 tries (1 original try + 3 retries)
      connectionTimeout:
          Duration(seconds: 10)); // Replace with your configuration
  final client = Client(config);

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.message}');
  });

  await collections.runExample(client);
  await documents.runExample(Client(Configuration.updateParameters(
    config,
    connectionTimeout:
        Duration(seconds: 120), // Set a longer timeout for large imports
  )));
  await search.runExample(client);
  await keys.runExample(client);
}
