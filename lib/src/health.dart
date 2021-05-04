import 'api_call.dart';

class Health {
  final ApiCall _apiCall;
  static const String RESOURCEPATH = '/health';

  const Health(ApiCall apiCall) : _apiCall = apiCall;

  Future<Map<String, dynamic>> retrieve() async {
    return await _apiCall.get(RESOURCEPATH);
  }
}
