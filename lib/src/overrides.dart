import 'collections.dart';
import 'services/api_call.dart';

class Overrides {
  final String _collectionName;
  final ApiCall _apiCall;
  static const resourcepath = '/overrides';

  const Overrides(String collectionName, ApiCall apiCall)
      : _collectionName = collectionName,
        _apiCall = apiCall;

  /// Creates/updates an override corresponding to [overrideId].
  Future<Map<String, dynamic>> upsert(
      String overrideId, Map<String, dynamic> params) async {
    return await _apiCall.put('$_endpointPath/$overrideId',
        bodyParameters: params);
  }

  /// Retrieves all overrides.
  Future<Map<String, dynamic>> retrieve() async {
    return await _apiCall.get(_endpointPath);
  }

  String get _endpointPath =>
      '${Collections.resourcepath}/$_collectionName$resourcepath';
}
