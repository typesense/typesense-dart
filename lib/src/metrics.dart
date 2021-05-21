import 'services/api_call.dart';

class Metrics {
  final ApiCall _apiCall;
  static const String RESOURCEPATH = '/metrics.json';

  const Metrics(ApiCall apiCall) : _apiCall = apiCall;

  Future<Map<String, dynamic>> retrieve() async {
    return await _apiCall.get(RESOURCEPATH);
  }
}
