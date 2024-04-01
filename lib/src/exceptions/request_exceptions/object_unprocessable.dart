part of '../exceptions.dart';

/// 422 Unprocessable Entity
class ObjectUnprocessable extends RequestException {
  ObjectUnprocessable(String message) : super(message, 422);

  @override
  String toString() {
    return '422: $message';
  }
}
