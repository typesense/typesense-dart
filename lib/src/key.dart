import 'keys.dart';
import 'services/api_call.dart';

class Key {
  final int _id;
  final ApiCall _apiCall;

  Key(int id, ApiCall apiCall)
      : _id = id,
        _apiCall = apiCall;

  Future<Map<String, dynamic>> retrieve() async {
    return await _apiCall.get(_endpointPath);
  }

  Future<Map<String, dynamic>> delete() async {
    return await _apiCall.delete(_endpointPath);
  }

  String get _endpointPath => '${Keys.RESOURCEPATH}/$_id';
}
