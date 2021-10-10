import 'package:typesense/typesense.dart';
import 'package:logging/logging.dart';

import 'util.dart';

final log = Logger('Cluster Operations');

Future<void> runExample(Client client) async {
  logInfoln(log, '--Cluster Operations example--');

  await createSnapshot(client);
  await initLeaderElection(client);
  await toggleSlowRequestLog(client);
}

Future<void> createSnapshot(Client client) async {
  try {
    logInfoln(log, 'Creating snapshot.');
    log.fine(await client.operations.createSnapshot('/tmp/dbsnap'));
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}

Future<void> initLeaderElection(Client client) async {
  try {
    logInfoln(log, 'Initiating raft voting process.');
    log.fine(await client.operations.initLeaderElection());
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}

Future<void> toggleSlowRequestLog(Client client) async {
  try {
    logInfoln(log, 'Start logging slow requests.');
    log.fine(await client.operations
        .toggleSlowRequestLog(const Duration(seconds: 2)));
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}
