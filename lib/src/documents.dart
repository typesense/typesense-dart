import './services/api_call.dart';
import './services/documents_api_call.dart';
import './collections.dart';

class Documents {
  final ApiCall _apicall;
  final DocumentsApiCall _documentApiCall;
  final String _collectionName;
  static const String RESOURCEPATH = '/documents';

  Documents(
      String collectionName, ApiCall apicall, DocumentsApiCall documentApiCall)
      : _apicall = apicall,
        _collectionName = collectionName,
        _documentApiCall = documentApiCall;

  Future<Map<String, dynamic>> create(Map<String, dynamic> document,
      {Map<String, dynamic> options = const {}}) async {
    return await _apicall.post(_endPoint,
        bodyParameters: document,
        queryParams: {...options, "action": "create"});
  }

  Future<Map<String, dynamic>> upsert(Map<String, dynamic> document,
      {Map<String, dynamic> options = const {}}) async {
    return await _apicall.post(_endPoint,
        bodyParameters: document,
        queryParams: {...options, "action": "upsert"});
  }

  Future<Map<String, dynamic>> update(Map<String, dynamic> document,
      {Map<String, dynamic> options = const {}}) async {
    return await _apicall.post(_endPoint,
        bodyParameters: document,
        queryParams: {...options, "action": "update"});
  }

  Future<Map<String, dynamic>> delete(
      {Map<String, String> queryParameters}) async {
    return await _apicall.delete(_endPoint, queryParams: queryParameters);
  }

  // TODO: Implement after Document class.
  // Future<Set<Document>> importDocuments(Set<Document> documents,
  //     {Map<String, dynamic> options = const {}}) async {}

  /// Imports the [jsonl] formatted documents into the server.
  Future<String> importJsonlDocuments(
    String jsonl, {
    Map<String, String> queryParameters,
  }) async {
    return await _documentApiCall.post('$_endPoint/import',
        queryParams: queryParameters,
        bodyParameters: jsonl,
        additionalHeaders: {CONTENT_TYPE: 'text/plain'});
  }

  /// Returns the jsonl formatted documents.
  Future<String> exportJsonlDocuments() async {
    return await _documentApiCall.get('$_endPoint/export');
  }

  String get _endPoint =>
      "${Collections.RESOURCEPATH}/$_collectionName${Documents.RESOURCEPATH}";
}
