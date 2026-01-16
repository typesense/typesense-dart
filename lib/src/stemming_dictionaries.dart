import 'dart:convert';

import 'models/models.dart';
import 'services/api_call.dart';
import 'stemming_dictionary.dart';

class StemmingDictionaries {
  final ApiCall _apiCall;
  static const String resourcepath = '/stemming/dictionaries';
  final _individualDictionaries = <String, StemmingDictionary>{};

  StemmingDictionaries(ApiCall apiCall) : _apiCall = apiCall;

  /// Retrieves the list of stemming dictionaries.
  Future<StemmingDictionariesRetrieveSchema> retrieve() async {
    final response = await _apiCall.get(resourcepath);
    return StemmingDictionariesRetrieveSchema.fromJson(response);
  }

  /// Creates or updates a stemming dictionary from JSONL payload.
  Future<String> upsertRaw(String dictionaryId, String jsonl) async {
    final response = await _apiCall.postRaw(
      '${resourcepath}/import',
      queryParams: {'id': dictionaryId},
      bodyParameters: jsonl,
      additionalHeaders: {contentType: 'text/plain'},
    );
    return response;
  }

  /// Creates or updates a stemming dictionary from structured inputs.
  Future<List<StemmingDictionaryCreateSchema>> upsert(
    String dictionaryId,
    List<StemmingDictionaryCreateSchema> wordRootCombinations,
  ) async {
    final jsonl = wordRootCombinations
        .map((combo) => json.encode(combo.toJson()))
        .join('\n');
    final response = await upsertRaw(dictionaryId, jsonl);
    return response
        .split('\n')
        .where((line) => line.isNotEmpty)
        .map((line) => StemmingDictionaryCreateSchema.fromJson(
            Map<String, dynamic>.from(json.decode(line))))
        .toList();
  }

  StemmingDictionary operator [](String dictionaryId) {
    if (!_individualDictionaries.containsKey(dictionaryId)) {
      _individualDictionaries[dictionaryId] =
          StemmingDictionary(dictionaryId, _apiCall);
    }
    return _individualDictionaries[dictionaryId]!;
  }
}
