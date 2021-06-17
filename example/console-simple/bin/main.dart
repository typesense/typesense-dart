import 'dart:io';

import 'package:typesense/typesense.dart';
import 'package:logging/logging.dart';

import 'collections.dart' as collections;

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
        numRetries: 3,
        connectionTimeout: Duration(seconds: 10),
      ),
      client = Client(config); // Replace with your configuration

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  await collections.runExample(client);
}
