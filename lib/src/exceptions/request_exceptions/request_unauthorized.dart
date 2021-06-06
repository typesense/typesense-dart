import 'request_exception.dart';

/// 401 Unauthorized
class RequestUnauthorized extends RequestException {
  RequestUnauthorized(String message) : super(message, 401);
}
