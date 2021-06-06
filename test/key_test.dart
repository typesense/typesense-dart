import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:typesense/src/key.dart';
import 'package:typesense/src/services/api_call.dart';

class MockApiCall extends Mock implements ApiCall {}

void main() {
  group('Key', () {
    Key key;

    MockApiCall mock;
    setUp(() {
      mock = MockApiCall();
      key = Key(1, mock);
    });
    test('retrieve() calls Api.get()', () async {
      when(mock.get('/keys/1')).thenAnswer((realInvocation) => Future.value({
            "actions": ["documents:search"],
            "collections": ["*"],
            "description": "Search-only key.",
            "id": 1,
            "value_prefix": "vxpx"
          }));

      expect(
          await key.retrieve(),
          equals({
            "actions": ["documents:search"],
            "collections": ["*"],
            "description": "Search-only key.",
            "id": 1,
            "value_prefix": "vxpx"
          }));
    });
    test('delete() calls Api.delete()', () async {
      when(mock.delete('/keys/1'))
          .thenAnswer((realInvocation) => Future.value({"id": 1}));

      expect(await key.delete(), equals({"id": 1}));
    });
  });
}
