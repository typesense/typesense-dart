part of 'models.dart';

class Field {
  /// [name] of the field.
  final String name;

  /// [Type] of field.
  final Type? type;

  /// If this field is an array containing multiple values.
  ///
  /// Applicable to the field with the [type]:
  /// [Type.string], [Type.int32], [Type.int64],
  /// [Type.float], [Type.bool] or [Type.geopoint]
  final bool isMultivalued;

  /// Used in case of a vector field. Represents the number of dimensions
  /// (length of the float array) that your embeddings contain.
  final int dimensions;

  /// If this field can be ommited in a document.
  final bool isOptional;

  /// If this field will be used in faceted search.
  final bool isFacetable;

  /// Declaring a field as non-indexable
  ///
  /// Setting this field to `false` ensures it is not indexed. This is useful
  /// when used along with auto schema detection.
  final bool shouldIndex;

  final String? locale;

  /// Enable sorting on a string field.
  ///
  /// Sorting is enabled by default on numerical and boolean fields.
  final bool sort;

  /// Enable infix search on a string field.
  ///
  /// Since infix searching requires an additional data structure it has to
  /// be enabled on a per-field basis.
  final bool enableInfixSearch;

  /// Connects a document to a field in another collection.
  ///
  /// Example value: `ReferencedCollectionName.fieldName`.
  final String? reference;

  /// Enable stemming for this string field.
  final bool stem;

  /// Whether to store the field value on disk.
  ///
  /// When set to `false`, the field value won't be stored on disk.
  final bool store;

  /// Enable range index for this numerical field.
  ///
  /// Useful for efficient range queries on numerical fields.
  final bool rangeIndex;

  /// List of characters to use as token separators for this field.
  ///
  /// Overrides the collection-level token_separators setting for this field.
  final List<String>? tokenSeparators;

  /// List of special characters to index as part of tokens for this field.
  ///
  /// Overrides the collection-level symbols_to_index setting for this field.
  final List<String>? symbolsToIndex;

  /// Custom stem dictionary for this field.
  ///
  /// Allows specifying custom stemming rules for this field.
  final String? stemDictionary;

  /// Maximum length to truncate the field value to.
  ///
  /// Token values longer than this will be truncated.
  final int? truncateLen;

  Field(
    this.name, {
    this.type,
    this.isMultivalued = false,
    this.dimensions = 0,
    this.isOptional = false,
    this.isFacetable = false,
    this.shouldIndex = true,
    this.locale,
    this.sort = false,
    this.enableInfixSearch = false,
    this.reference,
    this.stem = false,
    this.store = true,
    this.rangeIndex = false,
    this.tokenSeparators,
    this.symbolsToIndex,
    this.stemDictionary,
    this.truncateLen,
  }) {
    if (name.isEmpty) {
      throw ArgumentError('Ensure Field.name is not empty');
    }
  }

  factory Field.fromMap(Map<String, dynamic> map) {
    final isMultivalued =
        map['type']?.contains(_multivaluedExpression) ?? false;

    return Field(
      map['name'],
      type: map['type'] != null
          ? _Type.fromValue(map['type'], isMultivalued)
          : null,
      isMultivalued: isMultivalued,
      dimensions: map['num_dim'] ?? 0,
      isOptional: map['optional'] ?? false,
      isFacetable: map['facet'] ?? false,
      shouldIndex: map['index'] ?? true,
      locale: map['locale'],
      sort: map['sort'] ?? false,
      enableInfixSearch: map['infix'] ?? false,
      reference: map['reference'],
      stem: map['stem'] ?? false,
      store: map['store'] ?? true,
      rangeIndex: map['range_index'] ?? false,
      tokenSeparators: (map['token_separators'] as List?)?.cast<String>(),
      symbolsToIndex: (map['symbols_to_index'] as List?)?.cast<String>(),
      stemDictionary: map['stem_dictionary'],
      truncateLen: map['truncate_len'],
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['name'] = name;
    if (type != null) {
      map['type'] = type!.value(isMultivalued);
    }
    if (dimensions > 0) {
      map['num_dim'] = dimensions;
    }
    if (isOptional) {
      map['optional'] = true;
    }
    if (isFacetable) {
      map['facet'] = true;
    }
    if (!shouldIndex) {
      map['index'] = false;
    }
    if (locale != null) {
      map['locale'] = locale;
    }
    if (sort) {
      map['sort'] = true;
    }
    if (enableInfixSearch) {
      map['infix'] = true;
    }
    if (reference != null) {
      map['reference'] = reference;
    }
    if (stem) {
      map['stem'] = true;
    }
    if (!store) {
      map['store'] = false;
    }
    if (rangeIndex) {
      map['range_index'] = true;
    }
    if (tokenSeparators != null) {
      map['token_separators'] = tokenSeparators;
    }
    if (symbolsToIndex != null) {
      map['symbols_to_index'] = symbolsToIndex;
    }
    if (stemDictionary != null && stemDictionary!.isNotEmpty) {
      map['stem_dictionary'] = stemDictionary;
    }
    if (truncateLen != null) {
      map['truncate_len'] = truncateLen;
    }
    return map;
  }

  @override
  String toString() {
    return '$name(${type?.value(isMultivalued) ?? ''})';
  }

  @override
  int get hashCode =>
      name.hashCode ^
      type.hashCode ^
      isMultivalued.hashCode ^
      dimensions.hashCode ^
      isOptional.hashCode ^
      isFacetable.hashCode ^
      shouldIndex.hashCode ^
      locale.hashCode ^
      sort.hashCode ^
      enableInfixSearch.hashCode ^
      reference.hashCode ^
      stem.hashCode ^
      store.hashCode ^
      rangeIndex.hashCode ^
      tokenSeparators.hashCode ^
      symbolsToIndex.hashCode ^
      stemDictionary.hashCode ^
      truncateLen.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Field &&
        other.runtimeType == runtimeType &&
        other.name == name &&
        other.type == type &&
        other.isMultivalued == isMultivalued &&
        other.dimensions == dimensions &&
        other.isOptional == isOptional &&
        other.isFacetable == isFacetable &&
        other.shouldIndex == shouldIndex &&
        other.locale == locale &&
        other.sort == sort &&
        other.enableInfixSearch == enableInfixSearch &&
        other.reference == reference &&
        other.stem == stem &&
        other.store == store &&
        other.rangeIndex == rangeIndex &&
        _listEquals(other.tokenSeparators, tokenSeparators) &&
        _listEquals(other.symbolsToIndex, symbolsToIndex) &&
        other.stemDictionary == stemDictionary &&
        other.truncateLen == truncateLen;
  }
}

bool _listEquals<T>(List<T>? a, List<T>? b) {
  if (a == null && b == null) return true;
  if (a == null || b == null) return false;
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

/// Used to update a colletion's fields.
///
/// Since Typesense currently only supports adding/deleting a field,
/// any modifications to an existing field should be expressed as a drop + add
/// operation.
class UpdateField extends Field {
  /// If this field should be dropped during collection update operation.
  final bool shouldDrop;

  UpdateField(
    super.name, {
    super.type,
    super.isMultivalued,
    super.dimensions,
    super.isOptional,
    super.isFacetable,
    super.shouldIndex,
    super.locale,
    super.sort,
    super.enableInfixSearch,
    super.reference,
    super.stem,
    super.store,
    super.rangeIndex,
    super.tokenSeparators,
    super.symbolsToIndex,
    super.stemDictionary,
    super.truncateLen,
    this.shouldDrop = false,
  });

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    if (shouldDrop) {
      map['drop'] = true;
    }
    return map;
  }

  factory UpdateField.fromMap(Map<String, dynamic> map) {
    final field = Field.fromMap(map);

    return UpdateField(
      field.name,
      type: field.type,
      isMultivalued: field.isMultivalued,
      dimensions: field.dimensions,
      isOptional: field.isOptional,
      isFacetable: field.isFacetable,
      shouldIndex: field.shouldIndex,
      locale: field.locale,
      sort: field.sort,
      enableInfixSearch: field.enableInfixSearch,
      reference: field.reference,
      stem: field.stem,
      store: field.store,
      rangeIndex: field.rangeIndex,
      tokenSeparators: field.tokenSeparators,
      symbolsToIndex: field.symbolsToIndex,
      stemDictionary: field.stemDictionary,
      truncateLen: field.truncateLen,
      shouldDrop: map['drop'] ?? false,
    );
  }

  @override
  int get hashCode =>
      name.hashCode ^
      type.hashCode ^
      isMultivalued.hashCode ^
      dimensions.hashCode ^
      isOptional.hashCode ^
      isFacetable.hashCode ^
      shouldIndex.hashCode ^
      locale.hashCode ^
      sort.hashCode ^
      enableInfixSearch.hashCode ^
      shouldDrop.hashCode;

  @override
  bool operator ==(Object other) {
    return other is UpdateField &&
        other.runtimeType == runtimeType &&
        other.name == name &&
        other.type == type &&
        other.isMultivalued == isMultivalued &&
        other.dimensions == dimensions &&
        other.isOptional == isOptional &&
        other.isFacetable == isFacetable &&
        other.shouldIndex == shouldIndex &&
        other.locale == locale &&
        other.sort == sort &&
        other.enableInfixSearch == enableInfixSearch &&
        other.shouldDrop == shouldDrop;
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
/// [Type.geopoint] and [Type.geopolygon] are used to index locations, filter
/// and sort on them.
enum Type {
  string,
  int32,
  int64,
  float,
  bool,
  auto,
  stringify,
  geopoint,
  geopolygon,
  object,
  image,
}

extension _Type on Type {
  String value(bool isMultivalued) {
    switch (this) {
      case Type.string:
      case Type.int32:
      case Type.int64:
      case Type.float:
      case Type.bool:
      case Type.geopoint:
      case Type.geopolygon:
      case Type.object:
      case Type.image:
        final description = toString(),
            indexOfDot = description.indexOf('.'),
            value = description.substring(indexOfDot + 1);

        return isMultivalued ? '$value[]' : value;

      case Type.auto:
        return 'auto';

      case Type.stringify:
        return 'string*';
    }
  }

  static Type fromValue(String value, bool isMultiValued) =>
      Type.values.firstWhere(
        (type) => value == type.value(isMultiValued),
        orElse: () => throw ArgumentError('$value is not a defined Type.'),
      );
}

final _multivaluedExpression = RegExp(r'\[\]$');
