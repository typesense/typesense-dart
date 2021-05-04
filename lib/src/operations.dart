import 'api_call.dart';

class Operations {
  final ApiCall _apiCall;
  static const String RESOURCEPATH = '/operations';

  const Operations(ApiCall apiCall) : _apiCall = apiCall;

  Future<Map<String, dynamic>> perform(
      String operationName, Map<String, dynamic> queryParameters) async {
    return await _apiCall.post('$RESOURCEPATH/$operationName',
        queryParams: queryParameters);
  }
}
