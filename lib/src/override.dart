import 'collections.dart';
import 'overrides.dart';
import 'services/api_call.dart';

class Override {
  final String _collectionName, _overrideId;
  final ApiCall _apiCall;

  const Override(String collectionName, String overrideId, ApiCall apiCall)
      : _collectionName = collectionName,
        _overrideId = overrideId,
        _apiCall = apiCall;

  Future<Map<String, dynamic>> delete() async {
    return await _apiCall.delete(_endpointPath);
  }

  Future<Map<String, dynamic>> retrieve() async {
    return await _apiCall.get(_endpointPath);
  }

  String get _endpointPath =>
      '${Collections.RESOURCEPATH}/$_collectionName${Overrides.RESOURCEPATH}/$_overrideId';
}
