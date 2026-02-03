import 'package:typesense/typesense.dart';
import 'package:logging/logging.dart';

import 'collections.dart' as collections;
import 'documents.dart' as documents;
import 'util.dart';

final log = Logger('Curations');

Future<void> runExample(Client client) async {
  logInfoln(log, '--Curations example--');
  await init(client);
  await create(client);
  await retrieveAll(client);
  await retrieveSet(client);
  await retrieveItem(client);
  await deleteItem(client);
  await deleteSet(client);
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
    logInfoln(log, 'Creating curation set "curate_companies".');
    final curationSet = CurationSetUpsertSchema(
      items: [
        CurationObjectSchema(
          id: 'promote-doofenshmirtz',
          rule: CurationRuleSchema(query: 'doofen', match: 'exact'),
          includes: [
            CurationIncludeSchema(id: '126', position: 1),
          ],
        ),
      ],
    );

    final response =
        await client.curationSet('curate_companies').upsert(curationSet);
    log.fine({
      'name': response.name,
      'items': response.items.map((item) => item.toJson()).toList(),
    });
    await writePropagationDelay();

    logInfoln(log, 'Adding "curate_companies" to "companies" collection.');
    final updateResponse = await client.collection('companies').update(
          UpdateSchema(
            {},
            curationSets: {'curate_companies'},
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

Future<void> retrieveAll(Client client) async {
  try {
    logInfoln(log, 'Retrieving all curation sets.');
    final response = await client.curationSets.retrieve();
    for (final set in response) {
      log.fine({
        'name': set.name,
        'items': set.items.map((item) => item.toJson()).toList(),
      });
    }
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}

Future<void> retrieveSet(Client client) async {
  try {
    logInfoln(log, 'Retrieving curation set "curate_companies".');
    final response = await client.curationSet('curate_companies').retrieve();
    log.fine({
      'name': response.name,
      'items': response.items.map((item) => item.toJson()).toList(),
    });
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}

Future<void> retrieveItem(Client client) async {
  try {
    logInfoln(log, 'Retrieving curation item "promote-doofenshmirtz".');
    final response = await client
        .curationSet('curate_companies')
        .getItem('promote-doofenshmirtz');
    log.fine(response.toJson());
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}

Future<void> deleteItem(Client client) async {
  try {
    logInfoln(log, 'Deleting curation item "promote-doofenshmirtz".');
    final response = await client
        .curationSet('curate_companies')
        .deleteItem('promote-doofenshmirtz');
    log.fine({'id': response.id});
    await writePropagationDelay();
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}

Future<void> deleteSet(Client client) async {
  try {
    logInfoln(log, 'Deleting curation set "curate_companies".');
    final response = await client.curationSet('curate_companies').delete();
    log.fine({'name': response.name});
    await writePropagationDelay();
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}
