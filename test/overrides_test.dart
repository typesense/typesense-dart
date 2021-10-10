import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:typesense/src/overrides.dart';

import 'test_utils.mocks.dart';

void main() {
  group('Overrides', () {
    late Overrides overrides;
    late MockApiCall mock;

    final overrideMap = {
      "id": "customize-apple",
      "excludes": [
        {"id": "287"}
      ],
      "includes": [
        {"id": "422", "position": 1},
        {"id": "54", "position": 2}
      ],
      "rule": {"match": "exact", "query": "apple"}
    };

    setUp(() {
      mock = MockApiCall();
      overrides = Overrides(
        'companies',
        mock,
      );
    });

    test('upsert() calls ApiCall.put()', () async {
      when(
        mock.put('/collections/companies/overrides/customize-apple',
            bodyParameters: overrideMap),
      ).thenAnswer((realInvocation) => Future.value(overrideMap));
      expect(await overrides.upsert('customize-apple', overrideMap),
          equals(overrideMap));
    });
    test('retrieve() calls ApiCall.get()', () async {
      when(
        mock.get(
          '/collections/companies/overrides',
        ),
      ).thenAnswer((realInvocation) => Future.value(overrideMap));
      expect(await overrides.retrieve(), equals(overrideMap));
    });
  });
}
