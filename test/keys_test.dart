import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:typesense/src/keys.dart';
import 'package:typesense/src/services/api_call.dart';

class MockApiCall extends Mock implements ApiCall {}

void main() {
  Keys keys;
  MockApiCall mock;

  setUp(() {
    mock = MockApiCall();
    keys = Keys(mock);
  });

  group('Keys', () {
    test('has a RESOURCEPATH', () {
      expect(Keys.RESOURCEPATH, equals('/keys'));
    });
    test('create() calls Api.post()', () async {
      when(mock.post('/keys', bodyParameters: {
        'description': 'Search-only companies key.',
        'actions': ['documents:search'],
        'collections': ['companies']
      })).thenAnswer((realInvocation) => Future.value({
            "actions": ["*"],
            "collections": ["*"],
            "description": "Admin key.",
            "id": 1,
            "value": "k8pX5hD0793d8YQC5aD1aEPd7VleSuGP"
          }));

      expect(
          await keys.create({
            'description': 'Search-only companies key.',
            'actions': ['documents:search'],
            'collections': ['companies']
          }),
          equals({
            "actions": ["*"],
            "collections": ["*"],
            "description": "Admin key.",
            "id": 1,
            "value": "k8pX5hD0793d8YQC5aD1aEPd7VleSuGP"
          }));
    });
    test('retrieve() calls Api.get()', () async {
      when(mock.get('/keys')).thenAnswer((realInvocation) => Future.value({
            "keys": [
              {
                "actions": ["documents:search"],
                "collections": ["users"],
                "description": "Search-only key.",
                "id": 1,
                "value_prefix": "iKBT"
              },
              {
                "actions": ["documents:search"],
                "collections": ["users"],
                "description": "Search-only key.",
                "id": 2,
                "value_prefix": "wst8"
              }
            ]
          }));

      expect(
          await keys.retrieve(),
          equals({
            "keys": [
              {
                "actions": ["documents:search"],
                "collections": ["users"],
                "description": "Search-only key.",
                "id": 1,
                "value_prefix": "iKBT"
              },
              {
                "actions": ["documents:search"],
                "collections": ["users"],
                "description": "Search-only key.",
                "id": 2,
                "value_prefix": "wst8"
              }
            ]
          }));
    });
    test('has a generateScopedSearchKey() method', () {
      expect(
          keys.generateScopedSearchKey('RN23GFr1s6jQ9kgSNg2O7fYcAUXU7127',
              {'filter_by': 'company_id:124', 'expires_at': 1906054106}),
          equals(
              'OW9DYWZGS1Q1RGdSbmo0S1QrOWxhbk9PL2kxbTU1eXA3bCthdmE5eXJKRT1STjIzeyJmaWx0ZXJfYnkiOiJjb21wYW55X2lkOjEyNCIsImV4cGlyZXNfYXQiOjE5MDYwNTQxMDZ9'));
    });
  });
}
