import 'package:test/test.dart';

import 'package:typesense/src/client.dart';
import 'package:typesense/src/collections.dart';
import 'package:typesense/src/collection.dart';
import 'package:typesense/src/aliases.dart';
import 'package:typesense/src/alias.dart';
import 'package:typesense/src/keys.dart';
import 'package:typesense/src/key.dart';
import 'package:typesense/src/debug.dart';
import 'package:typesense/src/metrics.dart';
import 'package:typesense/src/health.dart';
import 'package:typesense/src/operations.dart';
import 'package:typesense/src/multi_search.dart';

import 'test_utils.dart';

void main() {
  Client client;

  setUp(() {
    client = Client(ConfigurationFactory.withNearestNode());
  });

  group('Client', () {
    test('has a config field', () {
      expect(client.config, equals(ConfigurationFactory.withNearestNode()));
    });
    test('has a collections field', () {
      expect(client.collections, isA<Collections>());
    });
    test('has an aliases field', () {
      expect(client.aliases, isA<Aliases>());
    });
    test('has a keys field', () {
      expect(client.keys, isA<Keys>());
    });
    test('has a debug field', () {
      expect(client.debug, isA<Debug>());
    });
    test('has a metrics field', () {
      expect(client.metrics, isA<Metrics>());
    });
    test('has a health field', () {
      expect(client.health, isA<Health>());
    });
    test('has a operations field', () {
      expect(client.operations, isA<Operations>());
    });
    test('has a multiSearch field', () {
      expect(client.multiSearch, isA<MultiSearch>());
    });
    test('has a collection method', () {
      expect(client.collection('companies'), isA<Collection>());
    });
    test('has a alias method', () {
      expect(client.alias('companies'), isA<Alias>());
    });
    test('has a key method', () {
      expect(client.key(1), isA<Key>());
    });
  });

  test(
      'Client.collection returns the same collection object for a particular collectionName',
      () {
    final collection = client.collection('companies');
    expect(
        client.collection('companies').hashCode, equals(collection.hashCode));
  });

  test('Client.alias returns the same alias object for a particular aliasName',
      () {
    final alias = client.alias('companies');
    expect(client.alias('companies').hashCode, equals(alias.hashCode));
  });

  test('Client.key returns the same key object for a particular id', () {
    final key = client.key(1);
    expect(client.key(1).hashCode, equals(key.hashCode));
  });
}
