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
    test("Create calls ApiCall.post()", () async {
      final document = {
        'id': '124',
        'company_name': 'Stark Industries',
        'num_employees': 5215,
        'country': 'USA',
      };
      when(mock.post("/collections/companies/documents?action=create"))
          .thenAnswer((realInvocation) => Future.value(document));
      expect(await documents.create(document), equals(document));
    });
  });
}
