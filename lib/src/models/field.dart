class Field {
  /// [name] of the field.
  final String name;

  /// [Type] of field.
  final Type type;

  /// If this field can be ommited in a document.
  final bool isOptional;

  /// If this field will be used in faceted search.
  final bool isFacetable;

  /// If this field is an array containing multiple values.
  ///
  /// Applicable to the field with the [type]:
  /// [Type.string], [Type.int32], [Type.int64], [Type.float] or [Type.bool]
  final bool isMultivalued;

  /// Declaring a field as non-indexable
  ///
  /// Setting this field to `false` ensures it is not indexed. This is useful
  /// when used along with auto schema detection.
  final bool shouldIndex;

  Field(
    this.name,
    this.type, {
    this.isOptional = false,
    this.isFacetable = false,
    this.isMultivalued = false,
    this.shouldIndex = true,
  }) {
    if (name == null || name.isEmpty) {
      throw ArgumentError('Ensure Field.name is set');
    }
    if (type == null) {
      throw ArgumentError('Ensure Field.type is set');
    }
  }

  factory Field.fromMap(Map<String, dynamic> map) {
    final isMultivalued = map['type']?.contains(RegExp(r'\[\]$')) ?? false;

    return Field(
      map['name'],
      _getTypeFrom(map['type'], isMultivalued),
      isFacetable: map['facet'] ?? false,
      isOptional: map['optional'] ?? false,
      shouldIndex: map['index'] ?? true,
      isMultivalued: isMultivalued,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['type'] = type.value(isMultivalued);
    map['facet'] = isFacetable;
    map['optional'] = isOptional;
    map['index'] = shouldIndex;
    return map;
  }

  @override
  int get hashCode =>
      name.hashCode ^
      type.hashCode ^
      isOptional.hashCode ^
      isFacetable.hashCode ^
      isMultivalued.hashCode ^
      shouldIndex.hashCode;

  @override
  bool operator ==(Object o) =>
      identical(this, o) ||
      (o is Field &&
          runtimeType == o.runtimeType &&
          name == o.name &&
          type == o.type &&
          isOptional == o.isOptional &&
          isFacetable == o.isFacetable &&
          isMultivalued == o.isMultivalued &&
          shouldIndex == o.shouldIndex);

  @override
  String toString() {
    return '$name(${type.value(isMultivalued)}), facetable: $isFacetable, optional: $isOptional, indexed: $shouldIndex';
  }
}

/// Enumerates the allowed field types.
///
/// [Type.auto] and [Type.stringify] are special field types that are used for
/// handling data sources with varying schema via automatic schema detection.
///
/// [Type.auto] is used to let Typesense detect the type of the fields
/// automatically.
///
/// [Type.stringify] (`string*`) is a way to store the field value (both
/// singular and multi-value/array values) as string.
enum Type { string, int32, int64, float, bool, auto, stringify }

extension _TypeExtension on Type {
  String value(bool isMultivalued) {
    switch (this) {
      case Type.string:
      case Type.int32:
      case Type.int64:
      case Type.float:
      case Type.bool:
        final description = this.toString(),
            indexOfDot = description.indexOf('.'),
            value = description.substring(indexOfDot + 1);

        return isMultivalued ? value + '[]' : value;
        break;

      case Type.auto:
        return 'auto';
        break;
      case Type.stringify:
        return 'string*';
        break;

      default:
        return '';
    }
  }
}

Type _getTypeFrom(String value, bool isMultiValued) => (value != null)
    ? Type.values.firstWhere((type) => value == type.value(isMultiValued),
        orElse: () => null)
    : null;
