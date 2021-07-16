import 'dart:io';

import 'package:typesense/typesense.dart';
import 'package:logging/logging.dart';

import 'util.dart';
import 'collections.dart' as collections;

final log = Logger('Documents');

Future<void> runExample(Client client) async {
  logInfoln(log, '--Documents example--');
  await init(client);
  await create(client);
  await upsert(client);
  await retrieve(client);
  await search(client);
  await delete(client);
  await importDocs(client);
  await exportByQuery(client);
  await update(client);
  await deleteByQuery(client);
  await importJSONL(client);
  await dirtyData(client);
  await export(client);
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
  }
];

final _dirtyDocument = {
  'id': '126',
  'company_name': 030,
  'num_employees': 5215,
  'country': 'USA'
};

Future<void> init(Client client) => collections.create(client);

Future<void> create(Client client) async {
  try {
    logInfoln(log, 'Creating document "124".');
    log.fine(
        await client.collection('companies').documents.create(_documents[0]));

    await writePropagationDelay();
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  }
}

Future<void> upsert(Client client) async {
  try {
    logInfoln(log, 'Upserting document "124".');
    log.fine(
        await client.collection('companies').documents.upsert(_documents[0]));

    await writePropagationDelay();
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  }
}

Future<void> search(Client client) async {
  final searchParameters = {
    'q': 'stark',
    'query_by': 'company_name',
    'filter_by': 'num_employees:>100',
    'sort_by': 'num_employees:desc',
    'group_by': 'country',
    'group_limit': '1'
  };

  try {
    logInfoln(log, 'Searching.');
    log.fine(await client
        .collection('companies')
        .documents
        .search(searchParameters));
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  }
}

Future<void> delete(Client client) async {
  try {
    logInfoln(log, 'Deleting document "124".');
    log.fine(await client.collection('companies').document('124').delete());

    await writePropagationDelay();
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  }
}

Future<void> retrieve(Client client) async {
  try {
    logInfoln(log, 'Retrieving document "124".');
    log.fine(await client.collection('companies').document('124').retrieve());
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  }
}

Future<void> importDocs(
  Client client, [
  String collectionName = 'companies',
  List<Map<String, Object>> documents,
]) async {
  try {
    logInfoln(log, 'Importing documents.');
    log.fine(await client
        .collection(collectionName)
        .documents
        .importDocuments(documents ?? _documents));

    await writePropagationDelay();
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  }
}

Future<void> importJSONL(
  Client client, [
  String JSONL,
]) async {
  try {
    final file = File('assets/documents.jsonl');

    logInfoln(log, 'Importing JSONL documents.');
    log.fine(await client
        .collection('companies')
        .documents
        .importJSONL(JSONL ?? file.readAsStringSync()));

    await writePropagationDelay();
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  }
}

Future<void> update(Client client) async {
  try {
    logInfoln(log, 'Updating document "124".');
    log.fine(await client
        .collection('companies')
        .document('124')
        .update({'num_employees': 5500}));

    await writePropagationDelay();
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  }
}

Future<void> export(Client client) async {
  try {
    logInfoln(log, 'Exporting documents of "companies".');
    log.fine(await client.collection('companies').documents.exportJSONL());
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  }
}

Future<void> exportByQuery(Client client) async {
  try {
    logInfoln(log, 'Exporting only documents having more than 1000 employees.');
    log.fine(await client
        .collection('companies')
        .documents
        .exportJSONL(queryParams: {'filter_by': 'num_employees:>1000'}));

    await writePropagationDelay();
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  }
}

Future<void> deleteByQuery(Client client) async {
  try {
    logInfoln(log, 'Deleting all documents with more than 100 employees.');
    log.fine(await client
        .collection('companies')
        .documents
        .delete({'filter_by': 'num_employees:>100'}));

    await writePropagationDelay();
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  }
}

Future<void> dirtyData(Client client) async {
  try {
    logInfoln(log, 'Creating a document with integer company_name.');
    log.fine(await client
        .collection('companies')
        .documents
        .create(_dirtyDocument, options: {'dirty_values': 'coerce_or_reject'}));

    await writePropagationDelay();
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  }
}
