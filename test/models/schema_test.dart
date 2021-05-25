import 'package:test/test.dart';
import 'package:typesense/src/models/field.dart';

import 'package:typesense/src/models/schema.dart';

void main() {
  group('Schema', () {
    Schema schema;
    setUp(() {
      schema = Schema(
        'companies',
        {
          Field('company_name', Type.string),
          Field('num_employees', Type.int32),
          Field('country', Type.string, isFacetable: true),
        },
        Field('num_employees', Type.int32),
      );
    });

    test('has a name field', () {
      expect(schema.name, equals('companies'));
    });
    test('has a fields field', () {
      expect(
          schema.fields,
          equals({
            Field('company_name', Type.string),
            Field('num_employees', Type.int32),
            Field('country', Type.string, isFacetable: true),
          }));
    });
    test('has a defaultSortingField field', () {
      expect(schema.defaultSortingField,
          equals(Field('num_employees', Type.int32)));
    });
    test('has a toMap method', () {
      expect(
          schema.toMap(),
          equals({
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
          }));
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
          Field('num_employees', Type.int32),
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
          Field('num_employees', Type.int32),
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
          Field('num_employees', Type.int32),
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
          Field('num_employees', Type.int32),
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
    test('with null defaultSortingField throws', () {
      expect(
        () => Schema(
          'companies',
          {
            Field('company_name', Type.string),
            Field('num_employees', Type.int32),
            Field('country', Type.string, isFacetable: true),
          },
          null,
        ),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Ensure Schema.defaultSortingField is set',
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
  });
}
