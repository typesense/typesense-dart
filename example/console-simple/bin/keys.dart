import 'package:typesense/typesense.dart';
import 'package:logging/logging.dart';

import 'util.dart';
import 'collections.dart' as collections;
import 'documents.dart' as documents;

final log = Logger('Keys');

Future<void> runExample(Client client) async {
  logInfoln(log, '--Keys example--');
  await init(client);
  // Give Typesense cluster a few hundred ms to create collection on all nodes,
  // before reading it right after (eventually consistent).
  await Future.delayed(Duration(milliseconds: 500));

  final response = await createUnscopedSearchOnlyApiKey(client),

      // Save the key returned, since this will be the only time the full API
      // Key is returned, for security purposes.
      unscopedSearchOnlyApiKey = response['value'];
  await retrieveMetadata(client, response['id']);
  await retrieveAllMetadata(client);

  final scopedSearchOnlyApiKey =
          await createScopedSearchOnlyApiKey(client, unscopedSearchOnlyApiKey),

      // Swap out the unscoped key.
      scopedClient = Client(Configuration.updateParameters(client.config,
          apiKey: scopedSearchOnlyApiKey));
  await searchInScope(scopedClient);
  await searchOutOfScope(scopedClient);

  await delete(client, response['id']);
  await collections.delete(client, 'users');
}

final _schema = Schema(
  'users',
  {
    Field('company_id', Type.int32),
    Field('user_name', Type.string),
    Field('login_count', Type.int32),
    Field('country', Type.string, isFacetable: true),
  },
  defaultSortingField: Field('company_id', Type.int32),
);

final _documents = [
  {
    'company_id': 124,
    'user_name': 'Hilary Bradford',
    'login_count': 10,
    'country': 'USA'
  },
  {
    'company_id': 124,
    'user_name': 'Nile Carty',
    'login_count': 100,
    'country': 'USA'
  },
  {
    'company_id': 126,
    'user_name': 'Tahlia Maxwell',
    'login_count': 1,
    'country': 'France'
  },
  {
    'company_id': 126,
    'user_name': 'Karl Roy',
    'login_count': 2,
    'country': 'Germany'
  }
];

Future<void> init(Client client) async {
  await collections.create(client, _schema);
  await documents.importDocs(client, 'users', _documents);
}

Future<Map<String, dynamic>> createUnscopedSearchOnlyApiKey(
    Client client) async {
  Map<String, dynamic> response;
  try {
    logInfoln(log, 'Creating unscoped search-only api key.');
    response = await client.keys.create(
      {
        'description': 'Search-only key.',
        'actions': ['documents:search'],
        'collections': ['*']
      },
    );
    log.fine(response);
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  }
  return response;
}

Future<void> retrieveAllMetadata(Client client) async {
  try {
    logInfoln(log, 'Retrieving metadata of all keys.');
    log.fine(await client.keys.retrieve());
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  }
}

Future<void> retrieveMetadata(Client client, int id) async {
  try {
    logInfoln(log, 'Retrieving metadata of api key "$id".');
    log.fine(await client.key(id).retrieve());
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  }
}

Future<String> createScopedSearchOnlyApiKey(
    Client client, String unscopedSearchOnlyApiKey) async {
  String key;
  try {
    logInfoln(log, 'Creating scoped search-only api key.');
    key = client.keys.generateScopedSearchKey(
      unscopedSearchOnlyApiKey,
      {'filter_by': 'company_id:124'},
    );
    log.fine(key);
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  }
  return key;
}

Future<void> searchInScope(Client scopedClient) async {
  try {
    logInfoln(
        log, 'Searching for data that is "in scope" of the scoped client.');
    log.fine(await scopedClient
        .collection('users')
        .documents
        .search({'q': 'Hilary', 'query_by': 'user_name'}));
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  }
}

Future<void> searchOutOfScope(Client scopedClient) async {
  try {
    logInfoln(
        log, 'Searching for data that is "out of scope" of the scoped client.');
    log.fine(await scopedClient
        .collection('users')
        .documents
        .search({'q': 'Maxwell', 'query_by': 'user_name'}));
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  }
}

Future<void> delete(Client client, int id) async {
  try {
    logInfoln(log, 'Deleting key "$id".');
    log.fine(await client.key(id).delete());
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  }
}
