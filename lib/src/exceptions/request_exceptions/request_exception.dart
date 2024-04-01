part of '../exceptions.dart';

abstract class RequestException implements TypesenseException {
  final String message;
  final int statusCode;

  RequestException(this.message, this.statusCode);
}
