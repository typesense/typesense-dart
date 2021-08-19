import 'dart:convert';

import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import 'package:typesense/src/services/request_cache.dart';
import 'package:typesense/src/models/node.dart';
import 'package:typesense/src/services/typedefs.dart';

import '../test_utils.dart';

class MockResponse extends Mock implements http.Response {}

void main() {
  RequestCache requestCache;
  MockResponse mockResponse;
  int requestNumber;
  Send<Map<String, dynamic>> send;
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

    send = (request) async {
      final response = await request(
          Node(protocol: protocol, host: host, path: pathToService));
      return json.decode(response.body);
    };
    request = (node) => Future.value(mockResponse);
  });
  group('RequestCache', () {
    final requestCache = RequestCache(5, Duration(seconds: 1));

    test('has a size field', () {
      expect(requestCache.size, equals(5));
    });
    test('has a timeToUse field', () {
      expect(requestCache.timeToUse, equals(Duration(seconds: 1)));
    });
    test('has a getResponse method', () async {
      expect(
          await requestCache.getResponse(
            '/value'.hashCode,
            send,
            request,
          ),
          equals({'value': 'initial'}));
    });
  });

  group('RequestCache.getResponse', () {
    test('returns cached response', () async {
      expect(
          await requestCache.getResponse(
            '/value'.hashCode,
            send,
            request,
          ),
          equals({'value': 'initial'}));
      expect(
          await requestCache.getResponse(
            '/value'.hashCode,
            send,
            request,
          ),
          equals({'value': 'initial'}));
    });
    test('refreshes the cache after timeToUse duration', () async {
      expect(
          await requestCache.getResponse(
            '/value'.hashCode,
            send,
            request,
          ),
          equals({'value': 'initial'}));
      expect(
          await requestCache.getResponse(
            '/value'.hashCode,
            send,
            request,
          ),
          equals({'value': 'initial'}));

      await Future.delayed(Duration(seconds: 1, milliseconds: 100));
      expect(
          await requestCache.getResponse(
            '/value'.hashCode,
            send,
            request,
          ),
          equals({'value': 'updated'}));
    });
  });
}
