import 'dart:collection';
import 'package:dcache/dcache.dart';

import 'typedefs.dart';

/// Cache store which uses a [HashMap] internally to serve requests.
class RequestCache {
  Cache<String, Map<String, dynamic>> _cachedResponses;
  final _cachedTimestamp = HashMap<String, DateTime>();
  final Duration timeToUse;
  final int size;

  RequestCache(this.size, this.timeToUse) {
    _cachedResponses = LruCache<String, Map<String, dynamic>>(storage: InMemoryStorage(size));
  }

  /// Caches the response of the [request], identified by [key]. The cached
  /// response is valid till [cacheTTL].
  Future<Map<String, dynamic>> getResponse(
    String key,
    Request request,
    Send<Map<String, dynamic>> send
  ) async {
    if (_cachedResponses.containsKey(key) && _isCacheValid(key)) {
      return Future<Map<String, dynamic>>.value(_cachedResponses.get(key));
    }

    var response = await send(request);
    _cachedResponses.set(key, response);
    _cachedTimestamp[key] = DateTime.now();
    return response;
  }

  bool _isCacheValid(String key) =>
      DateTime.now().difference(_cachedTimestamp[key]) < timeToUse;
}
