import 'package:test/test.dart';

import 'package:typesense/src/search_client.dart';
import 'package:typesense/src/multi_search.dart';
import 'package:typesense/src/collection.dart';

import 'test_utils.dart';

void main() {
  late SearchClient searchClient;

  setUp(() {
    searchClient = SearchClient(ConfigurationFactory.withNearestNode());
  });

  group('SearchClient', () {
    test('has a config field', () {
      expect(
          searchClient.config,
          equals(ConfigurationFactory.withNearestNode(
              sendApiKeyAsQueryParam: true)));
    });
    test('has a multiSearch getter', () {
      expect(searchClient.multiSearch, isA<MultiSearch>());
    });
    test('has a collection method', () {
      expect(searchClient.collection('companies'), isA<Collection>());
    });
  });

  group('SearchClient initialization', () {
    test('sets multiSearch.useTextContentType to true', () {
      expect(searchClient.multiSearch.useTextContentType, isTrue);
    });
    test(
        'sets configuration.sendApiKeyAsQueryParam true if api key is less than 2000 characters, false otherwise',
        () {
      var config = ConfigurationFactory.withNearestNode(
              apiKey: 'abc123', sendApiKeyAsQueryParam: false),
          multiSearch = SearchClient(config);
      expect(multiSearch.config.sendApiKeyAsQueryParam, isTrue);

      config = ConfigurationFactory.withNearestNode(
          apiKey: () {
            var key = 'abc123';
            while (key.length <= 2000) {
              key += key;
            }
            return key;
          }(),
          sendApiKeyAsQueryParam: true);
      multiSearch = SearchClient(config);
      expect(multiSearch.config.sendApiKeyAsQueryParam, isFalse);
    });
  });

  test(
      'SearchClient.collection returns the same document object for a particular documentId',
      () {
    final document = searchClient.collection('companies');
    expect(searchClient.collection('companies').hashCode,
        equals(document.hashCode));
  });
}
