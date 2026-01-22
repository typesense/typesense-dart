import 'dart:io';

import 'package:test/test.dart';
import 'package:typesense/typesense.dart';

void main() {
  final env = Platform.environment;
  final apiKey = env['TYPESENSE_API_KEY'] ?? 'xyz';
  final host = env['TYPESENSE_HOST'] ?? '127.0.0.1';
  final port = int.tryParse(env['TYPESENSE_PORT'] ?? '8108') ?? 8108;
  final protocolValue = env['TYPESENSE_PROTOCOL'] ?? 'http';
  final protocol =
      protocolValue == 'https' ? Protocol.https : Protocol.http;


  late Client client;
  late String stopwordId;

  setUpAll(() {
    final config = Configuration(
      apiKey,
      nodes: {
        Node(
          protocol,
          host,
          port: port,
        ),
      },
    );
    client = Client(config);
    stopwordId =
        'stopwords_dart_test_${DateTime.now().millisecondsSinceEpoch}';
  });

  tearDownAll(() async {
    try {
      await client.stopword(stopwordId).delete();
    } catch (_) {
      // ignore cleanup errors
    }
  });

  test('upsert and retrieve stopwords', () async {
    final upserted = await client.stopwords.upsert(
      stopwordId,
      StopwordCreateSchema(
        stopwords: ['a', 'the', 'of'],
      ),
    );
    expect(upserted, isA<StopwordSchema>());
    expect(upserted.id, equals(stopwordId));

    final allStopwords = await client.stopwords.retrieve();
    expect(allStopwords, isA<StopwordsRetrieveSchema>());
    expect(allStopwords.stopwords, isNotEmpty);
    expect(
      allStopwords.stopwords.any((item) => item.id == stopwordId),
      isTrue,
    );
  });

  test('retrieve and delete stopword', () async {
    await client.stopwords.upsert(
      stopwordId,
      StopwordCreateSchema(
        stopwords: ['and', 'or'],
      ),
    );

    final retrieved = await client.stopword(stopwordId).retrieve();
    expect(retrieved, isA<StopwordSchema>());
    expect(retrieved.id, equals(stopwordId));

    final deleted = await client.stopword(stopwordId).delete();
    expect(deleted, isA<StopwordDeleteSchema>());
    expect(deleted.id, equals(stopwordId));
  });
}
