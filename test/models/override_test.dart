import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:typesense/src/services/api_call.dart';
import 'package:typesense/src/models/override.dart';

class MockApiCall extends Mock implements ApiCall {}

void main() {
  group('Override', () {
    Override override;
    MockApiCall mock;
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
      override = Override(
        'customize-apple',
        'companies',
        mock,
      );
    });

    test('delete() calls ApiCall.delete()', () async {
      when(
        mock.delete(
          '/collections/companies/overrides/customize-apple',
        ),
      ).thenAnswer((realInvocation) => Future.value({"id": "customize-apple"}));
      expect(await override.delete(), equals({"id": "customize-apple"}));
    });
    test('retrieve() calls ApiCall.get()', () async {
      when(
        mock.get(
          '/collections/companies/overrides/customize-apple',
        ),
      ).thenAnswer((realInvocation) => Future.value(overrideMap));
      expect(await override.retrieve(), equals(overrideMap));
    });
  });
}
