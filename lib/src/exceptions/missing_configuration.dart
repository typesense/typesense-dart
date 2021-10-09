part of exceptions;

class MissingConfiguration implements TypesenseException {
  final String message;
  MissingConfiguration(this.message);

  @override
  String toString() => message;
}
