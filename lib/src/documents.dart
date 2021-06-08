import 'dart:convert';

import 'collections.dart';
import 'services/api_call.dart';
import 'services/documents_api_call.dart';
import 'exceptions/exceptions.dart';

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

  /// Imports the [documents] into the server.
  Future<List<Map<String, dynamic>>> importDocuments(
    List<Map<String, dynamic>> documents, {
    Map<String, dynamic> options,
  }) async {
    final documentsInJSONLFormat =
            documents.map((document) => json.encode(document)).join('\n'),
        resultsInJSONFormat =
            (await _import(documentsInJSONLFormat, options: options))
                .split('\n')
                .map((result) => json.decode(result) as Map<String, dynamic>)
                .toList(),
        failedItems =
            resultsInJSONFormat.where((result) => !result['success']).toList();

    if (failedItems.isNotEmpty) {
      throw ImportError(
          '${resultsInJSONFormat.length - failedItems.length} documents imported successfully, ${failedItems.length} documents failed during import. Use `error.importResults` from the raised exception to get a detailed error reason for each document.',
          resultsInJSONFormat);
    }

    return resultsInJSONFormat;
  }

  /// Imports the [jsonl] formatted documents into the server.
  Future<String> importJsonlDocuments(
    String jsonl, {
    Map<String, dynamic> options,
  }) async {
    return await _import(jsonl, options: options);
  }

  Future<String> _import(
    String jsonl, {
    Map<String, dynamic> options,
  }) async {
    return await _documentApiCall.post('$_endPoint/import',
        queryParams: options,
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
