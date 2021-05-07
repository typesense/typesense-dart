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
    test('has a toMap method', () {
      expect(
          field.toMap(),
          equals({
            'name': 'country',
            'type': 'string',
            'facet': true,
            'optional': false
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

  test('Field toMap suffixes type with "[]" when isMultivalued set to true',
      () {
    final field = Field('country', Type.string, isMultivalued: true);
    expect(field.toMap()['type'], equals('string[]'));
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
