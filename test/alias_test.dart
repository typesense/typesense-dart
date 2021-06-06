import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:typesense/src/services/api_call.dart';
import 'package:typesense/src/alias.dart';

class MockApiCall extends Mock implements ApiCall {}

void main() {
  group('Alias', () {
    Alias alias;
    MockApiCall mock;

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
