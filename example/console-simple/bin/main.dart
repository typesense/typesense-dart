import 'dart:io';

import 'package:typesense/typesense.dart';
import 'package:logging/logging.dart';

import 'collections.dart' as collections;
import 'documents.dart' as documents;
import 'search.dart' as search;
import 'keys.dart' as keys;
import 'overrides.dart' as overrides;
import 'synonyms.dart' as synonyms;
import 'aliases.dart' as aliases;
import 'cluster_operations.dart' as cluster_operations;

void main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.message}');
  });

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

  await collections.runExample(client);
  await documents.runExample(
      // Set a longer timeout in case of large imports.
      Client(config.copyWith(connectionTimeout: Duration(seconds: 120))));
  await search.runExample(client);
  await keys.runExample(client);
  await overrides.runExample(client);
  await synonyms.runExample(client);
  await aliases.runExample(client);
  await cluster_operations.runExample(client);
}
