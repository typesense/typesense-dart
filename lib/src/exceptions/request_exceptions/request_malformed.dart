part of exceptions;

/// 400 Bad Request
class RequestMalformed extends RequestException {
  RequestMalformed(String message) : super(message, 400);

  @override
  String toString() {
    return '400: $message';
  }
}
