part of exceptions;

/// 409 Conflict
class ObjectAlreadyExists extends RequestException {
  ObjectAlreadyExists(String message) : super(message, 409);

  @override
  String toString() {
    return '409: $message';
  }
}
