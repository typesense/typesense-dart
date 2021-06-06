import 'typesense_exception.dart';

class MissingConfiguration implements TypesenseException {
  final String message;
  MissingConfiguration(this.message);
}
