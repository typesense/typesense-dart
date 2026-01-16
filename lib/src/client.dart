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
import 'stopword.dart';
import 'stopwords.dart';
import 'curation_sets.dart';
import 'curation_set.dart';
import 'synonym_sets.dart';
import 'synonym_set.dart';
import 'stemming.dart';

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
  final Stopwords stopwords;
  final CurationSets curationSets;
  final SynonymSets synonymSets;
  final Stemming stemming;
  final _individualCollections = HashMap<String, Collection>(),
      _individualAliases = HashMap<String, Alias>(),
      _individualKeys = HashMap<int, Key>(),
      _individualPresets = HashMap<String, Preset>(),
      _individualStopwords = HashMap<String, Stopword>(),
      _individualCurationSets = HashMap<String, CurationSet>(),
      _individualSynonymSets = HashMap<String, SynonymSet>();

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
      this.multiSearch,
      this.stopwords,
      this.curationSets,
      this.synonymSets,
      this.stemming);

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
        MultiSearch(apiCall),
        Stopwords(apiCall),
        CurationSets(apiCall),
        SynonymSets(apiCall),
        Stemming(apiCall));
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

  /// Perform operation on an individual stopwords set having [stopwordId].
  Stopword stopword(String stopwordId) {
    if (!_individualStopwords.containsKey(stopwordId)) {
      _individualStopwords[stopwordId] = Stopword(stopwordId, _apiCall);
    }
    return _individualStopwords[stopwordId]!;
  }

  /// Perform operation on an individual curation set having [name].
  CurationSet curationSet(String name) {
    if (!_individualCurationSets.containsKey(name)) {
      _individualCurationSets[name] = CurationSet(name, _apiCall);
    }
    return _individualCurationSets[name]!;
  }

  /// Perform operation on an individual synonym set having [name].
  SynonymSet synonymSet(String name) {
    if (!_individualSynonymSets.containsKey(name)) {
      _individualSynonymSets[name] = SynonymSet(name, _apiCall);
    }
    return _individualSynonymSets[name]!;
  }
}
