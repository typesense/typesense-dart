import '../collections.dart';
import '../overrides.dart';
import '../services/api_call.dart';

class Override {
  final String _overrideId;
  final String _collectionName;
  final ApiCall _apiCall;

  const Override(
    String overrideId,
    String collectionName,
    ApiCall apiCall,
  )   : _overrideId = overrideId,
        _collectionName = collectionName,
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
