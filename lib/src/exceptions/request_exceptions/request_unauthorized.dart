part of '../exceptions.dart';

/// 401 Unauthorized
class RequestUnauthorized extends RequestException {
  RequestUnauthorized(String message) : super(message, 401);

  @override
  String toString() {
    return '401: $message';
  }
}
