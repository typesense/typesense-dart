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
  late String setName;
  late String itemId;

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
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    setName = 'synonym_set_dart_test_$timestamp';
    itemId = 'synonym_item_$timestamp';
  });

  tearDownAll(() async {
    try {
      await client.synonymSet(setName).delete();
    } catch (_) {
      // ignore cleanup errors
    }
  });

  test('upsert and retrieve synonym set', () async {
    final upserted = await client.synonymSet(setName).upsert(
      SynonymSetCreateSchema(
        items: [
          SynonymItemSchema(
            id: itemId,
            synonyms: ['sneakers', 'shoes'],
          ),
        ],
      ),
    );

    expect(upserted, isA<SynonymSetCreateSchema>());
    expect(upserted.items.any((item) => item.id == itemId), isTrue);

    final retrieved = await client.synonymSet(setName).retrieve();
    expect(retrieved, isA<SynonymSetRetrieveSchema>());
    expect(retrieved.items.any((item) => item.id == itemId), isTrue);
  });

  test('list, items, and item CRUD', () async {
    await client.synonymSet(setName).upsert(
      SynonymSetCreateSchema(
        items: [
          SynonymItemSchema(
            id: itemId,
            synonyms: ['nike', 'footwear'],
          ),
        ],
      ),
    );

    final allSets = await client.synonymSets.retrieve();
    expect(allSets, isA<List<SynonymSetSchema>>());
    expect(allSets.any((set) => set.name == setName), isTrue);

    final items = await client.synonymSet(setName).listItems(
      limit: 10,
      offset: 0,
    );
    expect(items, isA<List<SynonymItemSchema>>());
    expect(items.any((item) => item.id == itemId), isTrue);

    final retrievedItem =
        await client.synonymSet(setName).item(itemId).retrieve();
    expect(retrievedItem, isA<SynonymItemSchema>());
    expect(retrievedItem.id, equals(itemId));

    final deleted =
        await client.synonymSet(setName).item(itemId).delete();
    expect(deleted, isA<SynonymItemDeleteSchema>());
    expect(deleted.id, equals(itemId));
  });
}
