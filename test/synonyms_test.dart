import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:typesense/src/synonyms.dart';

import 'test_utils.mocks.dart';

void main() {
  group('Synonyms', () {
    late Synonyms synonyms;
    late MockApiCall mock;

    final multiwaySynonymMap = {
          "synonyms": ["blazer", "coat", "jacket"]
        },
        oneWaySynonymMap = {
          "root": "blazer",
          "synonyms": ["coat", "jacket"]
        };

    setUp(() {
      mock = MockApiCall();
      synonyms = Synonyms(
        'products',
        mock,
      );
    });

    test('upsert() calls ApiCall.put()', () async {
      when(
        mock.put('/collections/products/synonyms/customize-apple',
            bodyParameters: oneWaySynonymMap),
      ).thenAnswer((realInvocation) => Future.value({
            "id": "coat-synonyms",
            "root": "blazer",
            "synonyms": ["coat", "jacket"]
          }));
      expect(
          await synonyms.upsert('customize-apple', oneWaySynonymMap),
          equals({
            "id": "coat-synonyms",
            "root": "blazer",
            "synonyms": ["coat", "jacket"]
          }));

      when(
        mock.put('/collections/products/synonyms/customize-apple',
            bodyParameters: multiwaySynonymMap),
      ).thenAnswer((realInvocation) => Future.value({
            "id": "coat-synonyms",
            "synonyms": ["blazer", "coat", "jacket"]
          }));
      expect(
          await synonyms.upsert('customize-apple', multiwaySynonymMap),
          equals({
            "id": "coat-synonyms",
            "synonyms": ["blazer", "coat", "jacket"]
          }));
    });
    test('retrieve() calls ApiCall.get()', () async {
      when(
        mock.get(
          '/collections/products/synonyms',
        ),
      ).thenAnswer((realInvocation) => Future.value({
            "synonyms": [
              {
                "id": "coat-synonyms",
                "root": "",
                "synonyms": ["blazer", "coat", "jacket"]
              }
            ]
          }));
      expect(
          await synonyms.retrieve(),
          equals({
            "synonyms": [
              {
                "id": "coat-synonyms",
                "root": "",
                "synonyms": ["blazer", "coat", "jacket"]
              }
            ]
          }));
    });
  });
}
