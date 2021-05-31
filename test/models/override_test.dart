import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:typesense/src/services/api_call.dart';
import 'package:typesense/src/models/override.dart';

class MockApiCall extends Mock implements ApiCall {}

void main() {
  group('Override', () {
    Override override;
    MockApiCall mock;

    setUp(() {
      mock = MockApiCall();
      override = Override(
        'companies',
        'customize-apple',
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
      final overrideMap = {
        "id": "customize-apple",
        "company_name": "Stark Industries",
        "num_employees": 5215,
        "country": "USA"
      };

      when(
        mock.get(
          '/collections/companies/overrides/customize-apple',
        ),
      ).thenAnswer((realInvocation) => Future.value(overrideMap));
      expect(await override.retrieve(), equals(overrideMap));
    });
  });
}
