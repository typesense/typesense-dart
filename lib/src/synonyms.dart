import 'dart:io';

import 'collections.dart';
import 'services/api_call.dart';

class Synonyms {
  final String _collectionName;
  final ApiCall _apiCall;
  static const resourcepath = '/synonyms';
  static bool _warnedDeprecated = false;

  const Synonyms(String collectionName, ApiCall apiCall)
      : _collectionName = collectionName,
        _apiCall = apiCall;

  static void _warnDeprecated() {
    if (_warnedDeprecated) {
      return;
    }
    _warnedDeprecated = true;
    stderr.writeln(
      "[typesense] 'Synonyms' is deprecated on Typesense Server v30+. "
      "Use client.synonymSets instead.",
    );
  }

  /// Creates/updates a synonym corresponding to [synonymId].
  Future<Map<String, dynamic>> upsert(
      String synonymId, Map<String, dynamic> params) async {
    _warnDeprecated();
    final response = await _apiCall.put('$_endpointPath/$synonymId',
        bodyParameters: params);
    return Map<String, dynamic>.from(response);
  }

  /// Retrieves all synonyms.
  Future<Map<String, dynamic>> retrieve() async {
    _warnDeprecated();
    final response = await _apiCall.get(_endpointPath);
    return Map<String, dynamic>.from(response);
  }

  String get _endpointPath =>
      '${Collections.resourcepath}/$_collectionName$resourcepath';
}
