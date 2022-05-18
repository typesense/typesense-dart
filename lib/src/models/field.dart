part of models;

abstract class BaseField extends Equatable {
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

  BaseField(
    this.name,
    this.type, {
    this.isOptional = false,
    this.isFacetable = false,
    this.isMultivalued = false,
    this.shouldIndex = true,
  }) {
    if (name.isEmpty) {
      throw ArgumentError('Ensure Field.name is set');
    }
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
  String toString() {
    return '$name(${type.value(isMultivalued)}), facetable: $isFacetable, optional: $isOptional, indexed: $shouldIndex';
  }

  @override
  List<Object> get props => [name, type, isMultivalued];
}

class Field extends BaseField {
  Field(
    super.name,
    super.type, {
    super.isOptional = false,
    super.isFacetable = false,
    super.isMultivalued = false,
    super.shouldIndex = true,
  });

  factory Field.fromMap(Map<String, dynamic> map) {
    final isMultivalued =
        map['type']?.contains(_multivaluedExpression) ?? false;

    return Field(
      map['name'],
      _Type.fromValue(map['type'], isMultivalued),
      isFacetable: map['facet'] ?? false,
      isOptional: map['optional'] ?? false,
      shouldIndex: map['index'] ?? true,
      isMultivalued: isMultivalued,
    );
  }
}

class CollectionUpdateField extends Field {
  /// If this field should be dropped during collection update operation.
  final bool shouldDrop;

  CollectionUpdateField(
    super.name,
    super.type, {
    super.isOptional,
    super.isFacetable,
    super.isMultivalued,
    super.shouldIndex,
    this.shouldDrop = false,
  });

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['drop'] = shouldDrop;
    return map;
  }
}

/// Enumerates the allowed field types.
///
/// [Type.auto] and [Type.stringify] are special field types that are used for
/// handling data sources with varying schema via automatic schema detection.
///
/// - [Type.auto] is used to let Typesense detect the type of the fields
/// automatically.
///
/// - [Type.stringify] (`string*`) is a way to store the field value (both
/// singular and multi-value/array values) as string.
///
/// [Type.geopoint] is used to index locations, filter and sort on them.
enum Type { string, int32, int64, float, bool, auto, stringify, geopoint }

extension _Type on Type {
  String value(bool isMultivalued) {
    switch (this) {
      case Type.string:
      case Type.int32:
      case Type.int64:
      case Type.float:
      case Type.bool:
        final description = toString(),
            indexOfDot = description.indexOf('.'),
            value = description.substring(indexOfDot + 1);

        return isMultivalued ? value + '[]' : value;

      case Type.auto:
        return 'auto';

      case Type.stringify:
        return 'string*';

      case Type.geopoint:
        return 'geopoint';
      default:
        return '';
    }
  }

  static Type fromValue(String value, bool isMultiValued) =>
      Type.values.firstWhere((type) => value == type.value(isMultiValued),
          orElse: () => throw ArgumentError('$value is not a defined Type.'));
}

final _multivaluedExpression = RegExp(r'\[\]$');
