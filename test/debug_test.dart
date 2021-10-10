import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:typesense/src/debug.dart';

import 'test_utils.mocks.dart';

void main() {
  late Debug debug;
  late MockApiCall mock;

  setUp(() {
    mock = MockApiCall();
    debug = Debug(mock);
  });

  group('Debug', () {
    test('has a resourcepath', () {
      expect(Debug.resourcepath, '/debug');
    });

    test('retrieve() calls ApiCall.get()', () async {
      when(mock.get('/debug')).thenAnswer(
          (realInvocation) => Future.value({'state': 1, 'version': '0.20.0'}));
      expect(await debug.retrieve(), {'state': 1, 'version': '0.20.0'});
    });
  });
}
