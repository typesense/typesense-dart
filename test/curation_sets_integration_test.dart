import 'dart:io';

import 'package:http/http.dart' as http;
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
    setName = 'curation_set_dart_test_$timestamp';
    itemId = 'curation_item_$timestamp';
  });

  tearDownAll(() async {
    try {
      await client.curationSet(setName).delete();
    } catch (_) {
      // ignore cleanup errors
    }
  });

  test('upsert and retrieve curation set', () async {
    final upserted = await client.curationSet(setName).upsert(
      CurationSetUpsertSchema(
        items: [
          CurationObjectSchema(
            id: itemId,
            rule: CurationRuleSchema(
              query: 'stark',
              match: 'exact',
            ),
            includes: [
              CurationIncludeSchema(
                id: 'doc_1',
                position: 1,
              ),
            ],
            metadata: {
              'source': 'dart-tests',
            },
          ),
        ],
      ),
    );

    expect(upserted, isA<CurationSetSchema>());
    expect(upserted.items.any((item) => item.id == itemId), isTrue);

    final retrieved = await client.curationSet(setName).retrieve();
    expect(retrieved, isA<CurationSetSchema>());
    expect(retrieved.items.any((item) => item.id == itemId), isTrue);
  });

  test('list, items, and item CRUD', () async {
    await client.curationSet(setName).upsert(
      CurationSetUpsertSchema(
        items: [
          CurationObjectSchema(
            id: itemId,
            rule: CurationRuleSchema(
              query: 'lannister',
              match: 'contains',
            ),
            excludes: [
              CurationExcludeSchema(
                id: 'doc_2',
              ),
            ],
          ),
        ],
      ),
    );


    final allSets = await client.curationSets.retrieve();
    expect(allSets, isA<List<CurationSetsListEntrySchema>>());
    expect(allSets.any((set) => set.name == setName), isTrue);

    final items = await client.curationSet(setName).listItems(
      limit: 10,
      offset: 0,
    );
    expect(items, isA<List<CurationObjectSchema>>());
    expect(items.any((item) => item.id == itemId), isTrue);

    final retrievedItem = await client.curationSet(setName).item(itemId).retrieve();
    expect(retrievedItem, isA<CurationObjectSchema>());
    expect(retrievedItem.id, equals(itemId));

    final deleted = await client.curationSet(setName).item(itemId).delete();
    expect(deleted, isA<CurationItemDeleteResponseSchema>());
    expect(deleted.id, equals(itemId));
  });
}
