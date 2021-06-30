import 'configuration.dart';
import 'services/api_call.dart';

class MultiSearch {
  final ApiCall _apiCall;
  final bool useTextContentType;
  static const String RESOURCEPATH = '/multi_search';

  const MultiSearch(ApiCall apiCall, {this.useTextContentType = false})
      : _apiCall = apiCall;

  /// Performs the multi-search using the [queryParams].
  ///
  /// Used to send multiple search requests in a single HTTP request. This is
  /// especially useful to avoid round-trip network latencies incurred otherwise
  /// if each of these requests are sent in separate HTTP requests.
  ///
  /// This can also be used to do a federated search across multiple collections
  /// in a single HTTP request.
  ///
  /// To cache the search result locally, [Configuration.cachedSearchResultsTTL]
  /// must be specified.
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
