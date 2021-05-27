import '../documents.dart';
import '../collections.dart';
import '../services/api_call.dart';

class Document {
  final String _collectionName;
  final String _documentId;
  final ApiCall _apiCall;

  Document(String documentId, String collectionName, ApiCall apiCall)
      : _collectionName = collectionName,
        _documentId = documentId,
        _apiCall = apiCall {
    if (documentId == null || documentId.isEmpty) {
      throw ArgumentError('Ensure Document.documentId is set');
    }
    if (collectionName == null || collectionName.isEmpty) {
      throw ArgumentError('Ensure Document.collectionName is set');
    }
  }

  Future<Map<String, dynamic>> delete() async {
    return await _apiCall.delete(_endpointPath);
  }

  Future<Map<String, dynamic>> retrieve() async {
    return await _apiCall.get(_endpointPath);
  }

  Future<Map<String, dynamic>> update(
    Map<String, dynamic> partialDocument, {
    Map<String, dynamic> options,
  }) async {
    return await _apiCall.patch(_endpointPath,
        bodyParameters: partialDocument, queryParams: options);
  }

  String get _endpointPath =>
      '${Collections.RESOURCEPATH}/$_collectionName${Documents.RESOURCEPATH}/$_documentId';
}
