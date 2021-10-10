import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:typesense/src/multi_search.dart';

import 'test_utils.mocks.dart';

void main() {
  late MultiSearch multiSearch;
  late MockApiCall mock;

  final map = {
    "results": [
      {
        "facet_counts": [],
        "found": 1,
        "hits": [
          {
            "document": {
              "name": "Blue shoe",
              "brand": "Adidas",
              "id": "126",
              "price": 50
            },
            "highlights": [
              {
                "field": "name",
                "matched_tokens": ["shoe"],
                "snippet": "Blue <mark>shoe</mark>"
              }
            ],
            "text_match": 130816
          }
        ],
        "out_of": 10,
        "page": 1,
        "request_params": {"per_page": 10, "q": "shoe"},
        "search_time_ms": 1
      },
      {
        "facet_counts": [],
        "found": 1,
        "hits": [
          {
            "document": {
              "name": "Nike shoes",
              "brand": "Nike",
              "id": "391",
              "price": 60
            },
            "highlights": [
              {
                "field": "name",
                "matched_tokens": ["Nike"],
                "snippet": "<mark>Nike</mark>shoes"
              }
            ],
            "text_match": 144112
          }
        ],
        "out_of": 5,
        "page": 1,
        "request_params": {"per_page": 10, "q": "Nike"},
        "search_time_ms": 1
      },
    ]
  };

  setUp(() {
    mock = MockApiCall();
    multiSearch = MultiSearch(mock);
  });

  group('MultiSearch', () {
    test('has a resourcepath', () {
      expect(MultiSearch.resourcepath, equals('/multi_search'));
    });
    test('perform() calls ApiCall.post() with shouldCacheResult true',
        () async {
      when(
        mock.post(
          '/multi_search',
          bodyParameters: {
            'searches': [
              {
                'collection': 'products',
                'q': 'shoe',
                'filter_by': 'price:=[50..120]',
              },
              {
                'collection': 'brands',
                'q': 'Nike',
              }
            ]
          },
          queryParams: {
            'query_by': 'name',
          },
          shouldCacheResult: true,
          additionalHeaders: {},
        ),
      ).thenAnswer((realInvocation) => Future.value(map));
      expect(
          await multiSearch.perform(
            {
              'searches': [
                {
                  'collection': 'products',
                  'q': 'shoe',
                  'filter_by': 'price:=[50..120]',
                },
                {
                  'collection': 'brands',
                  'q': 'Nike',
                }
              ]
            },
            queryParams: {
              'query_by': 'name',
            },
          ),
          equals(map));
    });
  });

  test(
      'MultiSearch when initialized with useTextContentType true sets CONTENT_TYPE to "text/plain"',
      () async {
    final multiSearch = MultiSearch(mock, useTextContentType: true);
    when(
      mock.post(
        '/multi_search',
        bodyParameters: {
          'searches': [
            {
              'collection': 'products',
              'q': 'shoe',
              'filter_by': 'price:=[50..120]',
            },
            {
              'collection': 'brands',
              'q': 'Nike',
            }
          ]
        },
        queryParams: {
          'query_by': 'name',
        },
        additionalHeaders: {'Content-Type': 'text/plain'},
        shouldCacheResult: true,
      ),
    ).thenAnswer((realInvocation) => Future.value(map));
    expect(
        await multiSearch.perform(
          {
            'searches': [
              {
                'collection': 'products',
                'q': 'shoe',
                'filter_by': 'price:=[50..120]',
              },
              {
                'collection': 'brands',
                'q': 'Nike',
              }
            ]
          },
          queryParams: {
            'query_by': 'name',
          },
        ),
        equals(map));
  });
}
