import 'dart:collection';

import 'configuration.dart';
import 'services/node_pool.dart';
import 'services/request_cache.dart';
import 'services/api_call.dart';
import 'services/documents_api_call.dart';
import 'services/collections_api_call.dart';
import 'collections.dart';
import 'collection.dart';
import 'aliases.dart';
import 'alias.dart';
import 'keys.dart';
import 'key.dart';
import 'debug.dart';
import 'metrics.dart';
import 'health.dart';
import 'operations.dart';
import 'multi_search.dart';

class Client {
  final Configuration config;
  final ApiCall _apiCall;
  final DocumentsApiCall _documentsApiCall;
  final Collections collections;
  final Aliases aliases;
  final Keys keys;
  final Debug debug;
  final Metrics metrics;
  final Health health;
  final Operations operations;
  final MultiSearch multiSearch;
  final _individualCollections = HashMap<String, Collection>(),
      _individualAliases = HashMap<String, Alias>(),
      _individualKeys = HashMap<int, Key>();

  Client._(
      this.config,
      this._apiCall,
      this._documentsApiCall,
      this.collections,
      this.aliases,
      this.keys,
      this.debug,
      this.metrics,
      this.health,
      this.operations,
      this.multiSearch);

  factory Client(Configuration config) {
    final nodePool = NodePool(config),
        apiCall = ApiCall(config, nodePool, RequestCache());
    return Client._(
        config,
        apiCall,
        DocumentsApiCall(config, nodePool),
        Collections(apiCall, CollectionsApiCall(config, nodePool)),
        Aliases(apiCall),
        Keys(apiCall),
        Debug(apiCall),
        Metrics(apiCall),
        Health(apiCall),
        Operations(apiCall),
        MultiSearch(apiCall));
  }

  Collection collection(String collectionName) {
    if (!_individualCollections.containsKey(collectionName)) {
      _individualCollections[collectionName] =
          Collection(collectionName, _apiCall, _documentsApiCall);
    }
    return _individualCollections[collectionName];
  }

  Alias alias(String aliasName) {
    if (!_individualAliases.containsKey(aliasName)) {
      _individualAliases[aliasName] = Alias(aliasName, _apiCall);
    }
    return _individualAliases[aliasName];
  }

  Key key(int id) {
    if (!_individualKeys.containsKey(id)) {
      _individualKeys[id] = Key(id, _apiCall);
    }
    return _individualKeys[id];
  }
}
