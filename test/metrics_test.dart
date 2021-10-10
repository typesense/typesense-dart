import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:typesense/src/metrics.dart';

import 'test_utils.mocks.dart';

void main() {
  late Metrics metrics;
  late MockApiCall mock;

  final map = {
    "system_cpu1_active_percentage": "0.00",
    "system_cpu2_active_percentage": "0.00",
    "system_cpu3_active_percentage": "0.00",
    "system_cpu4_active_percentage": "0.00",
    "system_cpu_active_percentage": "0.00",
    "system_disk_total_bytes": "1043447808",
    "system_disk_used_bytes": "561152",
    "system_memory_total_bytes": "2086899712",
    "system_memory_used_bytes": "1004507136",
    "system_network_received_bytes": "1466",
    "system_network_sent_bytes": "182",
    "typesense_memory_active_bytes": "29630464",
    "typesense_memory_allocated_bytes": "27886840",
    "typesense_memory_fragmentation_ratio": "0.06",
    "typesense_memory_mapped_bytes": "69701632",
    "typesense_memory_metadata_bytes": "4588768",
    "typesense_memory_resident_bytes": "29630464",
    "typesense_memory_retained_bytes": "25718784"
  };

  setUp(() {
    mock = MockApiCall();
    metrics = Metrics(mock);
  });

  group('Metrics', () {
    test('has a resourcepath', () {
      expect(Metrics.resourcepath, equals('/metrics.json'));
    });
    test('retrieve() calls ApiCall.get()', () async {
      when(
        mock.get(
          '/metrics.json',
        ),
      ).thenAnswer((realInvocation) => Future.value(map));
      expect(await metrics.retrieve(), equals(map));
    });
  });
}
