import 'request_exception.dart';

/// 409 Conflict
class ObjectAlreadyExists extends RequestException {
  ObjectAlreadyExists(String message) : super(message, 409);
}
