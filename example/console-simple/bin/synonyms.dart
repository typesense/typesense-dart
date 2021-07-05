import 'package:typesense/typesense.dart';
import 'package:logging/logging.dart';

import 'util.dart';
import 'collections.dart' as collections;
import 'documents.dart' as documents;

final log = Logger('Synonym');

Future<void> runExample(Client client) async {
  logInfoln(log, '--Synonym example--');
  await init(client);
  // Give Typesense cluster a few hundred ms to create collection on all nodes,
  // before reading it right after (eventually consistent).
  await Future.delayed(Duration(milliseconds: 500));

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
    log.fine(
      await client.collection('companies').synonyms.upsert(
        'synonyms-doofenshmirtz',
        {
          'synonyms': ['Doofenshmirtz', 'Heinz', 'Evil']
        },
      ),
    );
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
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
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  }
}

Future<void> createOneWay(Client client) async {
  try {
    logInfoln(log, 'Upserting synonym "synonyms-doofenshmirtz" to be one-way.');
    log.fine(
      await client.collection('companies').synonyms.upsert(
        'synonyms-doofenshmirtz',
        {
          'root': 'Evil',
          'synonyms': ['Doofenshmirtz', 'Heinz']
        },
      ),
    );
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  }
}

Future<void> retrieveAll(Client client) async {
  try {
    logInfoln(log, 'Retrieving all synonyms.');
    log.fine(await client.collection('companies').synonyms.retrieve());
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  }
}

Future<void> retrieve(Client client) async {
  try {
    logInfoln(log, 'Retrieving synonym "synonyms-doofenshmirtz".');
    log.fine(await client
        .collection('companies')
        .synonym('synonyms-doofenshmirtz')
        .retrieve());
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  }
}

Future<void> delete(Client client) async {
  try {
    logInfoln(log, 'Deleting synonym "synonyms-doofenshmirtz".');
    log.fine(await client
        .collection('companies')
        .synonym('synonyms-doofenshmirtz')
        .delete());
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  }
}
