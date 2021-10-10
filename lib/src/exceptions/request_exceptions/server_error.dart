part of exceptions;

/// 5xx server errors
class ServerError extends RequestException {
  ServerError(String message, int statusCode) : super(message, statusCode);

  @override
  String toString() {
    return '$statusCode: $message';
  }
}
