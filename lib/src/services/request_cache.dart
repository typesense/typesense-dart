import 'dart:collection';

import 'package:http/http.dart' as http;

import '../models/models.dart';

/// Cache store which uses a Map internally to serve requests.
class RequestCache {
  final Duration cacheTTL;
  final _cachedResponses = HashMap<String, _CachedResult>();

  RequestCache(this.cacheTTL);

  /// Caches the response of the [request], identified by [key]. The cached
  /// response is valid till [cacheTTL] after it's creation.
  Future<Map<String, dynamic>> cache(
    String key,
    Future<Map<String, dynamic>> Function(Future<http.Response> Function(Node))
        send,
    Future<http.Response> Function(Node) request,
  ) async {
    if (_cachedResponses.containsKey(key)) {
      if (_isCacheValid(_cachedResponses[key]!)) {
        // Cache entry is still valid, return it
        return Future.value(_cachedResponses[key]!.data);
      } else {
        // Cache entry has expired, so delete it explicitly
        _cachedResponses.remove(key);
      }
    }

    final response = await send(request);
    _cachedResponses[key] =
        _CachedResult(response, DateTime.now().add(cacheTTL));
    return response;
  }

  bool _isCacheValid(_CachedResult cache) =>
      cache.validTill.difference(DateTime.now()) > Duration.zero;
}

class _CachedResult {
  final Map<String, dynamic> data;
  final DateTime validTill;

  const _CachedResult(this.data, this.validTill);
}
