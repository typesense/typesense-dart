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
  const companiesCollection = 'companies';
  const queriesCollection = 'companies_queries';
  const ruleName = 'company_analytics_rule';

  setUpAll(() async {
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

    await _recreateCollection(client, companiesCollection);
    await _recreateCollection(client, queriesCollection);
  });

  tearDownAll(() async {
    try {
      await client.collection(companiesCollection).delete();
    } catch (_) {}
    try {
      await client.collection(queriesCollection).delete();
    } catch (_) {}
    try {
      await client.analytics.rule(ruleName).delete();
    } catch (_) {}
  });

  test('analytics rules create, update, retrieve, delete', () async {
    final created = await client.analytics.rules().create(
      AnalyticsRuleCreateSchema(
        name: ruleName,
        type: 'nohits_queries',
        collection: companiesCollection,
        eventType: 'search',
        params: AnalyticsRuleParams(
          destinationCollection: queriesCollection,
          limit: 1000,
        ),
      ),
    );
    expect(created, isA<AnalyticsRuleSchema>());

    final updated = await client.analytics.rules().upsert(
      ruleName,
      AnalyticsRuleUpsertSchema(
        params: AnalyticsRuleParams(
          destinationCollection: queriesCollection,
          limit: 500,
        ),
      ),
    );
    expect(updated, isA<AnalyticsRuleSchema>());
    expect(updated.name, equals(ruleName));

    final rules = await client.analytics.rules().retrieve();
    expect(rules, isA<List<AnalyticsRuleSchema>>());
    expect(rules.any((rule) => rule.name == ruleName), isTrue);

    final deleted = await client.analytics.rule(ruleName).delete();
    expect(deleted, isA<AnalyticsRuleDeleteSchema>());
    expect(deleted.name, equals(ruleName));
  });

  test('analytics events create, retrieve, status, flush', () async {
    try {
      await client.analytics.rule(ruleName).delete();
    } catch (_) {}

    await client.analytics.rules().create(
      AnalyticsRuleCreateSchema(
        name: ruleName,
        type: 'log',
        collection: companiesCollection,
        eventType: 'click',
        params: AnalyticsRuleParams(),
      ),
    );

    final event = AnalyticsEventCreateSchema(
      name: ruleName,
      data: {
        'user_id': 'user-1',
        'doc_id': 'apple',
      },
    );
    final created = await client.analytics.events().create(event);
    expect(created, isA<AnalyticsEventCreateResponse>());
    expect(created.ok, isTrue);

    final retrieved = await client.analytics.events().retrieve(
      userId: 'user-1',
      name: ruleName,
      n: 10,
    );
    expect(retrieved, isA<AnalyticsEventsRetrieveSchema>());

    final status = await client.analytics.events().status();
    expect(status, isA<AnalyticsStatus>());

    final flushed = await client.analytics.events().flush();
    expect(flushed, isA<AnalyticsEventCreateResponse>());
  });
}

Future<void> _recreateCollection(Client client, String name) async {
  try {
    await client.collection(name).delete();
  } catch (_) {}
  try {
    await client.collections.create(
      Schema(
        name,
        {
          Field('user_id', type: Type.string),
        },
      ),
    );
  } catch (_) {}
}
