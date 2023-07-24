import 'package:typesense/typesense.dart';
import 'package:logging/logging.dart';

import 'util.dart';
import 'collections.dart' as collections;
import 'documents.dart' as documents;

final log = Logger('Presets');

Future<void> runExample(Client client) async {
  logInfoln(log, '--Presets example--');
  await init(client);
  await create(client);
  await search(client);
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
    logInfoln(log, 'Creating preset "country_filter_preset".');
    log.fine(
      await client.presets.upsert('country_filter_preset', {
        'value': {
          'filter_by': 'country:=USA',
        }
      }),
    );

    await writePropagationDelay();
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}

Future<void> search(Client client) async {
  try {
    logInfoln(log, 'Simple search.');
    log.fine(
      await client.collection('companies').documents.search(
        {
          'q': 'Corp',
          'query_by': 'company_name',
        },
      ),
    );

    logInfoln(log, 'Search with filter_by.');
    log.fine(
      await client.collection('companies').documents.search(
        {
          'q': 'Corp',
          'query_by': 'company_name',
          'filter_by': 'country:=USA',
        },
      ),
    );

    logInfoln(log, 'Search using preset.');
    log.fine(
      await client.collection('companies').documents.search(
        {
          'q': 'Corp',
          'query_by': 'company_name',
          'preset': 'country_filter_preset',
        },
      ),
    );
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}

Future<void> retrieveAll(Client client) async {
  try {
    logInfoln(log, 'Retrieving all presets.');
    log.fine(await client.presets.retrieve());
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}

Future<void> retrieve(Client client) async {
  try {
    logInfoln(log, 'Retrieving preset "country_filter_preset".');
    log.fine(await client.preset('country_filter_preset').retrieve());
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}

Future<void> delete(Client client) async {
  try {
    logInfoln(log, 'Deleting preset "country_filter_preset".');
    log.fine(await client.preset('country_filter_preset').delete());

    await writePropagationDelay();
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}
