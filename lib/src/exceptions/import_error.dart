part of exceptions;

class ImportError implements TypesenseException {
  final String message;
  final List<Map<String, dynamic>> importResults;
  ImportError(this.message, this.importResults);

  @override
  String toString() => message;
}
