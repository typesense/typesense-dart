import 'dart:io';

import 'collections.dart';
import 'synonyms.dart';
import 'services/api_call.dart';

class Synonym {
  final String _collectionName, _synonymId;
  final ApiCall _apiCall;
  static bool _warnedDeprecated = false;

  const Synonym(String collectionName, String synonymId, ApiCall apiCall)
      : _collectionName = collectionName,
        _synonymId = synonymId,
        _apiCall = apiCall;

  static void _warnDeprecated() {
    if (_warnedDeprecated) {
      return;
    }
    _warnedDeprecated = true;
    stderr.writeln(
      "[typesense] 'Synonym' is deprecated on Typesense Server v30+. "
      "Use client.synonymSets instead.",
    );
  }

  /// Retrieves a synonym.
  Future<Map<String, dynamic>> retrieve() async {
    _warnDeprecated();
    final response = await _apiCall.get(_endpointPath);
    return Map<String, dynamic>.from(response);
  }

  /// Deletes a synonym.
  Future<Map<String, dynamic>> delete() async {
    _warnDeprecated();
    final response = await _apiCall.delete(_endpointPath);
    return Map<String, dynamic>.from(response);
  }

  String get _endpointPath =>
      '${Collections.resourcepath}/$_collectionName${Synonyms.resourcepath}/$_synonymId';
}
