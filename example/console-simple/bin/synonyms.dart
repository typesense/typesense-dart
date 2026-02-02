import 'package:typesense/typesense.dart';
import 'package:logging/logging.dart';

import 'util.dart';
import 'collections.dart' as collections;
import 'documents.dart' as documents;

final log = Logger('Synonym');

Future<void> runExample(Client client) async {
  logInfoln(log, '--Synonym example--');
  await init(client);

  await createMultiWay(client);
  // Searching for Heinz should now return Doofenshmirtz Inc.
  await search(client, 'Heinz');
  await retrieveAll(client);

  await createOneWay(client);
  // Searching for Evil should now return Doofenshmirtz Inc.
  await search(client, 'Evil');
  // But searching for Heinz, should not return any results, since this is a
  // one-way synonym.
  await search(client, 'Heinz');

  await retrieve(client);
  await delete(client);
  await collections.delete(client);
}

final _documents = [
  {
    'id': '124',
    'company_name': 'Stark Industries',
    'num_employees': 5215,
    'country': 'USA'
  },
  {
    'id': '125',
    'company_name': 'Acme Corp',
    'num_employees': 1002,
    'country': 'France'
  },
  {
    'id': '127',
    'company_name': 'Stark Corp',
    'num_employees': 1031,
    'country': 'USA'
  },
  {
    'id': '126',
    'company_name': 'Doofenshmirtz Inc',
    'num_employees': 2,
    'country': 'Tri-State Area'
  }
];

Future<void> init(Client client) async {
  await documents.init(client);
  await documents.importDocs(client, 'companies', _documents);
}

Future<void> createMultiWay(Client client) async {
  try {
    logInfoln(log, 'Creating multi-way synonym "synonyms-doofenshmirtz".');
    final response = await client.synonymSet('set_name').upsert(
          SynonymSetCreateSchema(
            items: [
              SynonymItemSchema(
                  id: 'synonyms-doofenshmirtz',
                  synonyms: ['Doofenshmirtz', 'Heinz', 'Evil'])
            ],
          ),
        );
    log.fine(response.toJson());
    await writePropagationDelay();

    logInfoln(log, 'Adding "set_name" to "companies" collection.');
    final updateResponse = await client.collection('companies').update(
          UpdateSchema(
            {},
            synonymSets: {"set_name"},
          ),
        );
    log.fine(updateResponse);
    await writePropagationDelay();
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}

Future<void> search(Client client, String query) async {
  try {
    logInfoln(log, 'Searching for $query.');
    log.fine(
      await client
          .collection('companies')
          .documents
          .search({'q': query, 'query_by': 'company_name'}),
    );
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}

Future<void> createOneWay(Client client) async {
  try {
    logInfoln(log, 'Upserting synonym "synonyms-doofenshmirtz" to be one-way.');
    final response = await client.synonymSet('set_name').upsert(
          SynonymSetCreateSchema(
            items: [
              SynonymItemSchema(
                id: 'synonyms-doofenshmirtz',
                synonyms: ['Doofenshmirtz', 'Heinz'],
                root: 'Evil',
              )
            ],
          ),
        );
    log.fine(response.toJson());

    await writePropagationDelay();
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}

Future<void> retrieveAll(Client client) async {
  try {
    logInfoln(log, 'Retrieving all synonyms of `set_name` synonym set.');
    final response = await client.synonymSet('set_name').listItems();
    for (final item in response) {
      log.fine(item.toJson());
    }
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}

Future<void> retrieve(Client client) async {
  try {
    logInfoln(log, 'Retrieving synonym "synonyms-doofenshmirtz".');
    final response =
        await client.synonymSet('set_name').getItem('synonyms-doofenshmirtz');
    log.fine(response.toJson());
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}

Future<void> delete(Client client) async {
  try {
    logInfoln(log, 'Deleting synonym "synonyms-doofenshmirtz".');
    final response = await client
        .synonymSet('set_name')
        .deleteItem('synonyms-doofenshmirtz');
    log.fine(response.toJson());

    await writePropagationDelay();
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}
