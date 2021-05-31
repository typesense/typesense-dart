import '../collections.dart';
import '../synonyms.dart';
import '../services/api_call.dart';

class Synonym {
  final String _collectionName, _synonymId;
  final ApiCall _apiCall;

  const Synonym(String collectionName, String synonymId, ApiCall apiCall)
      : _collectionName = collectionName,
        _synonymId = synonymId,
        _apiCall = apiCall;

  Future<Map<String, dynamic>> retrieve() async {
    return await _apiCall.get(_endpointPath);
  }

  Future<Map<String, dynamic>> delete() async {
    return await _apiCall.delete(_endpointPath);
  }

  String get _endpointPath =>
      '${Collections.RESOURCEPATH}/$_collectionName${Synonyms.RESOURCEPATH}/$_synonymId';
}
