import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:typesense/typesense.dart';

void main() {
  final env = Platform.environment;
  final apiKey = env['TYPESENSE_API_KEY'] ?? 'xyz';
  final host = env['TYPESENSE_HOST'] ?? '127.0.0.1';
  final port = int.tryParse(env['TYPESENSE_PORT'] ?? '8108') ?? 8108;
  final protocolValue = env['TYPESENSE_PROTOCOL'] ?? 'http';
  final protocol = protocolValue == 'https' ? Protocol.https : Protocol.http;

  final companies = [
    {'id': '1', 'company_name': 'Stark Industries', 'num_employees': 5215},
    {'id': '2', 'company_name': 'Acme Corp', 'num_employees': 1002},
    {'id': '3', 'company_name': 'Dunder Mifflin', 'num_employees': 15},
  ];

  late Client client;
  late String collectionName;

  setUpAll(() {
    client = Client(Configuration(
      apiKey,
      nodes: {Node(protocol, host, port: port)},
    ));
  });

  setUp(() async {
    collectionName =
        'documents_dart_test_${DateTime.now().microsecondsSinceEpoch}';
    await client.collections.create(Schema(
      collectionName,
      {
        Field('company_name', type: Type.string),
        Field('num_employees', type: Type.int32),
      },
    ));
    await client
        .collection(collectionName)
        .documents
        .importJSONL(companies.map(json.encode).join('\n'));
  });

  tearDown(() async {
    await client.collection(collectionName).delete();
  });

  test('importJSONL() accepts numeric options', () async {
    final results = await client
        .collection(collectionName)
        .documents
        .importJSONL(json.encode(companies.first), options: {
      'action': 'upsert',
      'batch_size': 100,
    });

    expect(json.decode(results), equals({'success': true}));
  });

  test('search() accepts numeric parameters', () async {
    final results = await client.collection(collectionName).documents.search({
      'q': '*',
      'query_by': 'company_name',
      'per_page': 2,
    });

    expect(results['found'], equals(3));
    expect(results['hits'], hasLength(2));
  });
}
