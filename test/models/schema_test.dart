import 'package:test/test.dart';
import 'package:typesense/src/models/models.dart';

void main() {
  group('CollectionCreateSchema', () {
    late CollectionCreateSchema s1, s2;
    setUp(() {
      s1 = CollectionCreateSchema(
        'companies',
        {
          Field('company_name', Type.string),
          Field('num_employees', Type.int32),
          Field('country', Type.string, isFacetable: true),
        },
        defaultSortingField: Field('num_employees', Type.int32),
      );
      s2 = CollectionCreateSchema.fromMap({
        "name": "companies",
        "fields": [
          {"name": "company_name", "type": "string"},
          {"name": "num_employees", "type": "int32"},
          {"name": "country", "type": "string", "facet": true}
        ],
        "default_sorting_field": "num_employees"
      });
    });

    test('extends BaseSchema', () {
      expect(s1, isA<BaseSchema>());
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
            'sort': false,
            'infix': false,
          },
          {
            'name': 'num_employees',
            'type': 'int32',
            'facet': false,
            'optional': false,
            'index': true,
            'sort': false,
            'infix': false,
          },
          {
            'name': 'country',
            'type': 'string',
            'facet': true,
            'optional': false,
            'index': true,
            'sort': false,
            'infix': false,
          }
        ],
        'default_sorting_field': 'num_employees',
      };

      expect(s1.toMap(), equals(map));
      expect(s2.toMap(), equals(map));
    });
  });

  group('CollectionCreateSchema initialization', () {
    test('with empty name throws', () {
      expect(
        () => CollectionCreateSchema(
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
            'Ensure CollectionCreateSchema.name is not empty',
          ),
        ),
      );
    });
    test('with empty fields throws', () {
      expect(
        () => CollectionCreateSchema(
          'companies',
          {},
          defaultSortingField: Field('num_employees', Type.int32),
        ),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Ensure BaseSchema.fields is not empty',
          ),
        ),
      );
    });
    test('with defaultSortingField that is not present in fields throws', () {
      expect(
        () => CollectionCreateSchema(
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
            'Ensure CollectionCreateSchema.defaultSortingField "num_employees" is present in CollectionCreateSchema.fields',
          ),
        ),
      );
    });
    test('with defaultSortingField\'s type other than int32 and float throws',
        () {
      expect(
        () => CollectionCreateSchema(
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
            'Ensure type of CollectionCreateSchema.defaultSortingField "company_name" is int32 / float',
          ),
        ),
      );
    });
  });

  group('CollectionCreateSchema.fromMap initialization', () {
    test('with null/empty name throws', () {
      expect(
        () => CollectionCreateSchema.fromMap({
          "fields": [
            {"name": "company_name", "type": "string"},
            {"name": "num_employees", "type": "int32"},
            {"name": "country", "type": "string", "facet": true}
          ],
          "default_sorting_field": "num_employees"
        }),
        throwsA(
          isA<TypeError>(),
        ),
      );
      expect(
        () => CollectionCreateSchema.fromMap({
          "name": "",
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
            'Ensure CollectionCreateSchema.name is not empty',
          ),
        ),
      );
    });
    test('with null/empty fields throws', () {
      expect(
        () => CollectionCreateSchema.fromMap(
            {"name": "companies", "default_sorting_field": "num_employees"}),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          'Ensure CollectionCreateSchema.fields is set',
        )),
      );
      expect(
        () => CollectionCreateSchema.fromMap({
          "name": "companies",
          "fields": [],
          "default_sorting_field": "num_employees"
        }),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Ensure BaseSchema.fields is not empty',
          ),
        ),
      );
    });
    test("with null/empty defaultSortingField is successful", () {
      var schema = CollectionCreateSchema.fromMap({
        "name": "companies",
        "fields": [
          {"name": "company_name", "type": "string"},
          {"name": "num_employees", "type": "int32"},
          {"name": "country", "type": "string", "facet": true}
        ],
        "default_sorting_field": ""
      });
      expect(schema.name, equals('companies'));
      expect(schema.defaultSortingField, isNull);

      schema = CollectionCreateSchema.fromMap({
        "name": "companies",
        "fields": [
          {"name": "company_name", "type": "string"},
          {"name": "num_employees", "type": "int32"},
          {"name": "country", "type": "string", "facet": true}
        ],
      });
      expect(schema.name, equals('companies'));
      expect(schema.defaultSortingField, isNull);
    });
    test('with invalid defaultSortingField throws', () {
      expect(
        () => CollectionCreateSchema.fromMap({
          "name": "companies",
          "fields": [
            {"name": "company_name", "type": "string"},
            {"name": "num_employees", "type": "int32"},
            {"name": "country", "type": "string", "facet": true}
          ],
          "default_sorting_field": "not_present"
        }),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Ensure CollectionCreateSchema.defaultSortingField "not_present" is present in CollectionCreateSchema.fields',
          ),
        ),
      );
    });
    test('with defaultSortingField\'s type other than int32 and float throws',
        () {
      expect(
        () => CollectionCreateSchema.fromMap({
          "name": "companies",
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
            'Ensure type of CollectionCreateSchema.defaultSortingField "company_name" is int32 / float',
          ),
        ),
      );
    });
  });

  group('Schema', () {
    late Schema s1, s2;

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
        "fields": [
          {"name": "company_name", "type": "string"},
          {"name": "num_employees", "type": "int32"},
          {"name": "country", "type": "string", "facet": true}
        ],
        "default_sorting_field": "num_employees",
        "num_documents": 0,
      });
    });

    test('extends CollectionCreateSchema', () {
      expect(s1, isA<CollectionCreateSchema>());
    });
    test('has a documentCount field', () {
      expect(s1.documentCount, equals(0));
      expect(s2.documentCount, equals(0));
    });
  });
}
