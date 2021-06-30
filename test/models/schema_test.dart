import 'package:test/test.dart';
import 'package:typesense/src/models/field.dart';

import 'package:typesense/src/models/schema.dart';

void main() {
  group('Schema', () {
    Schema s1, s2;
    setUp(() {
      s1 = Schema(
        'companies',
        {
          Field('company_name', Type.string),
          Field('num_employees', Type.int32),
          Field('country', Type.string, isFacetable: true),
        },
        defaultSortingField: Field('num_employees', Type.int32),
        documentCount: 0,
      );
      s2 = Schema.fromMap({
        "name": "companies",
        "num_documents": 0,
        "fields": [
          {"name": "company_name", "type": "string"},
          {"name": "num_employees", "type": "int32"},
          {"name": "country", "type": "string", "facet": true}
        ],
        "default_sorting_field": "num_employees"
      });
    });

    test('has a name field', () {
      expect(s1.name, equals('companies'));
      expect(s2.name, equals('companies'));
    });
    test('has a fields field', () {
      expect(
          s1.fields,
          equals({
            Field('company_name', Type.string),
            Field('num_employees', Type.int32),
            Field('country', Type.string, isFacetable: true),
          }));
      expect(
          s2.fields,
          equals({
            Field('company_name', Type.string),
            Field('num_employees', Type.int32),
            Field('country', Type.string, isFacetable: true),
          }));
    });
    test('has a defaultSortingField field', () {
      expect(
          s1.defaultSortingField, equals(Field('num_employees', Type.int32)));
      expect(
          s2.defaultSortingField, equals(Field('num_employees', Type.int32)));
    });
    test('has a documentCount field', () {
      expect(s1.documentCount, equals(0));
      expect(s2.documentCount, equals(0));
    });
    test('has a toMap method', () {
      final map = {
        'name': 'companies',
        'fields': [
          {
            'name': 'company_name',
            'type': 'string',
            'facet': false,
            'optional': false,
            'index': true,
          },
          {
            'name': 'num_employees',
            'type': 'int32',
            'facet': false,
            'optional': false,
            'index': true,
          },
          {
            'name': 'country',
            'type': 'string',
            'facet': true,
            'optional': false,
            'index': true,
          }
        ],
        'default_sorting_field': 'num_employees',
      };

      expect(s1.toMap(), equals(map));
      expect(s2.toMap(), equals(map));
    });
  });

  group('Schema initialization', () {
    test('with null/empty name throws', () {
      expect(
        () => Schema(
          null,
          {
            Field('company_name', Type.string),
            Field('num_employees', Type.int32),
            Field('country', Type.string, isFacetable: true),
          },
          defaultSortingField: Field('num_employees', Type.int32),
        ),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Ensure Schema.name is set',
          ),
        ),
      );
      expect(
        () => Schema(
          '',
          {
            Field('company_name', Type.string),
            Field('num_employees', Type.int32),
            Field('country', Type.string, isFacetable: true),
          },
          defaultSortingField: Field('num_employees', Type.int32),
        ),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Ensure Schema.name is set',
          ),
        ),
      );
    });
    test('with null/empty fields throws', () {
      expect(
        () => Schema(
          'companies',
          null,
          defaultSortingField: Field('num_employees', Type.int32),
        ),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Ensure Schema.fields is set',
          ),
        ),
      );
      expect(
        () => Schema(
          'companies',
          {},
          defaultSortingField: Field('num_employees', Type.int32),
        ),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Ensure Schema.fields is set',
          ),
        ),
      );
    });
    test('with defaultSortingField that is not present in fields throws', () {
      expect(
        () => Schema(
          'companies',
          {
            Field('company_name', Type.string),
            Field('num_employees', Type.int32),
            Field('country', Type.string, isFacetable: true),
          },
          defaultSortingField:
              Field('num_employees', Type.int64), // Not present in fields
        ),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Ensure Schema.defaultSortingField is present in Schema.fields',
          ),
        ),
      );
    });
    test('with defaultSortingField\'s type other than int32 and float throws',
        () {
      expect(
        () => Schema(
          'companies',
          {
            Field('company_name', Type.string),
            Field('num_employees', Type.int32),
            Field('country', Type.string, isFacetable: true),
          },
          defaultSortingField:
              Field('company_name', Type.string), // Not present in fields
        ),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Ensure type of Schema.defaultSortingField is int32 / float',
          ),
        ),
      );
    });
  });

  group('Schema.fromMap initialization', () {
    test('with null/empty name throws', () {
      expect(
        () => Schema.fromMap({
          "num_documents": 0,
          "fields": [
            {"name": "company_name", "type": "string"},
            {"name": "num_employees", "type": "int32"},
            {"name": "country", "type": "string", "facet": true}
          ],
          "default_sorting_field": "num_employees"
        }),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Ensure Schema.name is set',
          ),
        ),
      );
      expect(
        () => Schema.fromMap({
          "name": "",
          "num_documents": 0,
          "fields": [
            {"name": "company_name", "type": "string"},
            {"name": "num_employees", "type": "int32"},
            {"name": "country", "type": "string", "facet": true}
          ],
          "default_sorting_field": "num_employees"
        }),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Ensure Schema.name is set',
          ),
        ),
      );
    });
    test('with null/empty fields throws', () {
      expect(
        () => Schema.fromMap({
          "name": "companies",
          "num_documents": 0,
          "default_sorting_field": "num_employees"
        }),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Ensure Schema.fields is set',
          ),
        ),
      );
      expect(
        () => Schema.fromMap({
          "name": "companies",
          "num_documents": 0,
          "fields": [],
          "default_sorting_field": "num_employees"
        }),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Ensure Schema.fields is set',
          ),
        ),
      );
    });
    test("with invalid defaultSortingField is successful", () {
      var schema = Schema.fromMap({
        "name": "companies",
        "num_documents": 0,
        "fields": [
          {"name": "company_name", "type": "string"},
          {"name": "num_employees", "type": "int32"},
          {"name": "country", "type": "string", "facet": true}
        ],
        "default_sorting_field": ""
      });
      expect(schema.name, equals('companies'));
      expect(schema.defaultSortingField, isNull);

      schema = Schema.fromMap({
        "name": "companies",
        "num_documents": 0,
        "fields": [
          {"name": "company_name", "type": "string"},
          {"name": "num_employees", "type": "int32"},
          {"name": "country", "type": "string", "facet": true}
        ],
        "default_sorting_field": "not_present"
      });
      expect(schema.name, equals('companies'));
      expect(schema.defaultSortingField, isNull);
    });
    test('with defaultSortingField\'s type other than int32 and float throws',
        () {
      expect(
        () => Schema.fromMap({
          "name": "companies",
          "num_documents": 0,
          "fields": [
            {"name": "company_name", "type": "string"},
            {"name": "num_employees", "type": "int32"},
            {"name": "country", "type": "string", "facet": true}
          ],
          "default_sorting_field": "company_name"
        }),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Ensure type of Schema.defaultSortingField is int32 / float',
          ),
        ),
      );
    });
  });
}
