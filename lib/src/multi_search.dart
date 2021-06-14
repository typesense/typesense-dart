import './services/api_call.dart';

class MultiSearch {
  final ApiCall _apiCall;
  final bool useTextContentType;
  static const String RESOURCEPATH = '/multi_search';

  const MultiSearch(ApiCall apiCall, {this.useTextContentType = false})
      : _apiCall = apiCall;

  Future<Map<String, dynamic>> perform(Map<String, dynamic> searchRequests,
      {Map<String, String> queryParams}) async {
    final additionalHeaders = <String, String>{};
    if (useTextContentType) {
      additionalHeaders[CONTENT_TYPE] = 'text/plain';
    }
    return await _apiCall.post(
      RESOURCEPATH,
      bodyParameters: searchRequests,
      queryParams: queryParams,
      additionalHeaders: additionalHeaders,
      shouldCacheResult: true,
    );
  }
}
