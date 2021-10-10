import 'dart:convert';

import 'collections.dart';
import 'configuration.dart';
import 'services/api_call.dart';
import 'services/documents_api_call.dart';
import 'exceptions/exceptions.dart';

class Documents {
  final ApiCall _apicall;
  final DocumentsApiCall _documentApiCall;
  final String _collectionName;
  static const String resourcepath = '/documents';

  Documents(
      String collectionName, ApiCall apicall, DocumentsApiCall documentApiCall)
      : _apicall = apicall,
        _collectionName = collectionName,
        _documentApiCall = documentApiCall;

  /// Creates a new [document].
  ///
  /// A document to be indexed in a given collection must conform to the schema
  /// of the collection.
  ///
  /// If the document contains an id field of type `String`, Typesense would use
  /// that field as the identifier for the document. Otherwise, Typesense would
  /// assign an identifier of its choice to the document.
  ///
  /// Note that the id should not include spaces or any other characters that
  /// encoding in [urls](https://www.w3schools.com/tags/ref_urlencode.asp).
  Future<Map<String, dynamic>> create(Map<String, dynamic> document,
      {Map<String, dynamic>? options}) async {
    return await _apicall.post(_endPoint,
        bodyParameters: document,
        queryParams: {...?options, "action": "create"});
  }

  /// Upserts a [document].
  Future<Map<String, dynamic>> upsert(Map<String, dynamic> document,
      {Map<String, dynamic>? options}) async {
    return await _apicall.post(_endPoint,
        bodyParameters: document,
        queryParams: {...?options, "action": "upsert"});
  }

  /// Updates a [document].
  Future<Map<String, dynamic>> update(Map<String, dynamic> document,
      {Map<String, dynamic>? options}) async {
    return await _apicall.post(_endPoint,
        bodyParameters: document,
        queryParams: {...?options, "action": "update"});
  }

  /// Deletes all the documents the match the [queryParameters].
  Future<Map<String, dynamic>> delete(
      Map<String, String> queryParameters) async {
    return await _apicall.delete(_endPoint, queryParams: queryParameters);
  }

  /// Imports the [documents] into the server.
  Future<List<Map<String, dynamic>>> importDocuments(
    List<Map<String, dynamic>> documents, {
    Map<String, dynamic>? options,
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
  Future<String> importJSONL(
    String jsonl, {
    Map<String, dynamic>? options,
  }) async {
    return await _import(jsonl, options: options);
  }

  Future<String> _import(
    String jsonl, {
    Map<String, dynamic>? options,
  }) async {
    return await _documentApiCall.post('$_endPoint/import',
        queryParams: options,
        bodyParameters: jsonl,
        additionalHeaders: {contentType: 'text/plain'});
  }

  /// Returns the documents belonging to a collection in JSONL format.
  ///
  /// If [queryParams] is specified, only documents matching the criteria would
  /// be returned.
  Future<String> exportJSONL({Map<String, dynamic>? queryParams}) async {
    return await _documentApiCall.get(
      '$_endPoint/export',
      queryParams: queryParams,
    );
  }

  /// Search through the documents with the [searchParameters].
  ///
  /// [searchParameters] consists of a query against one or more text fields and
  /// a list of filters against numerical or facet fields. You can also sort and
  /// facet your results.
  ///
  /// To cache the search result locally, [Configuration.cachedSearchResultsTTL]
  /// must be specified.
  Future<Map<String, dynamic>> search(
      Map<String, dynamic> searchParameters) async {
    return await _apicall.get(
      '$_endPoint/search',
      queryParams: searchParameters,
      shouldCacheResult: true,
    );
  }

  String get _endPoint =>
      "${Collections.resourcepath}/$_collectionName${Documents.resourcepath}";
}
