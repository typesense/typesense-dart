import 'services/api_call.dart';

class Metrics {
  final ApiCall _apiCall;
  static const String resourcepath = '/metrics.json';

  const Metrics(ApiCall apiCall) : _apiCall = apiCall;

  /// Retrieves current RAM, CPU, Disk & Network usage metrics.
  Future<Map<String, dynamic>> retrieve() async {
    return await _apiCall.get(resourcepath);
  }
}
