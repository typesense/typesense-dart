import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:typesense/src/debug.dart';
import 'package:typesense/src/services/api_call.dart';

class MockApiCall extends Mock implements ApiCall {}

void main() {
  Debug debug;
  MockApiCall mock;

  setUp(() {
    mock = MockApiCall();
    debug = Debug(mock);
  });

  group('Debug', () {
    test('has a RESOURCEPATH', () {
      expect(Debug.RESOURCEPATH, '/debug');
    });

    test('retrieve() calls ApiCall.get()', () async {
      when(mock.get('/debug')).thenAnswer(
          (realInvocation) => Future.value({'state': 1, 'version': '0.20.0'}));
      expect(await debug.retrieve(), {'state': 1, 'version': '0.20.0'});
    });
  });
}
