import 'package:test/test.dart';
import 'package:typesense/src/models/models.dart';

void main() {
  group('Schema', () {
    late Schema s1, s2;

    setUp(() {
      s1 = Schema(
        'companies',
        {
          Field('company_name', type: Type.string),
          Field('num_employees', type: Type.int32),
          Field('country', type: Type.string, isFacetable: true),
        },
        defaultSortingField: Field('num_employees'),
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

    test('extends BaseSchema', () {
      expect(s1, isA<BaseSchema>());
    });
    test('has a fields field', () {
      final set = {
        Field('company_name', type: Type.string),
        Field('num_employees', type: Type.int32),
        Field('country', type: Type.string, isFacetable: true),
      };

      expect(s1.fields, equals(set));
      expect(s2.fields, equals(set));
    });
    test('has a name field', () {
      expect(s1.name, equals('companies'));
      expect(s2.name, equals('companies'));
    });
    test('has a documentCount field', () {
      expect(s1.documentCount, equals(0));
      expect(s2.documentCount, equals(0));
    });
    test('has a defaultSortingField field', () {
      expect(s1.defaultSortingField, equals(Field('num_employees')));
      expect(s2.defaultSortingField,
          equals(Field('num_employees', type: Type.int32)));
    });
    test('has a toMap method', () {
      final map = {
        "name": "companies",
        "fields": [
          {"name": "company_name", "type": "string"},
          {"name": "num_employees", "type": "int32"},
          {"name": "country", "type": "string", "facet": true}
        ],
        "default_sorting_field": "num_employees",
        "num_documents": 0,
      };

      expect(s1.toMap(), equals(map));
      expect(s2.toMap(), equals(map));
    });
  });

  group('Schema.fromMap initialization', () {
    test('with null/empty name throws', () {
      expect(
        () => Schema.fromMap({
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
        () => Schema.fromMap({
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
            'Ensure Schema.name is not empty',
          ),
        ),
      );
    });
    test('with null/empty fields throws', () {
      expect(
        () => Schema.fromMap({
          "name": "companies",
          "default_sorting_field": "num_employees",
          "num_documents": 0,
        }),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          'Ensure Schema.fields is set',
        )),
      );
      expect(
        () => Schema.fromMap({
          "name": "companies",
          "fields": [],
          "default_sorting_field": "num_employees",
          "num_documents": 0,
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
    test('with null num_documents throws', () {
      expect(
        () => Schema.fromMap({
          "name": "companies",
          "fields": [
            {"name": "company_name", "type": "string"},
            {"name": "num_employees", "type": "int32"},
            {"name": "country", "type": "string", "facet": true}
          ],
        }),
        throwsA(
          isA<TypeError>(),
        ),
      );
    });
    test("with null/empty defaultSortingField is successful", () {
      var schema = Schema.fromMap({
        "name": "companies",
        "fields": [
          {"name": "company_name", "type": "string"},
          {"name": "num_employees", "type": "int32"},
          {"name": "country", "type": "string", "facet": true}
        ],
        "default_sorting_field": "",
        "num_documents": 0,
      });
      expect(schema.name, equals('companies'));
      expect(schema.defaultSortingField, isNull);

      schema = Schema.fromMap({
        "name": "companies",
        "fields": [
          {"name": "company_name", "type": "string"},
          {"name": "num_employees", "type": "int32"},
          {"name": "country", "type": "string", "facet": true}
        ],
        "num_documents": 0,
      });
      expect(schema.name, equals('companies'));
      expect(schema.defaultSortingField, isNull);
    });
    test('with invalid defaultSortingField throws', () {
      expect(
        () => Schema.fromMap({
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
            'Ensure defaultSortingField "not_present" is present in fields',
          ),
        ),
      );
    });
  });

  group('CreateSchema', () {
    late CreateSchema schema;
    setUp(() {
      schema = CreateSchema(
        'companies',
        {
          CreateField('company_name', type: Type.string),
          CreateField('num_employees', type: Type.int32),
          CreateField('country', type: Type.string, isFacetable: true),
        },
        defaultSortingField: CreateField('num_employees', type: Type.int32),
      );
    });

    test('extends BaseSchema', () {
      expect(schema, isA<BaseSchema>());
    });
    test('has a name field', () {
      expect(schema.name, equals('companies'));
    });
    test('has a fields field', () {
      expect(
          schema.fields,
          equals(
            {
              CreateField('company_name', type: Type.string),
              CreateField('num_employees', type: Type.int32),
              CreateField('country', type: Type.string, isFacetable: true),
            },
          ));
    });
    test('has a defaultSortingField field', () {
      expect(schema.defaultSortingField,
          equals(CreateField('num_employees', type: Type.int32)));
    });
    test('has a toMap method', () {
      final map = {
        'name': 'companies',
        'fields': [
          {
            'name': 'company_name',
            'type': 'string',
          },
          {
            'name': 'num_employees',
            'type': 'int32',
          },
          {
            'name': 'country',
            'type': 'string',
            'facet': true,
          }
        ],
        'default_sorting_field': 'num_employees',
      };

      expect(schema.toMap(), equals(map));
    });
  });

  group('CreateSchema initialization', () {
    test('with empty name throws', () {
      expect(
        () => CreateSchema(
          '',
          {
            CreateField('company_name', type: Type.string),
            CreateField('num_employees', type: Type.int32),
            CreateField('country', type: Type.string, isFacetable: true),
          },
          defaultSortingField: CreateField('num_employees', type: Type.int32),
        ),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Ensure CreateSchema.name is not empty',
          ),
        ),
      );
    });
    test('with empty fields throws', () {
      expect(
        () => CreateSchema(
          'companies',
          {},
          defaultSortingField: CreateField('num_employees', type: Type.int32),
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
        () => CreateSchema(
          'companies',
          {
            CreateField('company_name', type: Type.string),
            CreateField('num_employees', type: Type.int32),
            CreateField('country', type: Type.string, isFacetable: true),
          },
          defaultSortingField: CreateField('num_employees',
              type: Type.int64), // Not present in fields
        ),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Ensure defaultSortingField "num_employees" is present in fields',
          ),
        ),
      );
    });
    test('with defaultSortingField\'s type other than int32 and float throws',
        () {
      expect(
        () => CreateSchema(
          'companies',
          {
            CreateField('company_name', type: Type.string),
            CreateField('num_employees', type: Type.int32),
            CreateField('country', type: Type.string, isFacetable: true),
          },
          defaultSortingField: CreateField('company_name',
              type: Type.string), // Not present in fields
        ),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Ensure type of CreateSchema.defaultSortingField "company_name" is int32 / float',
          ),
        ),
      );
    });
  });

  group('CreateSchema.fromMap initialization', () {
    test('with null/empty name throws', () {
      expect(
        () => CreateSchema.fromMap({
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
        () => CreateSchema.fromMap({
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
            'Ensure CreateSchema.name is not empty',
          ),
        ),
      );
    });
    test('with null/empty fields throws', () {
      expect(
        () => CreateSchema.fromMap({
          "name": "companies",
          "default_sorting_field": "num_employees",
          "num_documents": 0,
        }),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          'Ensure CreateSchema.fields is set',
        )),
      );
      expect(
        () => CreateSchema.fromMap({
          "name": "companies",
          "fields": [],
          "default_sorting_field": "num_employees",
          "num_documents": 0,
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
      var schema = CreateSchema.fromMap({
        "name": "companies",
        "fields": [
          {"name": "company_name", "type": "string"},
          {"name": "num_employees", "type": "int32"},
          {"name": "country", "type": "string", "facet": true}
        ],
        "default_sorting_field": "",
        "num_documents": 0,
      });
      expect(schema.name, equals('companies'));
      expect(schema.defaultSortingField, isNull);

      schema = CreateSchema.fromMap({
        "name": "companies",
        "fields": [
          {"name": "company_name", "type": "string"},
          {"name": "num_employees", "type": "int32"},
          {"name": "country", "type": "string", "facet": true}
        ],
        "num_documents": 0,
      });
      expect(schema.name, equals('companies'));
      expect(schema.defaultSortingField, isNull);
    });
    test('with invalid defaultSortingField throws', () {
      expect(
        () => CreateSchema.fromMap({
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
            'Ensure defaultSortingField "not_present" is present in fields',
          ),
        ),
      );
    });
  });

  group('UpdateSchema', () {
    late UpdateSchema s1, s2;
    setUp(() {
      s1 = UpdateSchema(
        {
          UpdateField('num_employees', shouldDrop: true),
          UpdateField('company_category', type: Type.string)
        },
      );
      s2 = UpdateSchema.fromMap({
        "fields": [
          {"drop": true, "name": "num_employees"},
          {
            "name": "company_category",
            "facet": false,
            "index": true,
            "infix": false,
            "locale": "",
            "optional": false,
            "sort": false,
            "type": "string"
          }
        ]
      });
    });

    test('extends BaseSchema', () {
      expect(s1, isA<BaseSchema>());
    });
    test('has a fields field', () {
      final f1 = UpdateField('num_employees', shouldDrop: true);
      expect(
        s1.fields,
        equals(
          {f1, UpdateField('company_category', type: Type.string)},
        ),
      );
      expect(
        s2.fields,
        equals(
          {f1, UpdateField('company_category', type: Type.string, locale: '')},
        ),
      );
    });
  });

  group('UpdateSchema.fromMap initialization', () {
    test('with null/empty fields throws', () {
      expect(
        () => UpdateSchema.fromMap({}),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          'Ensure UpdateSchema.fields is set',
        )),
      );
      expect(
        () => UpdateSchema.fromMap({
          "fields": [],
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
  });
}
