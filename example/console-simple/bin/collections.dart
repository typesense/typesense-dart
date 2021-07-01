import 'package:typesense/typesense.dart';
import 'package:logging/logging.dart';

import 'util.dart';

final log = Logger('Collections');

Future<void> runExample(Client client) async {
  logInfoln(log, '--Collections example--');
  await create(client);
  // Give Typesense cluster a few hundred ms to create collection on all nodes,
  // before reading it right after (eventually consistent)
  await Future.delayed(Duration(milliseconds: 500));
  await retrieve(client);
  await retrieveAll(client);
  await delete(client);
}

Future<void> create(Client client) async {
  final schema = Schema(
    'companies',
    {
      Field('company_name', Type.string),
      Field('num_employees', Type.int32),
      Field('country', Type.string, isFacetable: true),
    },
    defaultSortingField: Field('num_employees', Type.int32),
  );
  try {
    logInfoln(log, 'Creating "companies" collection.');
    log.fine(await client.collections.create(schema));
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);

    if (e.runtimeType == ObjectAlreadyExists) {
      log.info('Collection "companies" already exists, recreating it.');
      await delete(client);
      await create(client);
    }
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  }
}

Future<void> delete(Client client) async {
  try {
    logInfoln(log, 'Deleting "companies" collection.');
    log.fine(await client.collection('companies').delete());
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  }
}

Future<void> retrieve(Client client) async {
  try {
    logInfoln(log, 'Retrieving "companies" collection.');
    log.fine(await client.collection('companies').retrieve());
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  }
}

Future<void> retrieveAll(Client client) async {
  try {
    logInfoln(log, 'Retrieving all collections.');
    log.fine(await client.collections.retrieve());
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  }
}