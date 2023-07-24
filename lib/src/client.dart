import 'dart:collection';

import 'configuration.dart';
import 'services/api_call.dart';
import 'services/node_pool.dart';
import 'services/request_cache.dart';
import 'services/documents_api_call.dart';
import 'services/collections_api_call.dart';
import 'collections.dart';
import 'collection.dart';
import 'aliases.dart';
import 'alias.dart';
import 'keys.dart';
import 'key.dart';
import 'debug.dart';
import 'stats.dart';
import 'health.dart';
import 'preset.dart';
import 'presets.dart';
import 'metrics.dart';
import 'operations.dart';
import 'multi_search.dart';

class Client {
  final Configuration config;
  final ApiCall _apiCall;
  final DocumentsApiCall _documentsApiCall;
  final Collections collections;
  final Aliases aliases;
  final Keys keys;
  final Presets presets;
  final Debug debug;
  final Stats stats;
  final Health health;
  final Metrics metrics;
  final Operations operations;
  final MultiSearch multiSearch;
  final _individualCollections = HashMap<String, Collection>(),
      _individualAliases = HashMap<String, Alias>(),
      _individualKeys = HashMap<int, Key>(),
      _individualPresets = HashMap<String, Preset>();

  Client._(
      this.config,
      this._apiCall,
      this._documentsApiCall,
      this.collections,
      this.aliases,
      this.keys,
      this.presets,
      this.debug,
      this.stats,
      this.health,
      this.metrics,
      this.operations,
      this.multiSearch);

  factory Client(Configuration config) {
    // ApiCall, DocumentsApiCall, and CollectionsApiCall share the same NodePool.
    final nodePool = NodePool(config),
        apiCall = ApiCall(
          config,
          nodePool,
          RequestCache(
            config.cachedSearchResultsTTL,
          ),
        );

    return Client._(
        config,
        apiCall,
        DocumentsApiCall(config, nodePool),
        Collections(apiCall, CollectionsApiCall(config, nodePool)),
        Aliases(apiCall),
        Keys(apiCall),
        Presets(apiCall),
        Debug(apiCall),
        Stats(apiCall),
        Health(apiCall),
        Metrics(apiCall),
        Operations(apiCall),
        MultiSearch(apiCall));
  }

  /// Perform operation on an individual collection having [collectionName].
  Collection collection(String collectionName) {
    if (!_individualCollections.containsKey(collectionName)) {
      _individualCollections[collectionName] =
          Collection(collectionName, _apiCall, _documentsApiCall);
    }
    return _individualCollections[collectionName]!;
  }

  /// Perform operation on an individual alias having [aliasName].
  Alias alias(String aliasName) {
    if (!_individualAliases.containsKey(aliasName)) {
      _individualAliases[aliasName] = Alias(aliasName, _apiCall);
    }
    return _individualAliases[aliasName]!;
  }

  /// Perform operation on an individual key having [id].
  Key key(int id) {
    if (!_individualKeys.containsKey(id)) {
      _individualKeys[id] = Key(id, _apiCall);
    }
    return _individualKeys[id]!;
  }

  Preset preset(String presetName) {
    if (!_individualPresets.containsKey(presetName)) {
      _individualPresets[presetName] = Preset(presetName, _apiCall);
    }
    return _individualPresets[presetName]!;
  }
}
