import 'request_exception.dart';

/// 404 Not Found
class ObjectNotFound extends RequestException {
  ObjectNotFound(String message) : super(message, 404);
}
