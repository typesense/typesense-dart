import 'dart:collection';

import 'models/schema.dart';
import 'document.dart';
import 'override.dart';
import 'synonym.dart';
import 'collections.dart';
import 'documents.dart';
import 'overrides.dart';
import 'synonyms.dart';
import 'services/api_call.dart';
import 'services/documents_api_call.dart';

class Collection {
  final String _name;
  final ApiCall _apiCall;
  final Documents _documents;
  final Overrides _overrides;
  final Synonyms _synonyms;

  final _individualDocuments = HashMap<String, Document>(),
      _individualOverrides = HashMap<String, Override>(),
      _individualSynonyms = HashMap<String, Synonym>();

  Collection(
      String collectionName, ApiCall apiCall, DocumentsApiCall documentsApiCall)
      : _name = collectionName,
        _apiCall = apiCall,
        _documents = Documents(collectionName, apiCall, documentsApiCall),
        _overrides = Overrides(collectionName, apiCall),
        _synonyms = Synonyms(collectionName, apiCall);

  /// Retrieves the [Schema] of the specified collection.
  Future<Schema> retrieve() async {
    return Schema.fromMap(await _apiCall.get(_endpointPath));
  }

  /// Deletes the specified collection.
  Future<Schema> delete() async {
    return Schema.fromMap(await _apiCall.delete(_endpointPath));
  }

  Documents get documents => _documents;

  Document document(String documentId) {
    if (!_individualDocuments.containsKey(documentId)) {
      _individualDocuments[documentId] = Document(_name, documentId, _apiCall);
    }
    return _individualDocuments[documentId]!;
  }

  Overrides get overrides => _overrides;

  Override override(String overrideId) {
    if (!_individualOverrides.containsKey(overrideId)) {
      _individualOverrides[overrideId] = Override(_name, overrideId, _apiCall);
    }
    return _individualOverrides[overrideId]!;
  }

  Synonyms get synonyms => _synonyms;

  Synonym synonym(String synonymId) {
    if (!_individualSynonyms.containsKey(synonymId)) {
      _individualSynonyms[synonymId] = Synonym(_name, synonymId, _apiCall);
    }
    return _individualSynonyms[synonymId]!;
  }

  String get _endpointPath => '${Collections.resourcepath}/$_name';
}
