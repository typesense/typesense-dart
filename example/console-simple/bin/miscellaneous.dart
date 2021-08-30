import 'package:typesense/typesense.dart';
import 'package:logging/logging.dart';

import 'util.dart';

final log = Logger('Miscellaneous');

Future<void> runExample(Client client) async {
  logInfoln(log, '--Miscellaneous examples--');

  await metrics(client);
  await health(client);
  await stats(client);
}

Future<void> metrics(Client client) async {
  try {
    logInfoln(log, 'Retrieving node metrics.');
    log.fine(await client.metrics.retrieve());
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}

Future<void> health(Client client) async {
  try {
    logInfoln(log, 'Retrieving node health status.');
    log.fine(await client.health.retrieve());
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}

Future<void> stats(Client client) async {
  try {
    logInfoln(log, 'Retrieving api stats.');
    log.fine(await client.stats.retrieve());
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}
