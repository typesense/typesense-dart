import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:typesense/src/stats.dart';

import 'test_utils.mocks.dart';

void main() {
  late Stats metrics;
  late MockApiCall mock;

  final map = {
    "latency_ms": {
      "GET /collections/products": 0.0,
      "POST /collections": 4.0,
      "POST /collections/products/documents/import": 1166.0
    },
    "requests_per_second": {
      "GET /collections/products": 0.1,
      "POST /collections": 0.1,
      "POST /collections/products/documents/import": 0.1
    }
  };

  setUp(() {
    mock = MockApiCall();
    metrics = Stats(mock);
  });

  group('Metrics', () {
    test('has a resourcepath', () {
      expect(Stats.resourcepath, equals('/stats.json'));
    });
    test('retrieve() calls ApiCall.get()', () async {
      when(
        mock.get(
          '/stats.json',
        ),
      ).thenAnswer((realInvocation) => Future.value(map));
      expect(await metrics.retrieve(), equals(map));
    });
  });
}
