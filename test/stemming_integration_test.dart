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
  late String dictionaryId;

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
    dictionaryId =
        'stemming_dict_dart_test_${DateTime.now().millisecondsSinceEpoch}';
  });

  test('upsert and retrieve stemming dictionaries', () async {
    final upserted = await client.stemming.dictionaries.upsert(
      dictionaryId,
      [
        StemmingDictionaryCreateSchema(word: 'shoes', root: 'shoe'),
        StemmingDictionaryCreateSchema(word: 'running', root: 'run'),
      ],
    );
    expect(upserted, isA<List<StemmingDictionaryCreateSchema>>());
    expect(upserted.isNotEmpty, isTrue);

    final list = await client.stemming.dictionaries.retrieve();
    expect(list, isA<StemmingDictionariesRetrieveSchema>());
    expect(list.dictionaries.contains(dictionaryId), isTrue);

    final dictionary = await client.stemming.dictionary(dictionaryId).retrieve();
    expect(dictionary, isA<StemmingDictionarySchema>());
    expect(dictionary.id, equals(dictionaryId));
  });
}
