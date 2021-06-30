import 'package:logging/logging.dart';

/// Helps make sense of the logged messages by spacing them out.
void logInfoln(Logger log, String message) {
  print('\n');
  log.info(message);
}
