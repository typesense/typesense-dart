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
  final historyCollection =
      env['CONVERSATION_HISTORY_COLLECTION'] ?? 'conversations_history';

  final skipReason = (openAiApiKey == null || openAiApiKey.isEmpty)
      ? 'Set OPENAI_API_KEY to run conversation model tests.'
      : null;

  late Client client;
  late String modelId;

  setUpAll(() async {
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
    modelId =
        'conversation_model_dart_test_${DateTime.now().millisecondsSinceEpoch}';
    await _ensureHistoryCollection(client, historyCollection);
  });

  tearDownAll(() async {
    if (skipReason != null) {
      return;
    }
    try {
      await client.conversationModel(modelId).delete();
    } catch (_) {
      // ignore cleanup errors
    }
  });

  test('create, retrieve, update, delete conversation model', () async {
    if (skipReason != null) {
      return;
    }

    final created = await client.conversationsModels.create(
      ConversationModelCreateSchema(
        id: modelId,
        modelName:
            env['CONVERSATION_MODEL_NAME'] ?? 'openai/gpt-3.5-turbo',
        apiKey: openAiApiKey,
        maxBytes: 16384,
        historyCollection: historyCollection,
        systemPrompt: 'This is meant for testing purposes',
      ),
    );
    expect(created, isA<ConversationModelCreateSchema>());

    final retrieved = await client.conversationModel(modelId).retrieve();
    expect(retrieved, isA<ConversationModelSchema>());
    expect(retrieved.id, equals(modelId));

    final updated = await client.conversationModel(modelId).update(
      ConversationModelCreateSchema(
        id: modelId,
        modelName:
            env['CONVERSATION_MODEL_NAME'] ?? 'openai/gpt-3.5-turbo',
        apiKey: openAiApiKey,
        maxBytes: 16384,
        systemPrompt: 'This is meant for testing purposes',
        historyCollection: historyCollection,
      ),
    );
    expect(updated, isA<ConversationModelCreateSchema>());

    final list = await client.conversationsModels.retrieve();
    expect(list, isA<List<ConversationModelSchema>>());
    expect(list.any((model) => model.id == modelId), isTrue);

    final deleted = await client.conversationModel(modelId).delete();
    expect(deleted, isA<ConversationModelDeleteSchema>());
    expect(deleted.id, equals(modelId));
  }, skip: skipReason);
}

Future<void> _ensureHistoryCollection(Client client, String name) async {
  final schema = Schema(
    name,
    {
      Field('conversation_id', type: Type.string),
      Field('model_id', type: Type.string),
      Field('timestamp', type: Type.int32),
      Field('role', type: Type.string, shouldIndex: false),
      Field('message', type: Type.string, shouldIndex: false),
    },
  );

  try {
    await client.collection(name).delete();
  } catch (_) {}
  try {
    await client.collections.create(schema);
  } catch (_) {}
}
