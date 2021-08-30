import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:typesense/src/health.dart';

import 'test_utils.mocks.dart';

void main() {
  late Health health;
  late MockApiCall mock;

  setUp(() {
    mock = MockApiCall();
    health = Health(mock);
  });

  group('Health', () {
    test('has a resourcepath', () {
      expect(Health.resourcepath, equals('/health'));
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
