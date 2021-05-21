import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:typesense/src/services/api_call.dart';

import 'package:typesense/src/health.dart';

class MockApiCall extends Mock implements ApiCall {}

void main() {
  Health health;
  MockApiCall mock;

  setUp(() {
    mock = MockApiCall();
    health = Health(mock);
  });

  group('Health', () {
    test('has a RESOURCEPATH', () {
      expect(Health.RESOURCEPATH, equals('/health'));
    });
    test('retrieve() calls ApiCall.get()', () async {
      when(
        mock.get(
          '/health',
        ),
      ).thenAnswer((realInvocation) => Future.value({"status": "ok"}));
      expect(await health.retrieve(), equals({"status": "ok"}));
    });
  });
}
