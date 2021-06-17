import 'package:typesense/typesense.dart';
import 'package:logging/logging.dart';

final log = Logger('Collections');

Future<void> runExample(Client client) async {
  await _create(client);
  // Give Typesense cluster a few hundred ms to create collection on all nodes,
  // before reading it right after (eventually consistent)
  await Future.delayed(Duration(milliseconds: 500));
  await _retrieve(client);
  await _retrieveAll(client);
  await _delete(client);
}

Future<void> _create(Client client) async {
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
    log.info('Creating "companies" collection.');
    log.fine(await client.collections.create(schema));
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);

    if (e.runtimeType == ObjectAlreadyExists) {
      log.info('Collection "companies" already exists, recreating it.');
      await _delete(client);
      await _create(client);
    }
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  }
}

Future<void> _delete(Client client) async {
  try {
    log.info('Deleting "companies" collection.');
    log.fine(await client.collection('companies').delete());
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  }
}

Future<void> _retrieve(Client client) async {
  try {
    log.info('Retrieving "companies" collection.');
    log.fine(await client.collection('companies').retrieve());
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  }
}

Future<void> _retrieveAll(Client client) async {
  try {
    log.info('Retrieving all collections.');
    log.fine(await client.collections.retrieve());
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  }
}
