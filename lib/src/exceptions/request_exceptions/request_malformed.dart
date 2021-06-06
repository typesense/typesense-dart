import 'request_exception.dart';

/// 400 Bad Request
class RequestMalformed extends RequestException {
  RequestMalformed(String message) : super(message, 400);
}
