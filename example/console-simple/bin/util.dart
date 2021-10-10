import 'package:logging/logging.dart';

/// Helps make sense of the logged messages by spacing them out.
void logInfoln(Logger log, String message) {
  // ignore: avoid_print
  print('');
  log.info(message);
}

/// Let the write be propagated to all the nodes.
///
/// Only relevant in a situation where retrieving operation immediately follows
/// creation operation, which usually isn't common.
Future<void> writePropagationDelay() =>
    Future.delayed(const Duration(milliseconds: 500));
