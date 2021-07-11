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
    test('has a resourcepath', () {
      expect(Operations.resourcepath, equals('/operations'));
    });
    test('createSnapshot() calls ApiCall.post()', () async {
      when(
        mock.post(
          '/operations/snapshot',
          queryParams: {
            'snapshot_path': '/tmp/typesense-data-snapshot',
          },
        ),
      ).thenAnswer((realInvocation) => Future.value({"success": true}));
      expect(await operations.createSnapshot('/tmp/typesense-data-snapshot'),
          equals({"success": true}));
    });
    test('initLeaderElection() calls ApiCall.post()', () async {
      when(
        mock.post(
          '/operations/vote',
        ),
      ).thenAnswer((realInvocation) => Future.value({"success": true}));
      expect(await operations.initLeaderElection(), equals({"success": true}));
    });
  });
}
