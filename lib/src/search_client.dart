import 'dart:collection';

import 'configuration.dart';
import 'multi_search.dart';
import 'models/collection.dart';
import 'services/node_pool.dart';
import 'services/api_call.dart';
import 'services/documents_api_call.dart';

class SearchClient {
  Configuration _config;
  ApiCall _apiCall;
  DocumentsApiCall _documentsApiCall;
  MultiSearch _multiSearch;
  final _individualCollections = HashMap<String, Collection>();

  SearchClient(Configuration config) {
    // In v0.20.0 we restrict query params to 2000 in length. But sometimes
    // scoped API keys can be over this limit, so we send long keys as headers
    // instead. The tradeoff is that using a header to send the API key will
    // trigger the browser to send an OPTIONS request first.
    _config = Configuration.updateParameters(
      config,
      sendApiKeyAsQueryParam: (config.apiKey.length < 2000),
    );
    final _nodePool = NodePool(_config);

    _apiCall = ApiCall(_config, _nodePool);
    _documentsApiCall = DocumentsApiCall(_config, _nodePool);
    _multiSearch = MultiSearch(_apiCall, useTextContentType: true);
  }

  Configuration get configuration => _config;

  MultiSearch get multiSearch => _multiSearch;

  Collection collection(String collectionName) {
    if (!_individualCollections.containsKey(collectionName)) {
      _individualCollections[collectionName] =
          Collection(collectionName, _apiCall, _documentsApiCall);
    }
    return _individualCollections[collectionName];
  }
}
