class MissingConfiguration implements Exception {
  final String message;
  MissingConfiguration(this.message);
}

abstract class RequestException implements Exception {
  final String message;
  final int statusCode;

  RequestException(this.message, this.statusCode);
}

class ObjectAlreadyExists extends RequestException {
  ObjectAlreadyExists(String message, int statusCode)
      : super(message, statusCode);
}

class ObjectNotFound extends RequestException {
  ObjectNotFound(String message, int statusCode) : super(message, statusCode);
}

class ObjectUnprocessable extends RequestException {
  ObjectUnprocessable(String message, int statusCode)
      : super(message, statusCode);
}

class RequestMalformed extends RequestException {
  RequestMalformed(String message, int statusCode) : super(message, statusCode);
}

class RequestUnauthorized extends RequestException {
  RequestUnauthorized(String message, int statusCode)
      : super(message, statusCode);
}

class ServerError extends RequestException {
  ServerError(String message, int statusCode) : super(message, statusCode);
}

class HttpError extends RequestException {
  HttpError(String message, int statusCode) : super(message, statusCode);
}
