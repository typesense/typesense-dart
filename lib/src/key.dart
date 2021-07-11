import 'keys.dart';
import 'services/api_call.dart';

class Key {
  final int _id;
  final ApiCall _apiCall;

  Key(int id, ApiCall apiCall)
      : _id = id,
        _apiCall = apiCall;

  /// Retrieves metadata of a key.
  Future<Map<String, dynamic>> retrieve() async {
    return await _apiCall.get(_endpointPath);
  }

  /// Deletes a key.
  Future<Map<String, dynamic>> delete() async {
    return await _apiCall.delete(_endpointPath);
  }

  String get _endpointPath => '${Keys.resourcepath}/$_id';
}
