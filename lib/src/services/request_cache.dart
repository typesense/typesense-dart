import 'dart:collection';
import 'package:dcache/dcache.dart';

import 'typedefs.dart';

/// Cache store which uses a [HashMap] internally to serve requests.
class RequestCache {
  Cache<String, Map<String, dynamic>> _cachedResponses;
  final Duration timeToUse;
  final int size;
  final Send<Map<String, dynamic>> send;

  RequestCache(this.size, this.timeToUse, this.send) {
    _cachedResponses =
        LruCache<String, Map<String, dynamic>>(storage: InMemoryStorage(size));
  }

  /// Caches the response of the [request], identified by [key]. The cached
  /// response is valid till [cacheTTL].
  Future<Map<String, dynamic>> getResponse(
    String key,
    Request request,
  ) async {
    if (_cachedResponses.containsKey(key)) {
      return Future<Map<String, dynamic>>.value(_cachedResponses.get(key));
    }

    var response = await send(request);
    _cachedResponses.set(key, response);
    return response;
  }
}
