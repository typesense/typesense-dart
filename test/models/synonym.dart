import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:typesense/src/services/api_call.dart';
import 'package:typesense/src/models/synonym.dart';

class MockApiCall extends Mock implements ApiCall {}

void main() {
  group('Synonym', () {
    Synonym synonym;
    MockApiCall mock;

    setUp(() {
      mock = MockApiCall();
      synonym = Synonym(
        'coat-synonyms',
        'products',
        mock,
      );
    });

    test('delete() calls ApiCall.delete()', () async {
      when(
        mock.delete(
          '/collections/products/synonyms/coat-synonyms',
        ),
      ).thenAnswer((realInvocation) => Future.value({"id": "coat-synonyms"}));
      expect(await synonym.delete(), equals({"id": "coat-synonyms"}));
    });
    test('retrieve() calls ApiCall.get()', () async {
      final synonymMap = {
        "id": "coat-synonyms",
        "root": "",
        "synonyms": ["blazer", "coat", "jacket"]
      };
      when(
        mock.get(
          '/collections/products/synonyms/coat-synonyms',
        ),
      ).thenAnswer((realInvocation) => Future.value(synonymMap));
      expect(await synonym.retrieve(), equals(synonymMap));
    });
  });
}
