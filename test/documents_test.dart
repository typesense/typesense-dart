import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:typesense/src/documents.dart';
import 'package:typesense/src/services/api_call.dart';
import 'package:typesense/src/services/documents_api_call.dart';
import 'package:typesense/src/exceptions/exceptions.dart';

class MockApiCall extends Mock implements ApiCall {}

class MockDocumentsApiCall extends Mock implements DocumentsApiCall {}

void main() {
  Documents documents;
  MockApiCall mockApiCall;
  MockDocumentsApiCall mockDocumentsApiCall;

  setUp(() {
    mockApiCall = MockApiCall();
    mockDocumentsApiCall = MockDocumentsApiCall();
    documents = Documents("companies", mockApiCall, mockDocumentsApiCall);
  });

  group("Documents", () {
    test('has a RESOURCEPATH', () {
      expect(Documents.RESOURCEPATH, equals('/documents'));
    });
    test("create() calls ApiCall.post()", () async {
      final document = {
        'id': '124',
        'company_name': 'Stark Industries',
        'num_employees': 5215,
        'country': 'USA',
      };
      when(mockApiCall.post("/collections/companies/documents",
              bodyParameters: document, queryParams: {'action': 'create'}))
          .thenAnswer((realInvocation) => Future.value(document));
      expect(await documents.create(document), equals(document));
    });
    test("upsert() calls ApiCall.post()", () async {
      final document = {
        'id': '124',
        'company_name': 'Stark Industries',
        'num_employees': 5215,
        'country': 'USA',
      };
      when(mockApiCall.post("/collections/companies/documents",
              bodyParameters: document, queryParams: {"action": "upsert"}))
          .thenAnswer((realInvocation) => Future.value(document));
      expect(await documents.upsert(document), equals(document));
    });
    test("update() calls ApiCall.post()", () async {
      final document = {
        'company_name': 'Stark Industries',
        'num_employees': 5215,
        'country': 'USA',
      };
      when(mockApiCall.post("/collections/companies/documents",
              bodyParameters: document, queryParams: {"action": "update"}))
          .thenAnswer((realInvocation) => Future.value(document));
      expect(await documents.update(document), equals(document));
    });
    test("delete() calls ApiCall.post()", () async {
      when(mockApiCall.delete("/collections/companies/documents",
              queryParams: {'filter_by': 'num_employees:>100'}))
          .thenAnswer((realInvocation) => Future.value({"num_deleted": 24}));
      expect(
          await documents
              .delete(queryParameters: {'filter_by': 'num_employees:>100'}),
          equals({"num_deleted": 24}));
    });
    test('importDocuments() calls DocumentsApiCall.post()', () async {
      when(mockDocumentsApiCall.post(
        "/collections/companies/documents/import",
        bodyParameters:
            '{"id":"124","company_name":"Stark Industries","num_employees":5215,"country":"USA"}',
        additionalHeaders: {CONTENT_TYPE: 'text/plain'},
        queryParams: null,
      )).thenAnswer((realInvocation) => Future.value('{"success": true}'));
      expect(
          await documents.importDocuments([
            {
              "id": "124",
              "company_name": "Stark Industries",
              "num_employees": 5215,
              "country": "USA"
            }
          ]),
          equals([
            {"success": true}
          ]));
    });
    test("importJsonlDocuments() calls DocumentsApiCall.post()", () async {
      final documentJsonl = '''
{"id": "124", "company_name": "Stark Industries", "num_employees": 5215, "country": "US"}
{"id": "125", "company_name": "Future Technology", "num_employees": 1232, "country": "UK"}
{"id": "126", "company_name": "Random Corp.", "num_employees": 531, "country": "AU"}''',
          result = '''
{"success": true}
{"success": true}
{"success": true}
''';
      when(mockDocumentsApiCall.post(
        "/collections/companies/documents/import",
        bodyParameters: documentJsonl,
        additionalHeaders: {CONTENT_TYPE: 'text/plain'},
        queryParams: null,
      )).thenAnswer((realInvocation) => Future.value(result));
      expect(
          await documents.importJsonlDocuments(documentJsonl), equals(result));
    });
    test("exportJsonlDocuments() calls DocumentsApiCall.get()", () async {
      final documentJsonl = '''
{"id": "124", "company_name": "Stark Industries", "num_employees": 5215, "country": "US"}
{"id": "125", "company_name": "Future Technology", "num_employees": 1232, "country": "UK"}
{"id": "126", "company_name": "Random Corp.", "num_employees": 531, "country": "AU"}
''';
      when(mockDocumentsApiCall.get(
        "/collections/companies/documents/export",
      )).thenAnswer((realInvocation) => Future.value(documentJsonl));
      expect(await documents.exportJsonlDocuments(), equals(documentJsonl));
    });
  });

  test('Documents.importDocuments throws ImportError if "success" is false',
      () async {
    when(mockDocumentsApiCall.post(
      "/collections/companies/documents/import",
      bodyParameters:
          '''{"id":"124","company_name":"Stark Industries","num_employees":"5215","country":"USA"}
{"id":"125","company_name":"Acme Corp","num_employees":2133,"country":"CA"}''',
      additionalHeaders: {CONTENT_TYPE: 'text/plain'},
      queryParams: null,
    )).thenAnswer((realInvocation) => Future.value(
        '''{"code":400,"document":"{\\"id\\": \\"124\\",\\"company_name\\": \\"Stark Industries\\",\\"num_employees\\": \\"5215\\",\\"country\\": \\"USA\\"}","error":"Field `num_employees` must be an int32.","success":false}
{"success":true}'''));
    expect(() async {
      await documents.importDocuments([
        {
          "id": "124",
          "company_name": "Stark Industries",
          "num_employees": "5215",
          "country": "USA"
        },
        {
          "id": "125",
          "company_name": "Acme Corp",
          "num_employees": 2133,
          "country": "CA"
        }
      ]);
    },
        throwsA(isA<ImportError>()
            .having(
          (e) => e.message,
          'message',
          '1 documents imported successfully, 1 documents failed during import. Use `error.importResults` from the raised exception to get a detailed error reason for each document.',
        )
            .having((e) => e.importResults, 'importResults', [
          {
            'code': 400,
            'document':
                '{"id": "124","company_name": "Stark Industries","num_employees": "5215","country": "USA"}',
            'error': 'Field `num_employees` must be an int32.',
            'success': false
          },
          {'success': true}
        ])));
  });
}
