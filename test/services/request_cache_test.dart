import 'dart:convert';

import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

import 'package:typesense/src/services/request_cache.dart';
import 'package:typesense/src/models/models.dart';

import '../test_utils.dart';
import 'request_cache_test.mocks.dart';

@GenerateMocks([http.Response])
void main() {
  group('RequestCache', () {
    late RequestCache requestCache;
    late MockResponse mockResponse;
    late int requestNumber;
    late Future<Map<String, dynamic>> Function(
        Future<http.Response> Function(Node)) send;
    late Future<http.Response> Function(Node) request;
    final cacheTTL = Duration(seconds: 1);

    setUp(() {
      requestCache = RequestCache(cacheTTL);
      mockResponse = MockResponse();
      requestNumber = 1;

      when(mockResponse.body).thenAnswer((invocation) {
        switch (requestNumber++) {
          case 1:
            return json.encode({'value': 'initial'});

          case 2:
            return json.encode({'value': 'updated'});

          default:
            return json.encode({});
        }
      });

      send = (request) async {
        final response =
            await request(Node(protocol, host, path: pathToService));
        return json.decode(response.body);
      };
      request = (node) => Future.value(mockResponse);
    });

    test('caches the response', () async {
      expect(
          await requestCache.cache(
            '/value',
            send,
            request,
          ),
          equals({'value': 'initial'}));
      expect(
          await requestCache.cache(
            '/value',
            send,
            request,
          ),
          equals({'value': 'initial'}));
    });
    test('refreshes the cache after TTL duration', () async {
      expect(
          await requestCache.cache(
            '/value',
            send,
            request,
          ),
          equals({'value': 'initial'}));
      expect(
          await requestCache.cache(
            '/value',
            send,
            request,
          ),
          equals({'value': 'initial'}));

      await Future.delayed(Duration(seconds: 1, milliseconds: 100));
      expect(
          await requestCache.cache(
            '/value',
            send,
            request,
          ),
          equals({'value': 'updated'}));
    });
  });
}
