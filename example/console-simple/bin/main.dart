import 'dart:io';

import 'package:typesense/typesense.dart';
import 'package:logging/logging.dart';

import 'collections.dart' as collections;
import 'documents.dart' as documents;
import 'search.dart' as search;
import 'keys.dart' as keys;
import 'curations.dart' as curations;
import 'synonyms.dart' as synonyms;
import 'aliases.dart' as aliases;
import 'presets.dart' as presets;
import 'cluster_operations.dart' as cluster_operations;
import 'miscellaneous.dart' as miscellaneous;

void main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('${record.level.name}: ${record.message}');
  });

  final host = InternetAddress.loopbackIPv4.address, protocol = Protocol.http;
  final config = Configuration(
    // Replace with your configuration
    'xyz',
    nodes: {
      Node(
        protocol,
        host,
        port: 7108,
      ),
      Node.withUri(
        Uri(
          scheme: 'http',
          host: host,
          port: 8108,
        ),
      ),
      Node(
        protocol,
        host,
        port: 9108,
      ),
    },
    numRetries: 3, // A total of 4 tries (1 original try + 3 retries)
    connectionTimeout: const Duration(seconds: 2),
  );
  final client = Client(config);

  await collections.runExample(client);
  await documents.runExample(
      // Set a longer timeout in case of large imports.
      Client(config.copyWith(connectionTimeout: const Duration(seconds: 120))));
  await search.runExample(client);
  await keys.runExample(client);
  await curations.runExample(client);
  await synonyms.runExample(client);
  await aliases.runExample(client);
  await presets.runExample(client);
  await cluster_operations.runExample(client);
  await miscellaneous.runExample(client);
}
