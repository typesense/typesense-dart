import 'package:test/test.dart';

import 'package:typesense/src/models/alias.dart';

void main() {
  group('Alias', () {
    Alias alias;
    setUp(() {
      alias = Alias(
        'companies',
        'companies_june11',
      );
    });

    test('has a name field', () {
      expect(alias.name, equals('companies'));
    });
    test('has a collectionName field', () {
      expect(alias.collectionName, equals('companies_june11'));
    });
    test('has a collectionNameAsMap field', () {
      expect(
          alias.collectionNameAsMap,
          equals({
            "collection_name": "companies_june11",
          }));
    });
  });

  group('Alias initialization', () {
    test('fromMap', () {
      final alias = Alias.fromMap({
        "name": "companies",
        "collection_name": "companies_june11",
      });
      expect(alias.name, equals('companies'));
      expect(alias.collectionName, equals('companies_june11'));
    });
    test('with null/empty name throws', () {
      expect(
        () => Alias(
          null,
          'companies_june11',
        ),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Ensure Alias.name is set',
          ),
        ),
      );
      expect(
        () => Alias(
          '',
          'companies_june11',
        ),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Ensure Alias.name is set',
          ),
        ),
      );
    });
    test('with null/empty collectionName throws', () {
      expect(
        () => Alias(
          'companies',
          null,
        ),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Ensure Alias.collectionName is set',
          ),
        ),
      );
      expect(
        () => Alias(
          'companies',
          '',
        ),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Ensure Alias.collectionName is set',
          ),
        ),
      );
    });
  });

  test('Alias are equatable', () {
    final a1 = Alias(
          'companies',
          'companies_june11',
        ),
        a2 = Alias(
          'companies',
          'companies_june11',
        );
    expect(a1 == a2, isTrue);
  });
}
