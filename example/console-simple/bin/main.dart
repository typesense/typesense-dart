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
import 'miscellaneous.dart' as miscellaneous;

void main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.message}');
  });

  final host = InternetAddress.loopbackIPv4.address, protocol = 'http';
  final config = Configuration(
    // Replace with your configuration
    nodes: {
      Node(
        host: host,
        port: 7108,
        protocol: protocol,
      ),
      Node(
        host: host,
        port: 8108,
        protocol: protocol,
      ),
      Node(
        host: host,
        port: 9108,
        protocol: protocol,
      ),
    },
    apiKey: 'xyz',
    numRetries: 3, // A total of 4 tries (1 original try + 3 retries)
    connectionTimeout: Duration(seconds: 2),
  );
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
  await miscellaneous.runExample(client);
}
