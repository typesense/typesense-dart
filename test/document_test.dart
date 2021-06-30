import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:typesense/src/services/api_call.dart';
import 'package:typesense/src/document.dart';

class MockApiCall extends Mock implements ApiCall {}

void main() {
  group('Document', () {
    Document document;
    MockApiCall mock;
    final documentMap = {
      "id": "124",
      "company_name": "Stark Industries",
      "num_employees": 5215,
      "country": "USA"
    };

    setUp(() {
      mock = MockApiCall();
      document = Document(
        'companies',
        '124',
        mock,
      );
    });

    test('delete() calls ApiCall.delete()', () async {
      when(
        mock.delete(
          '/collections/companies/documents/124',
        ),
      ).thenAnswer((realInvocation) => Future.value(documentMap));
      expect(await document.delete(), equals(documentMap));
    });
    test('retrieve() calls ApiCall.get()', () async {
      when(
        mock.get(
          '/collections/companies/documents/124',
        ),
      ).thenAnswer((realInvocation) => Future.value(documentMap));
      expect(await document.retrieve(), equals(documentMap));
    });
    test('update() calls ApiCall.patch()', () async {
      final partialDocument = {
        "company_name": "Stark Industries",
        "num_employees": 5500
      };
      when(
        mock.patch('/collections/companies/documents/124',
            bodyParameters: partialDocument, queryParams: {}),
      ).thenAnswer((realInvocation) => Future.value(partialDocument));
      expect(await document.update(partialDocument), equals(partialDocument));
    });
  });
}
