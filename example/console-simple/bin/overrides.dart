import 'package:typesense/typesense.dart';
import 'package:logging/logging.dart';

import 'util.dart';
import 'collections.dart' as collections;
import 'documents.dart' as documents;

final log = Logger('Overrides');

Future<void> runExample(Client client) async {
  logInfoln(log, '--Overrides example--');
  await init(client);
  await create(client);
  await retrieveAll(client);
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

Future<void> create(Client client) async {
  try {
    logInfoln(log, 'Creating override.');
    log.fine(
      await client.collection('companies').overrides.upsert(
        'promote-doofenshmirtz',
        {
          'rule': {'query': 'doofen', 'match': 'exact'},
          'includes': [
            {'id': '126', 'position': 1}
          ]
        },
      ),
    );

    await writePropagationDelay();
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  }
}

Future<void> retrieveAll(Client client) async {
  try {
    logInfoln(log, 'Retrieving all overrides.');
    log.fine(await client.collection('companies').overrides.retrieve());
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  }
}

Future<void> retrieve(Client client) async {
  try {
    logInfoln(log, 'Retrieving override "promote-doofenshmirtz".');
    log.fine(await client
        .collection('companies')
        .override('promote-doofenshmirtz')
        .retrieve());
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  }
}

Future<void> delete(Client client) async {
  try {
    logInfoln(log, 'Deleting override "promote-doofenshmirtz".');
    log.fine(await client
        .collection('companies')
        .override('promote-doofenshmirtz')
        .delete());

    await writePropagationDelay();
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  }
}
