import 'package:test/test.dart';

import 'package:typesense/src/models/field.dart';

void main() {
  group('Field', () {
    Field field;
    setUp(() {
      field = Field(
        'country',
        Type.string,
        isFacetable: true,
        isMultivalued: false,
        isOptional: false,
        shouldIndex: true,
      );
    });

    test('has a name field', () {
      expect(field.name, equals('country'));
    });
    test('has a type field', () {
      expect(field.type, equals(Type.string));
    });
    test('has a isFacetable field', () {
      expect(field.isFacetable, isTrue);
    });
    test('has a isMultivalued field', () {
      expect(field.isMultivalued, isFalse);
    });
    test('has a isOptional field', () {
      expect(field.isOptional, isFalse);
    });
    test('has a shouldIndex field', () {
      expect(field.shouldIndex, isTrue);
    });
    test('has a toMap method', () {
      expect(
          field.toMap(),
          equals({
            'name': 'country',
            'type': 'string',
            'facet': true,
            'optional': false,
            'index': true,
          }));
    });
  });

  group('Field initialization', () {
    test('with null/empty name throws', () {
      expect(
        () => Field(
          null,
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
    test('with null type throws', () {
      expect(
          () => Field('country', null),
          throwsA(isA<ArgumentError>().having(
              (e) => e.message, 'message', 'Ensure Field.type is set')));
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
