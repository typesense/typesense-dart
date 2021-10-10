import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:typesense/src/alias.dart';

import 'test_utils.mocks.dart';

void main() {
  group('Alias', () {
    late Alias alias;
    late MockApiCall mock;

    setUp(() {
      mock = MockApiCall();
      alias = Alias('companies', mock);
    });

    test('has a name field', () {
      expect(alias.name, equals('companies'));
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
      expect(
          await alias.delete(),
          equals({
            "name": "companies",
            "collection_name": "companies_june11",
          }));
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
      expect(
          await alias.retrieve(),
          equals({
            "name": "companies",
            "collection_name": "companies_june11",
          }));
    });
  });
}
