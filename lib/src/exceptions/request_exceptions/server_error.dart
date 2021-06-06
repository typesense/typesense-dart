import 'request_exception.dart';

/// 5xx server errors
class ServerError extends RequestException {
  ServerError(String message, int statusCode) : super(message, statusCode);
}
