import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:typesense/src/collections.dart';
import 'package:typesense/src/models/models.dart';

import 'test_utils.mocks.dart';

void main() {
  late Collections collections;
  late MockApiCall mockApiCall;
  late MockCollectionsApiCall mockCollectionsApiCall;

  setUp(() {
    mockApiCall = MockApiCall();
    mockCollectionsApiCall = MockCollectionsApiCall();
    collections = Collections(mockApiCall, mockCollectionsApiCall);
  });

  group('Collections', () {
    test('has a resourcepath', () {
      expect(Collections.resourcepath, equals('/collections'));
    });
    test('retrieve() calls CollectionsApiCall.get()', () async {
      final schemaList = [
        {
          "num_documents": 1250,
          "name": "companies",
          "fields": [
            {"name": "company_name", "type": "string"},
            {"name": "num_employees", "type": "int32"},
            {"name": "country", "type": "string", "facet": true}
          ],
          "default_sorting_field": "num_employees"
        },
        {
          "num_documents": 1250,
          "name": "ceos",
          "fields": [
            {"name": "company_name", "type": "string"},
            {"name": "full_name", "type": "string"},
            {"name": "from_year", "type": "int32"}
          ],
          "default_sorting_field": "from_year"
        }
      ];
      when(mockCollectionsApiCall.get('/collections'))
          .thenAnswer((realInvocation) => Future.value(schemaList));

      final schemas = await collections.retrieve();
      expect(schemas[0].name, equals('companies'));
      expect(schemas[0].documentCount, equals(1250));
      expect(
          schemas[0].fields,
          equals({
            Field('company_name', type: Type.string),
            Field('num_employees', type: Type.int32),
            Field('country', type: Type.string, isFacetable: true),
          }));
      expect(schemas[0].defaultSortingField,
          equals(Field('num_employees', type: Type.int32)));

      expect(schemas[1].name, equals('ceos'));
      expect(schemas[1].documentCount, equals(1250));
      expect(
          schemas[1].fields,
          equals({
            Field('company_name', type: Type.string),
            Field('from_year', type: Type.int32),
            Field('full_name', type: Type.string),
          }));
      expect(schemas[1].defaultSortingField,
          equals(Field('from_year', type: Type.int32)));
    });
    test('create() calls ApiCall.post()', () async {
      when(mockApiCall.post(
        '/collections',
        bodyParameters: {
          "name": "companies",
          "fields": [
            {
              "name": "company_name",
              "type": "string",
            },
            {
              "name": "num_employees",
              "type": "int32",
            },
            {
              "name": "country",
              "type": "string",
              'facet': true,
            }
          ],
          "default_sorting_field": "num_employees",
          "synonym_sets": [],
          "curation_sets": [],
          "metadata": {},
        },
      )).thenAnswer((realInvocation) => Future.value({
            "name": "companies",
            "num_documents": 0,
            "fields": [
              {"name": "company_name", "type": "string"},
              {"name": "num_employees", "type": "int32"},
              {"name": "country", "type": "string", "facet": true}
            ],
            "default_sorting_field": "num_employees"
          }));

      final schema = await collections.create(
        Schema(
          'companies',
          {
            Field('company_name', type: Type.string),
            Field('num_employees', type: Type.int32),
            Field('country', type: Type.string, isFacetable: true),
          },
          defaultSortingField: Field('num_employees', type: Type.int32),
        ),
      );

      expect(schema.name, equals('companies'));
      expect(
          schema.fields,
          equals({
            Field('company_name', type: Type.string),
            Field('num_employees', type: Type.int32),
            Field('country', type: Type.string, isFacetable: true),
          }));
      expect(schema.defaultSortingField,
          equals(Field('num_employees', type: Type.int32)));
      expect(schema.documentCount, equals(0));
    });
  });
}
