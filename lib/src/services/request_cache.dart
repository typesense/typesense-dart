import 'dart:collection';

import 'package:http/http.dart' as http;

import '../models/node.dart';

/// Cache store which uses a [HashMap] internally to serve requests.
class RequestCache {
  final _cachedResponses = HashMap<int, _Cache>();

  /// Caches the response of the [request], identified by [key]. The cached
  /// response is valid till [cacheTTL].
  Future<Map<String, dynamic>> cache(
    int key,
    Future<Map<String, dynamic>> Function(Future<http.Response> Function(Node))
        send,
    Future<http.Response> Function(Node) request,
    Duration cacheTTL,
  ) async {
    if (_cachedResponses.containsKey(key)) {
      if (_isCacheValid(_cachedResponses[key], cacheTTL)) {
        // Cache entry is still valid, return it
        return Future.value(_cachedResponses[key].data);
      } else {
        // Cache entry has expired, so delete it explicitly
        _cachedResponses.remove(key);
      }
    }

    final response = await send(request);
    _cachedResponses[key] = _Cache(response, DateTime.now());
    return response;
  }

  bool _isCacheValid(_Cache cache, Duration cacheTTL) =>
      DateTime.now().difference(cache.creationTime) < cacheTTL;
}

class _Cache {
  final DateTime creationTime;
  final Map<String, dynamic> data;

  const _Cache(this.data, this.creationTime);
}
