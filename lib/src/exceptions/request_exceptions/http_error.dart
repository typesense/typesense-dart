part of '../exceptions.dart';

/// The request has failed because of some network layer issues like
/// connection timeouts, etc.
class HttpError extends RequestException {
  HttpError(super.message, super.statusCode);

  @override
  String toString() {
    return '$statusCode: $message';
  }
}
