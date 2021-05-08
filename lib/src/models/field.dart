class Field {
  final String name;
  final Type type;
  final bool isOptional;
  final bool isFacetable;
  final bool isMultivalued;
  int _hash;

  Field(
    this.name,
    this.type, {
    this.isOptional = false,
    this.isFacetable = false,
    this.isMultivalued = false,
  }) {
    if (name == null || name.isEmpty) {
      throw ArgumentError('Ensure Field.name is set');
    }
    if (type == null) {
      throw ArgumentError('Ensure Field.type is set');
    }
    _hash = name.hashCode ^
        type.hashCode ^
        isOptional.hashCode ^
        isFacetable.hashCode ^
        isMultivalued.hashCode;
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['type'] = type.value(isMultivalued);
    map['facet'] = isFacetable;
    map['optional'] = isOptional;
    return map;
  }

  @override
  int get hashCode => _hash;

  @override
  bool operator ==(Object o) =>
      identical(this, o) ||
      (o is Field &&
          runtimeType == o.runtimeType &&
          name == o.name &&
          type == o.type &&
          isOptional == o.isOptional &&
          isFacetable == o.isFacetable &&
          isMultivalued == o.isMultivalued);
}

enum Type { string, int32, int64, float, bool }

extension _TypeExtension on Type {
  String value(bool isMultivalued) {
    final description = this.toString(),
        indexOfDot = description.indexOf('.'),
        value = description.substring(indexOfDot + 1);
    return isMultivalued ? value + '[]' : value;
  }
}
