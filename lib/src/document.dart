import 'documents.dart';
import 'collections.dart';
import 'services/api_call.dart';

class Document {
  final String _collectionName, _documentId;
  final ApiCall _apiCall;

  const Document(String collectionName, String documentId, ApiCall apiCall)
      : _collectionName = collectionName,
        _documentId = documentId,
        _apiCall = apiCall;

  /// Deletes a document.
  Future<Map<String, dynamic>> delete() async {
    return await _apiCall.delete(_endpointPath);
  }

  /// Retrieves a document from a collection.
  Future<Map<String, dynamic>> retrieve() async {
    return await _apiCall.get(_endpointPath);
  }

  /// Updates a document.
  ///
  /// Partial updates, which only update a subset of the document fields, are
  /// allowed.
  Future<Map<String, dynamic>> update(
    Map<String, dynamic> partialDocument, {
    Map<String, dynamic> options = const {},
  }) async {
    return await _apiCall.patch(_endpointPath,
        bodyParameters: partialDocument, queryParams: options);
  }

  String get _endpointPath =>
      '${Collections.RESOURCEPATH}/$_collectionName${Documents.RESOURCEPATH}/$_documentId';
}
