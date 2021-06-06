import 'typesense_exception.dart';

class ImportError implements TypesenseException {
  final String message;
  ImportError(this.message);
}
