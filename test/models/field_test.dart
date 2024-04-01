import 'package:test/test.dart';

import 'package:typesense/src/models/models.dart';

void main() {
  group('Field', () {
    late Field f1, f2;
    setUp(() {
      f1 = Field(
        'country',
        type: Type.string,
        isMultivalued: false,
        isFacetable: true,
        isOptional: false,
        shouldIndex: true,
        locale: 'en',
        sort: true,
        enableInfixSearch: true,
        reference: 'RefColl.field',
      );
      f2 = Field.fromMap({
        "name": "country",
        "type": "string",
        "facet": true,
        "optional": false,
        "index": true,
        "locale": "en",
        "sort": true,
        "infix": true,
        "reference": "RefColl.field",
      });
    });

    test('has a name field', () {
      expect(f1.name, equals('country'));
      expect(f2.name, equals('country'));
    });
    test('has a type field', () {
      expect(f1.type, equals(Type.string));
      expect(f2.type, equals(Type.string));
    });
    test('has a isMultivalued field', () {
      expect(f1.isMultivalued, isFalse);
      expect(f2.isMultivalued, isFalse);
    });
    test('has a isFacetable field', () {
      expect(f1.isFacetable, isTrue);
      expect(f2.isFacetable, isTrue);
    });
    test('has a isOptional field', () {
      expect(f1.isOptional, isFalse);
      expect(f2.isOptional, isFalse);
    });
    test('has a shouldIndex field', () {
      expect(f1.shouldIndex, isTrue);
      expect(f2.shouldIndex, isTrue);
    });
    test('has a locale field', () {
      expect(f1.locale, equals('en'));
      expect(f2.locale, equals('en'));
    });
    test('has a sort field', () {
      expect(f1.sort, isTrue);
      expect(f2.sort, isTrue);
    });
    test('has an enableInfixSearch field', () {
      expect(f1.enableInfixSearch, isTrue);
      expect(f2.enableInfixSearch, isTrue);
    });
    test('has a reference field', () {
      expect(f1.reference, 'RefColl.field');
      expect(f2.reference, 'RefColl.field');
    });
    test('has a toMap method', () {
      final map = {
        'name': 'country',
        'type': 'string',
        'facet': true,
        'locale': 'en',
        'sort': true,
        'infix': true,
        'reference': 'RefColl.field',
      };
      expect(f1.toMap(), equals(map));
      expect(f2.toMap(), equals(map));
    });
    test('is equatable', () {
      expect(f1 == f2, isTrue);
    });
  });

  group('Field initialization', () {
    test('with empty name throws', () {
      expect(
        () => Field(
          '',
          type: Type.string,
          isFacetable: true,
          isMultivalued: false,
          isOptional: false,
        ),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Ensure Field.name is not empty',
          ),
        ),
      );
    });
    // This is to maintain backward compatibility. Empty == "en"
    test('does not throw with empty locale', () {
      expect(
        () => Field(
          'country',
          locale: '',
        ),
        returnsNormally,
      );
    });
  });

  group('Field.fromMap initialization', () {
    test('with null name throws', () {
      expect(
        () => Field.fromMap({
          "type": "string",
          "facet": true,
          "optional": false,
          "index": true,
        }),
        throwsA(
          isA<TypeError>(),
        ),
      );
    });
    test('with unknown type throws', () {
      expect(
        () => Field.fromMap(
          {
            "name": "country",
            "type": "not_a_type",
          },
        ),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'not_a_type is not a defined Type.',
          ),
        ),
      );
    });
    test('identifies type of the field', () {
      var field = Field.fromMap({
        "name": "name",
        "type": "string",
      });
      expect(field.type, equals(Type.string));
      expect(field.isMultivalued, isFalse);

      field = Field.fromMap({
        "name": "name",
        "type": "string[]",
      });
      expect(field.type, equals(Type.string));
      expect(field.isMultivalued, isTrue);

      field = Field.fromMap({
        "name": "name",
        "type": "int32",
      });
      expect(field.type, equals(Type.int32));
      expect(field.isMultivalued, isFalse);

      field = Field.fromMap({
        "name": "name",
        "type": "int32[]",
      });
      expect(field.type, equals(Type.int32));
      expect(field.isMultivalued, isTrue);

      field = Field.fromMap({
        "name": "name",
        "type": "int64",
      });
      expect(field.type, equals(Type.int64));
      expect(field.isMultivalued, isFalse);

      field = Field.fromMap({
        "name": "name",
        "type": "int64[]",
      });
      expect(field.type, equals(Type.int64));
      expect(field.isMultivalued, isTrue);

      field = Field.fromMap({
        "name": "name",
        "type": "float",
      });
      expect(field.type, equals(Type.float));
      expect(field.isMultivalued, isFalse);

      field = Field.fromMap({
        "name": "name",
        "type": "float[]",
      });
      expect(field.type, equals(Type.float));
      expect(field.isMultivalued, isTrue);

      field = Field.fromMap({
        "name": "name",
        "type": "bool",
      });
      expect(field.type, equals(Type.bool));
      expect(field.isMultivalued, isFalse);

      field = Field.fromMap({
        "name": "name",
        "type": "bool[]",
      });
      expect(field.type, equals(Type.bool));
      expect(field.isMultivalued, isTrue);

      field = Field.fromMap({
        "name": "name",
        "type": "auto",
      });
      expect(field.type, equals(Type.auto));
      expect(field.isMultivalued, isFalse);

      field = Field.fromMap({
        "name": "name",
        "type": "string*",
      });
      expect(field.type, equals(Type.stringify));
      expect(field.isMultivalued, isFalse);

      field = Field.fromMap({
        "name": "name",
        "type": "geopoint",
      });
      expect(field.type, equals(Type.geopoint));
      expect(field.isMultivalued, isFalse);

      field = Field.fromMap({
        "name": "name",
        "type": "geopoint[]",
      });
      expect(field.type, equals(Type.geopoint));
      expect(field.isMultivalued, isTrue);

      field = Field.fromMap({
        "name": "name",
        "type": "object",
      });
      expect(field.type, equals(Type.object));
      expect(field.isMultivalued, isFalse);

      field = Field.fromMap({
        "name": "name",
        "type": "object[]",
      });
      expect(field.type, equals(Type.object));
      expect(field.isMultivalued, isTrue);
    });
    test('sets default values to fields when null', () {
      final field = Field.fromMap({"name": "num_employees", "type": "int32"});
      expect(field.isFacetable, isFalse);
      expect(field.shouldIndex, isTrue);
      expect(field.isOptional, isFalse);
      expect(field.locale, isNull);
      expect(field.sort, isFalse);
      expect(field.enableInfixSearch, isFalse);
      expect(field.reference, isNull);
    });
  });
  group('Field toMap()', () {
    test('sets "type" according to the field type', () {
      var field = Field('country', type: Type.string);
      expect(field.toMap()['type'], equals('string'));

      field = Field('country', type: Type.int32);
      expect(field.toMap()['type'], equals('int32'));

      field = Field('country', type: Type.int64);
      expect(field.toMap()['type'], equals('int64'));

      field = Field('country', type: Type.float);
      expect(field.toMap()['type'], equals('float'));

      field = Field('country', type: Type.bool);
      expect(field.toMap()['type'], equals('bool'));

      field = Field('country', type: Type.auto);
      expect(field.toMap()['type'], equals('auto'));

      field = Field('country', type: Type.stringify);
      expect(field.toMap()['type'], equals('string*'));

      field = Field('country', type: Type.geopoint);
      expect(field.toMap()['type'], equals('geopoint'));
    });
    test('suffixes basic types with "[]" when isMultivalued set to true', () {
      var field = Field('country', type: Type.string, isMultivalued: true);
      expect(field.toMap()['type'], equals('string[]'));

      field = Field('country', type: Type.int32, isMultivalued: true);
      expect(field.toMap()['type'], equals('int32[]'));

      field = Field('country', type: Type.int64, isMultivalued: true);
      expect(field.toMap()['type'], equals('int64[]'));

      field = Field('country', type: Type.float, isMultivalued: true);
      expect(field.toMap()['type'], equals('float[]'));

      field = Field('country', type: Type.bool, isMultivalued: true);
      expect(field.toMap()['type'], equals('bool[]'));

      field = Field('country', type: Type.geopoint, isMultivalued: true);
      expect(field.toMap()['type'], equals('geopoint[]'));
    });
    test(
        'does not suffix Type.auto and Type.stringify with "[]" regardless of isMultivalued',
        () {
      var field = Field('country', type: Type.auto);
      expect(field.toMap()['type'], equals('auto'));
      field = Field('country', type: Type.auto, isMultivalued: true);
      expect(field.toMap()['type'], equals('auto'));

      field = Field('country', type: Type.stringify);
      expect(field.toMap()['type'], equals('string*'));
      field = Field('country', type: Type.stringify, isMultivalued: true);
      expect(field.toMap()['type'], equals('string*'));
    });
    test('does not add default values', () {
      final field = Field('country');
      expect(field.toMap(), equals({'name': 'country'}));
    });
  });

  group('UpdateField', () {
    late UpdateField field;

    setUp(() {
      field = UpdateField(
        'num_employees',
        shouldDrop: true,
      );
    });

    test('extends Field', () {
      expect(field, isA<Field>());
    });

    test('has a shouldDrop field', () {
      expect(field.shouldDrop, isTrue);
    });
    test('has a toMap method', () {
      final map = {
        'name': 'num_employees',
        'drop': true,
      };
      expect(field.toMap(), equals(map));
    });
  });

  test('UpdateField.fromMap initialization', () {
    final f1 = UpdateField.fromMap({"drop": true, "name": "num_employees"}),
        f2 = UpdateField.fromMap({
          "name": "company_category",
          "facet": false,
          "index": true,
          "infix": false,
          "locale": "",
          "optional": false,
          "sort": false,
          "type": "string"
        });

    expect(f1, equals(UpdateField('num_employees', shouldDrop: true)));
    expect(f2,
        equals(UpdateField('company_category', type: Type.string, locale: '')));
  });
}
