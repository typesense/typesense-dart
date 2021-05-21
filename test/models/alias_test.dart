import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:typesense/src/services/api_call.dart';
import 'package:typesense/src/models/alias.dart';

class MockApiCall extends Mock implements ApiCall {}

void main() {
  group('Alias', () {
    Alias alias;
    MockApiCall mock;

    setUp(() {
      mock = MockApiCall();
      alias = Alias(
        'companies',
        collectionName: 'companies_june11',
        apiCall: mock,
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
    test('delete() calls ApiCall.delete()', () async {
      when(
        mock.delete(
          '/aliases/companies',
        ),
      ).thenAnswer((realInvocation) => Future.value({
            "name": "companies",
            "collection_name": "companies_june11",
          }));
      expect(await alias.delete(), equals(alias));
    });
    test('retrieve() calls ApiCall.get()', () async {
      when(
        mock.get(
          '/aliases/companies',
        ),
      ).thenAnswer((realInvocation) => Future.value({
            "name": "companies",
            "collection_name": "companies_june11",
          }));
      expect(await alias.retrieve(), equals(alias));
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
          collectionName: 'companies_june11',
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
          collectionName: 'companies_june11',
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
  });

  test('Alias are equatable', () {
    final a1 = Alias(
          'companies',
          collectionName: 'companies_june11',
        ),
        a2 = Alias(
          'companies',
          collectionName: 'companies_june11',
        );
    expect(a1 == a2, isTrue);
  });
}
