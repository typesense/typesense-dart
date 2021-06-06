import 'request_exception.dart';

/// 422 Unprocessable Entity
class ObjectUnprocessable extends RequestException {
  ObjectUnprocessable(String message) : super(message, 422);
}
