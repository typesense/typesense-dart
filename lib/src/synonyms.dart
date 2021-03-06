import 'collections.dart';
import 'services/api_call.dart';

class Synonyms {
  final String _collectionName;
  final ApiCall _apiCall;
  static const resourcepath = '/synonyms';

  const Synonyms(String collectionName, ApiCall apiCall)
      : _collectionName = collectionName,
        _apiCall = apiCall;

  /// Creates/updates a synonym corresponding to [synonymId].
  Future<Map<String, dynamic>> upsert(
      String synonymId, Map<String, dynamic> params) async {
    return await _apiCall.put('$_endpointPath/$synonymId',
        bodyParameters: params);
  }

  /// Retrieves all synonyms.
  Future<Map<String, dynamic>> retrieve() async {
    return await _apiCall.get(_endpointPath);
  }

  String get _endpointPath =>
      '${Collections.resourcepath}/$_collectionName$resourcepath';
}
