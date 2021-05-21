import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:typesense/src/services/api_call.dart';

import 'package:typesense/src/operations.dart';

class MockApiCall extends Mock implements ApiCall {}

void main() {
  Operations operations;
  MockApiCall mock;

  setUp(() {
    mock = MockApiCall();
    operations = Operations(mock);
  });

  group('Operations', () {
    test('has a RESOURCEPATH', () {
      expect(Operations.RESOURCEPATH, equals('/operations'));
    });
    test('perform() calls ApiCall.post()', () async {
      when(
        mock.post(
          '/operations/snapshot',
          queryParams: {
            'snapshot_path': '/tmp/typesense-data-snapshot',
          },
        ),
      ).thenAnswer((realInvocation) => Future.value({"success": true}));
      expect(
          await operations.perform(
            'snapshot',
            // ignore: unnecessary_cast
            {
              'snapshot_path': '/tmp/typesense-data-snapshot',
            } as Map<String, dynamic>,
          ),
          equals({"success": true}));
    });
  });
}
