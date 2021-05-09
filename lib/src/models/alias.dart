class Alias {
  final String name;
  final String collectionName;
  static const _parameter = 'collection_name';

  Alias(this.name, this.collectionName) {
    if (name == null || name.isEmpty) {
      throw ArgumentError('Ensure Alias.name is set');
    }
    if (collectionName == null || collectionName.isEmpty) {
      throw ArgumentError('Ensure Alias.collectionName is set');
    }
  }

  factory Alias.fromMap(Map<String, dynamic> map) =>
      Alias(map['name'], map[_parameter]);

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
