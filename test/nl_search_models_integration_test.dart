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
  final openAiApiKey = env['OPENAI_API_KEY'];

  final skipReason = (openAiApiKey == null || openAiApiKey.isEmpty)
      ? 'Set OPENAI_API_KEY to run NL search model tests.'
      : null;

  late Client client;
  late String modelId;

  setUpAll(() {
    if (skipReason != null) {
      return;
    }
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
    modelId = 'nl_search_model_dart_test_${DateTime.now().millisecondsSinceEpoch}';
  });

  tearDownAll(() async {
    if (skipReason != null) {
      return;
    }
    try {
      await client.nlSearchModel(modelId).delete();
    } catch (_) {
      // ignore cleanup errors
    }
  });

  test('create, retrieve, update, delete NL search model', () async {
    if (skipReason != null) {
      return;
    }

    final created = await client.nlSearchModels.create(
      NLSearchModelCreateSchema(
        id: modelId,
        modelName:
            env['NL_SEARCH_MODEL_NAME'] ?? 'openai/gpt-3.5-turbo',
        apiKey: openAiApiKey,
        maxBytes: 16384,
        systemPrompt: 'This is meant for testing purposes',
      ),
    );
    expect(created, isA<NLSearchModelSchema>());
    expect(created.id, equals(modelId));

    final retrieved = await client.nlSearchModel(modelId).retrieve();
    expect(retrieved, isA<NLSearchModelSchema>());
    expect(retrieved.id, equals(modelId));

    final updated = await client.nlSearchModel(modelId).update(
      NLSearchModelUpdateSchema(
        modelName:
            env['NL_SEARCH_MODEL_NAME'] ?? 'openai/gpt-3.5-turbo',
        apiKey: openAiApiKey,
        maxBytes: 16384,
        systemPrompt: 'This is a new system prompt for NL search',
      ),
    );
    expect(updated, isA<NLSearchModelSchema>());
    expect(updated.systemPrompt,
        equals('This is a new system prompt for NL search'));

    final list = await client.nlSearchModels.retrieve();
    expect(list, isA<List<NLSearchModelSchema>>());
    expect(list.any((model) => model.id == modelId), isTrue);

    final deleted = await client.nlSearchModel(modelId).delete();
    expect(deleted, isA<NLSearchModelDeleteSchema>());
    expect(deleted.id, equals(modelId));
  }, skip: skipReason);
}
