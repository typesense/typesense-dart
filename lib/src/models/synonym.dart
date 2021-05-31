import '../collections.dart';
import '../synonyms.dart';
import '../services/api_call.dart';

class Synonym {
  final String _synonymId, _collectionName;
  final ApiCall _apiCall;

  const Synonym(String synonymId, String collectionName, ApiCall apiCall)
      : _synonymId = synonymId,
        _collectionName = collectionName,
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
