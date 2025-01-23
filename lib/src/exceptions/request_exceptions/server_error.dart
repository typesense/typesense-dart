part of '../exceptions.dart';

/// 5xx server errors
class ServerError extends RequestException {
  ServerError(super.message, super.statusCode);

  @override
  String toString() {
    return '$statusCode: $message';
  }
}
