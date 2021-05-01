import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:typesense/src/collections.dart';
import 'package:typesense/src/api_call.dart';

class MockApiCall extends Mock implements ApiCall {}

void main() {
  Collections collections;
  MockApiCall mock;

  setUp(() {
    mock = MockApiCall();
    collections = Collections(mock);
  });

  group('Collections', () {
    test('has a RESOURCEPATH', () {
      expect(collections.RESOURCEPATH, equals('/collections'));
    });

    test('retrieve() calls ApiCall.get()', () {
      final map = {
        "name": "companies",
        "num_documents": 0,
        "fields": [
          {"name": "company_name", "type": "string"},
          {"name": "num_employees", "type": "int32"},
          {"name": "country", "type": "string", "facet": true}
        ],
        "default_sorting_field": "num_employees"
      };
      when(mock.get('/collections'))
          .thenAnswer((realInvocation) => Future.value(map));
      expect(collections.retrieve(), equals(map));
    });
  });
}
