import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:typesense/src/services/api_call.dart';

import 'package:typesense/src/aliases.dart';

class MockApiCall extends Mock implements ApiCall {}

void main() {
  Aliases aliases;
  MockApiCall mock;

  setUp(() {
    mock = MockApiCall();
    aliases = Aliases(mock);
  });

  group('Aliases', () {
    test('has a RESOURCEPATH', () {
      expect(Aliases.RESOURCEPATH, equals('/aliases'));
    });
    test('upsert() calls ApiCall.put()', () async {
      when(
        mock.put('/aliases/companies',
            bodyParameters: {'collection_name': 'companies_june11'}),
      ).thenAnswer((realInvocation) => Future.value({
            "name": "companies",
            "collection_name": "companies_june11",
          }));
      expect(
          await aliases
              .upsert('companies', {'collection_name': 'companies_june11'}),
          equals({
            "name": "companies",
            "collection_name": "companies_june11",
          }));
    });
    test('retrieve() calls ApiCall.get()', () async {
      when(
        mock.get(
          '/aliases',
        ),
      ).thenAnswer((realInvocation) => Future.value({
            "aliases": [
              {"name": "companies", "collection_name": "companies_june11"},
              {"name": "employees", "collection_name": "employees_june11"}
            ]
          }));
      expect(
          await aliases.retrieve(),
          equals({
            "aliases": [
              {"name": "companies", "collection_name": "companies_june11"},
              {"name": "employees", "collection_name": "employees_june11"}
            ]
          }));
    });
  });
}
