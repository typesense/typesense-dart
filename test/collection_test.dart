import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:typesense/src/collection.dart';
import 'package:typesense/src/document.dart';
import 'package:typesense/src/override.dart';
import 'package:typesense/src/synonym.dart';
import 'package:typesense/src/models/field.dart';
import 'package:typesense/src/documents.dart';
import 'package:typesense/src/overrides.dart';
import 'package:typesense/src/synonyms.dart';

import 'test_utils.mocks.dart';

void main() {
  late MockApiCall mockApiCall;
  late MockDocumentsApiCall mockDocumentsApiCall;
  late Collection collection;

  setUp(() {
    mockApiCall = MockApiCall();
    mockDocumentsApiCall = MockDocumentsApiCall();
    collection = Collection('companies', mockApiCall, mockDocumentsApiCall);
  });

  group('Collection', () {
    final schemaMap = {
      "name": "companies",
      "num_documents": 1250,
      "fields": [
        {"name": "company_name", "type": "string"},
        {"name": "num_employees", "type": "int32"},
        {"name": "country", "type": "string", "facet": true}
      ],
      "default_sorting_field": "num_employees"
    };

    test('retrieve() calls ApiCall.get()', () async {
      when(
        mockApiCall.get(
          '/collections/companies',
        ),
      ).thenAnswer((realInvocation) => Future.value(schemaMap));

      final schema = await collection.retrieve();
      expect(schema.name, equals('companies'));
      expect(schema.documentCount, equals(1250));
      expect(
          schema.fields,
          equals({
            Field('company_name', Type.string),
            Field('num_employees', Type.int32),
            Field('country', Type.string, isFacetable: true),
          }));
      expect(schema.defaultSortingField,
          equals(Field('num_employees', Type.int32)));
    });
    test('delete() calls ApiCall.delete()', () async {
      when(
        mockApiCall.delete(
          '/collections/companies',
        ),
      ).thenAnswer((realInvocation) => Future.value(schemaMap));

      final schema = await collection.delete();
      expect(schema.name, equals('companies'));
      expect(schema.documentCount, equals(1250));
      expect(
          schema.fields,
          equals({
            Field('company_name', Type.string),
            Field('num_employees', Type.int32),
            Field('country', Type.string, isFacetable: true),
          }));
      expect(schema.defaultSortingField,
          equals(Field('num_employees', Type.int32)));
    });
    test('has a documents getter', () {
      expect(collection.documents, isA<Documents>());
    });
    test('has a document method', () {
      expect(collection.document('124'), isA<Document>());
    });
    test('has a overrides getter', () {
      expect(collection.overrides, isA<Overrides>());
    });
    test('has a override method', () {
      expect(collection.override('customize-apple'), isA<Override>());
    });
    test('has a synonyms getter', () {
      expect(collection.synonyms, isA<Synonyms>());
    });
    test('has a synonym method', () {
      expect(collection.synonym('employee'), isA<Synonym>());
    });
  });

  test(
      'Collection.document returns the same document object for a particular documentId',
      () {
    final document = collection.document('124');
    expect(collection.document('124').hashCode, equals(document.hashCode));
  });

  test(
      'Collection.override returns the same override object for a particular overrideId',
      () {
    final document = collection.override('customize-apple');
    expect(collection.override('customize-apple').hashCode,
        equals(document.hashCode));
  });

  test(
      'Collection.synonym returns the same synonym object for a particular synonymId',
      () {
    final document = collection.synonym('employee');
    expect(collection.synonym('employee').hashCode, equals(document.hashCode));
  });
}
