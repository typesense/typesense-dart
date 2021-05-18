import 'package:typesense/src/api_call.dart';
import 'package:typesense/src/collections.dart';
import 'dart:convert';

class Documents {
  final ApiCall _apicall;
  final String _collectionName;
  static const String RESOURCEPATH = '/documents';

  Documents(String collectionName, ApiCall apicall)
      : _apicall = apicall,
        _collectionName = collectionName;

  Future<Map<String, dynamic>> create(Map<String, dynamic> document,
      {Map<String, dynamic> options = const {}}) async {
    Map<String, dynamic> ops = new Map<String, dynamic>.from(options)
      ..addAll({"action": "create"});
    return await _apicall.post(_endPoint(),
        bodyParameters: document, queryParams: ops);
  }

  Future<Map<String, dynamic>> upsert(Map<String, dynamic> document,
      {Map<String, dynamic> options = const {}}) async {
    Map<String, dynamic> ops = new Map<String, dynamic>.from(options)
      ..addAll({"action": "upsert"});
    return await _apicall.post(_endPoint(),
        bodyParameters: document, queryParams: ops);
  }

  Future<Map<String, dynamic>> update(Map<String, dynamic> document,
      {Map<String, dynamic> options = const {}}) async {
    Map<String, dynamic> ops = new Map<String, dynamic>.from(options)
      ..addAll({"action": "update"});
    return await _apicall.post(_endPoint(),
        bodyParameters: document, queryParams: ops);
  }

  Future<Map<String, dynamic>> delete(Map<String, dynamic> document) async {
    return await _apicall.delete(_endPoint(), queryParams: document);
  }

  Future<Map<String, dynamic>> import(dynamic documents,
      {Map<String, dynamic> options = const {}}) async {
    String documentsInJsonl;
    if (documents is List) {
      List<String> documentJsonArray = [];
      documents.forEach((element) {
        documentJsonArray.add(jsonEncode(element));
      });
      documentsInJsonl = documentJsonArray.join("\n");
    } else {
      documentsInJsonl = documents;
    }
    return await _apicall.post(_endPoint(operation: 'import'),
        queryParams: options,
        bodyParameters: documentsInJsonl,
        additionalHeaders: {ApiCall.CONTENT_TYPE: 'text/plain'});
  }

  String _endPoint({String operation = ''}) {
    return "${Collections.RESOURCEPATH}/$_collectionName${Documents.RESOURCEPATH}/$operation";
  }
}
