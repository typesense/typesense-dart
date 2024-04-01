part of 'exceptions.dart';

class MissingConfiguration implements TypesenseException {
  final String message;
  MissingConfiguration(this.message);

  @override
  String toString() => message;
}
