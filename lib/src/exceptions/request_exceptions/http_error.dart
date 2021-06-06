import 'request_exception.dart';

/// If the request has failed, but no other [RequestException]s are aplicable.
class HttpError extends RequestException {
  HttpError(String message, int statusCode) : super(message, statusCode);
}
