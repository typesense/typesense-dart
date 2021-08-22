import 'dart:convert';

import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import 'package:typesense/src/services/request_cache.dart';
import 'package:typesense/src/models/node.dart';
import 'package:typesense/src/services/typedefs.dart';

import '../test_utils.dart';

class MockResponse extends Mock implements http.Response {}

Future<Map<String, dynamic>> send(request) async {
  final response = await request(
    Node(
      protocol: protocol,
      host: host,
      path: pathToService,
    ),
  );
  return json.decode(response.body);
}

void main() {
  RequestCache requestCache;
  MockResponse mockResponse;
  int requestNumber;
  Request request;

  setUp(() {
    requestCache = RequestCache(5, Duration(seconds: 1));

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
    request = (node) => Future.value(mockResponse);
  });
  group('RequestCache', () {
    test('has a size field', () {
      expect(requestCache.size, equals(5));
    });
    test('has a timeToUse field', () {
      expect(requestCache.timeToUse, equals(Duration(seconds: 1)));
    });
    test('has a getResponse method', () async {
      expect(
          await requestCache.getResponse(
            '/value',
            request,
            send
          ),
          equals({'value': 'initial'}));
    });
  });

  group('RequestCache.getResponse', () {
    test('returns cached response', () async {
      expect(
          await requestCache.getResponse(
            '/value',
            request,
            send
          ),
          equals({'value': 'initial'}));
      expect(
          await requestCache.getResponse(
            '/value',
            request,
            send
          ),
          equals({'value': 'initial'}));
    });
    test('refreshes the cache after timeToUse duration', () async {
      expect(
          await requestCache.getResponse(
            '/value',
            request,
            send
          ),
          equals({'value': 'initial'}));
      expect(
          await requestCache.getResponse(
            '/value',
            request,
            send
          ),
          equals({'value': 'initial'}));

      await Future.delayed(Duration(seconds: 1, milliseconds: 100));
      expect(
          await requestCache.getResponse(
            '/value',
            request,
            send
          ),
          equals({'value': 'updated'}));
    });
    test('evicts the least recently used response', () async {
      requestCache = RequestCache(5, Duration(seconds: 10));

      final mockResponses = List.generate(6, (_) => MockResponse()),
          callCounters = List.filled(6, 0);
      var i = 0;

      for (final mockResponse in mockResponses) {
        when(mockResponse.body).thenAnswer((invocation) {
          return json.encode({'$i': '${++callCounters[i]}'});
        });
      }

      // Cache size is 5, filling up the cache with different responses.
      for (; i < 5; i++) {
        expect(
            await requestCache.getResponse(
              i.toString(),
              (node) => Future.value(mockResponses[i]),
              send
            ),
            equals({'$i': '1'}));
      }

      // The responses should still be 1 since they're cached.
      i = 0;
      for (; i < 5; i++) {
        expect(
            await requestCache.getResponse(
              i.toString(),
              (node) => Future.value(mockResponses[i]),
              send
            ),
            equals({'$i': '1'}));
      }

      // Least recently used response at this moment should be index 0 and hence
      // should be evicted by the following call.
      expect(
          await requestCache.getResponse(
            5.toString(),
            (node) => Future.value(mockResponses[5]),
            send
          ),
          equals({'5': '1'}));

      // The responses should now be 2 since each response gets evicted before
      // being called again.
      i = 0;
      for (; i < 5; i++) {
        expect(
            await requestCache.getResponse(
              i.toString(),
              (node) => Future.value(mockResponses[i]),
              send
            ),
            equals({'$i': '2'}));
      }
    });
  });
}
