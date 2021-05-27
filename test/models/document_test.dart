import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:typesense/src/services/api_call.dart';
import 'package:typesense/src/models/document.dart';

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
        '124',
        'companies',
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
            bodyParameters: partialDocument, queryParams: null),
      ).thenAnswer((realInvocation) => Future.value(partialDocument));
      expect(await document.update(partialDocument), equals(partialDocument));
    });
  });

  group('Document initialization', () {
    MockApiCall mock;
    setUp(() {
      mock = MockApiCall();
    });

    test('with null/empty documentId throws', () {
      expect(
        () => Document(
          null,
          'companies',
          mock,
        ),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Ensure Document.documentId is set',
          ),
        ),
      );
      expect(
        () => Document(
          '',
          'companies',
          mock,
        ),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Ensure Document.documentId is set',
          ),
        ),
      );
    });
    test('with null/empty collectionName throws', () {
      expect(
        () => Document(
          '124',
          null,
          mock,
        ),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Ensure Document.collectionName is set',
          ),
        ),
      );
      expect(
        () => Document(
          '124',
          '',
          mock,
        ),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Ensure Document.collectionName is set',
          ),
        ),
      );
    });
  });
}
