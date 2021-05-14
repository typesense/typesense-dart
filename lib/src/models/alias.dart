import '../api_call.dart';
import '../aliases.dart';

class Alias {
  final String name;
  final String collectionName;
  final ApiCall _apiCall;
  static const _parameter = 'collection_name';

  Alias(this.name, {this.collectionName, ApiCall apiCall})
      : _apiCall = apiCall {
    if (name == null || name.isEmpty) {
      throw ArgumentError('Ensure Alias.name is set');
    }
  }

  Future<Alias> delete() async {
    return Alias.fromMap(
      await _apiCall.delete(
        '${Aliases.RESOURCEPATH}/$name',
      ),
    );
  }

  Future<Alias> retrieve() async {
    return Alias.fromMap(
      await _apiCall.get(
        '${Aliases.RESOURCEPATH}/$name',
      ),
    );
  }

  factory Alias.fromMap(Map<String, dynamic> map) =>
      Alias(map['name'], collectionName: map[_parameter]);

  Map<String, String> get collectionNameAsMap => {_parameter: collectionName};

  @override
  int get hashCode => name.hashCode ^ collectionName.hashCode;

  @override
  bool operator ==(Object o) =>
      identical(this, o) ||
      (o is Alias &&
          runtimeType == o.runtimeType &&
          name == o.name &&
          collectionName == o.collectionName);
}
