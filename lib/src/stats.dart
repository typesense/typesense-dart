import 'services/api_call.dart';

class Stats {
  final ApiCall _apiCall;
  static const String resourcepath = '/stats.json';

  const Stats(ApiCall apiCall) : _apiCall = apiCall;

  /// Retrieves the number of average requests per second and latencies for all
  /// the requests in the last 10 seconds.
  Future<Map<String, dynamic>> retrieve() async {
    return await _apiCall.get(resourcepath);
  }
}
