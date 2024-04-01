part of '../exceptions.dart';

/// The request has failed because of some network layer issues like
/// connection timeouts, etc.
class HttpError extends RequestException {
  HttpError(String message, int statusCode) : super(message, statusCode);

  @override
  String toString() {
    return '$statusCode: $message';
  }
}
