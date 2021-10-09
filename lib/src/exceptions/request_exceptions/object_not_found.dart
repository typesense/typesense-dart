part of exceptions;

/// 404 Not Found
class ObjectNotFound extends RequestException {
  ObjectNotFound(String message) : super(message, 404);

  @override
  String toString() {
    return '404: $message';
  }
}
