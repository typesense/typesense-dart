import 'dart:convert';
import 'dart:html';

import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:typesense/src/documents.dart';
import 'package:typesense/src/api_call.dart';

class MockApiCall extends Mock implements ApiCall {}

void main() {
  Documents documents;
  MockApiCall mock;

  setUp(() {
    mock = MockApiCall();
    documents = Documents("companies", mock);
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
      when(mock.post("/collections/companies/documents/",
              bodyParameters: document, queryParams: {"action": "create"}))
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
      when(mock.post("/collections/companies/documents/",
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
      when(mock.post("/collections/companies/documents/",
              bodyParameters: document, queryParams: {"action": "update"}))
          .thenAnswer((realInvocation) => Future.value(document));
      expect(await documents.update(document), equals(document));
    });
    test("delete() calls ApiCall.post()", () async {
      final document = {
        'company_name': 'Stark Industries',
        'num_employees': 5215,
        'country': 'USA',
      };
      when(mock.delete("/collections/companies/documents/",
              queryParams: document))
          .thenAnswer((realInvocation) => Future.value(document));
      expect(await documents.delete(document), equals(document));
    });
    test("import() calls ApiCall.post() with string", () async {
      final documentJson = [
        {
          "id": "124",
          "company_name": "Stark Industries",
          "num_employees": 5215,
          "country": "US"
        },
        {
          "id": "125",
          "company_name": "Future Technology",
          "num_employees": 1232,
          "country": "UK"
        },
        {
          "id": "126",
          "company_name": "Random Corp.",
          "num_employees": 531,
          "country": "AU"
        },
      ];
      final documentJsonl = jsonEncode(documentJson);
      final result = [
        {"success": true},
        {"success": true},
        {"success": true}
      ];
      when(mock.post("/collections/companies/documents/import",
              bodyParameters: documentJsonl))
          .thenAnswer((realInvocation) => Future.value(result));
      expect(await documents.import(document), equals(result));
    });
  });
}
