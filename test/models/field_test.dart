import 'package:test/test.dart';

import 'package:typesense/src/models/models.dart';

void main() {
  group('Field', () {
    late Field f1, f2;
    setUp(() {
      f1 = Field(
        'country',
        Type.string,
        isFacetable: true,
        isMultivalued: false,
        isOptional: false,
        shouldIndex: true,
      );
      f2 = Field.fromMap({
        "name": "country",
        "type": "string",
        "facet": true,
        "optional": false,
        "index": true,
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
    test('has a isFacetable field', () {
      expect(f1.isFacetable, isTrue);
      expect(f2.isFacetable, isTrue);
    });
    test('has a isMultivalued field', () {
      expect(f1.isMultivalued, isFalse);
      expect(f2.isMultivalued, isFalse);
    });
    test('has a isOptional field', () {
      expect(f1.isOptional, isFalse);
      expect(f2.isOptional, isFalse);
    });
    test('has a shouldIndex field', () {
      expect(f1.shouldIndex, isTrue);
      expect(f2.shouldIndex, isTrue);
    });
    test('has a toMap method', () {
      final map = {
        'name': 'country',
        'type': 'string',
        'facet': true,
        'optional': false,
        'index': true,
      };
      expect(f1.toMap(), equals(map));
      expect(f2.toMap(), equals(map));
    });
  });

  group('Field initialization', () {
    test('with empty name throws', () {
      expect(
        () => Field(
          '',
          Type.string,
          isFacetable: true,
          isMultivalued: false,
          isOptional: false,
        ),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Ensure Field.name is set',
          ),
        ),
      );
    });
  });

  group('Field.fromMap initialization', () {
    test('with null/empty name throws', () {
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
      expect(
        () => Field.fromMap({
          "name": "",
          "type": "string",
          "facet": true,
          "optional": false,
          "index": true,
        }),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Ensure Field.name is set',
          ),
        ),
      );
    });
    test('with null/unknown type throws', () {
      expect(
          () => Field.fromMap({"name": "country"}), throwsA(isA<TypeError>()));
      expect(
          () => Field.fromMap({"name": "country", "type": "not_a_type"}),
          throwsA(isA<ArgumentError>().having((e) => e.message, 'message',
              'not_a_type is not a defined Type.')));
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

      field = Field.fromMap({
        "name": "name",
        "type": "string*",
      });
      expect(field.type, equals(Type.stringify));

      field = Field.fromMap({
        "name": "name",
        "type": "geopoint",
      });
      expect(field.type, equals(Type.geopoint));
    });
    test('sets default values to fields when null', () {
      final field = Field.fromMap({"name": "num_employees", "type": "int32"});
      expect(field.isFacetable, isFalse);
      expect(field.shouldIndex, isTrue);
      expect(field.isOptional, isFalse);
    });
  });
  group('Field toMap()', () {
    test('sets "type" according to the field type', () {
      var field = Field('country', Type.string);
      expect(field.toMap()['type'], equals('string'));

      field = Field('country', Type.int32);
      expect(field.toMap()['type'], equals('int32'));

      field = Field('country', Type.int64);
      expect(field.toMap()['type'], equals('int64'));

      field = Field('country', Type.float);
      expect(field.toMap()['type'], equals('float'));

      field = Field('country', Type.bool);
      expect(field.toMap()['type'], equals('bool'));

      field = Field('country', Type.auto);
      expect(field.toMap()['type'], equals('auto'));

      field = Field('country', Type.stringify);
      expect(field.toMap()['type'], equals('string*'));

      field = Field('country', Type.geopoint);
      expect(field.toMap()['type'], equals('geopoint'));
    });
    test('suffixes basic types with "[]" when isMultivalued set to true', () {
      var field = Field('country', Type.string, isMultivalued: true);
      expect(field.toMap()['type'], equals('string[]'));

      field = Field('country', Type.int32, isMultivalued: true);
      expect(field.toMap()['type'], equals('int32[]'));

      field = Field('country', Type.int64, isMultivalued: true);
      expect(field.toMap()['type'], equals('int64[]'));

      field = Field('country', Type.float, isMultivalued: true);
      expect(field.toMap()['type'], equals('float[]'));

      field = Field('country', Type.bool, isMultivalued: true);
      expect(field.toMap()['type'], equals('bool[]'));
    });
    test(
        'does not suffix Type.auto and Type.stringify with "[]" regardless of isMultivalued',
        () {
      var field = Field('country', Type.auto);
      expect(field.toMap()['type'], equals('auto'));
      field = Field('country', Type.auto, isMultivalued: true);
      expect(field.toMap()['type'], equals('auto'));

      field = Field('country', Type.stringify);
      expect(field.toMap()['type'], equals('string*'));
      field = Field('country', Type.stringify, isMultivalued: true);
      expect(field.toMap()['type'], equals('string*'));

      field = Field('country', Type.geopoint);
      expect(field.toMap()['type'], equals('geopoint'));
      field = Field('country', Type.geopoint, isMultivalued: true);
      expect(field.toMap()['type'], equals('geopoint'));
    });
  });

  test('Fields are equatable', () {
    final f1 = Field(
          'country',
          Type.string,
          isFacetable: true,
          isMultivalued: false,
          isOptional: false,
        ),
        f2 = Field(
          'country',
          Type.string,
          isFacetable: true,
          isMultivalued: false,
          isOptional: false,
        );
    expect(f1 == f2, isTrue);
  });
}
