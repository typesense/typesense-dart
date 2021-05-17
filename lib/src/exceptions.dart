class MissingConfiguration implements Exception {
  final String message;
  MissingConfiguration(this.message);
}

abstract class RequestException implements Exception {
  final String message;
  final int statusCode;

  RequestException(this.message, this.statusCode);
}

/// 409 Conflict
class ObjectAlreadyExists extends RequestException {
  ObjectAlreadyExists(String message, int statusCode)
      : super(message, statusCode);
}

/// 404 Not Found
class ObjectNotFound extends RequestException {
  ObjectNotFound(String message, int statusCode) : super(message, statusCode);
}

/// 422 Unprocessable Entity
class ObjectUnprocessable extends RequestException {
  ObjectUnprocessable(String message, int statusCode)
      : super(message, statusCode);
}

/// 400 Bad Request
class RequestMalformed extends RequestException {
  RequestMalformed(String message, int statusCode) : super(message, statusCode);
}

/// 401 Unauthorized
class RequestUnauthorized extends RequestException {
  RequestUnauthorized(String message, int statusCode)
      : super(message, statusCode);
}

/// 5xx server errors
class ServerError extends RequestException {
  ServerError(String message, int statusCode) : super(message, statusCode);
}

/// If the request has failed, but no other [RequestException]s are aplicable.
class HttpError extends RequestException {
  HttpError(String message, int statusCode) : super(message, statusCode);
}
