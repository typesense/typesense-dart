import 'package:typesense/typesense.dart';
import 'package:logging/logging.dart';

import 'util.dart';

final log = Logger('Collections');

Future<void> runExample(Client client) async {
  logInfoln(log, '--Collections example--');
  await create(client);
  await retrieve(client);
  await retrieveAll(client);
  await delete(client);
}

Future<void> create(Client client, [CreateSchema? schema]) async {
  final _schema = CreateSchema(
        'companies',
        {
          CreateField('company_name', type: Type.string),
          CreateField('num_employees', type: Type.int32),
          CreateField('country', type: Type.string, isFacetable: true),
        },
        defaultSortingField: CreateField('num_employees', type: Type.int32),
      ),
      collectionName = schema == null ? 'companies' : schema.name;

  try {
    logInfoln(log, 'Creating "$collectionName" collection.');
    log.fine(await client.collections.create(schema ?? _schema));

    await writePropagationDelay();
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);

    if (e.runtimeType == ObjectAlreadyExists) {
      log.info('Collection "$collectionName" already exists, recreating it.');
      await delete(client, collectionName);
      await create(client, schema);
    }
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}

Future<void> delete(Client client,
    [String collectionName = 'companies']) async {
  try {
    logInfoln(log, 'Deleting "$collectionName" collection.');
    log.fine(await client.collection(collectionName).delete());

    await writePropagationDelay();
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}

Future<void> retrieve(Client client) async {
  try {
    logInfoln(log, 'Retrieving "companies" collection.');
    log.fine(await client.collection('companies').retrieve());
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}

Future<void> retrieveAll(Client client) async {
  try {
    logInfoln(log, 'Retrieving all collections.');
    log.fine(await client.collections.retrieve());
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}
