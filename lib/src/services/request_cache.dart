import 'dart:collection';
import 'package:dcache/dcache.dart';
import 'package:http/http.dart';

import 'typedefs.dart' as defs;

/// Cache store which uses a [HashMap] internally to serve requests.
class RequestCache {
  Cache _cachedResponses;
  final Duration timeToUse;
  final int size;
  final defs.Send<Map<String, dynamic>> send;

  RequestCache(this.size, this.timeToUse, this.send) {
    _cachedResponses = LruCache<String, Response>(storage: InMemoryStorage(size));
  }

  // TODO(harisarang): rename this function to getResponse
  /// Caches the response of the [request], identified by [key]. The cached
  /// response is valid till [cacheTTL].
  Future<Map<String, dynamic>> getResponse(
    String key,
    defs.Request request,
  ) async {
    if (_cachedResponses.containsKey(key)) {
      return send(_cachedResponses.get(key));
    }
    
    var response = await send(request);
    _cachedResponses.set(key, response);
    return response;
  }
}
