part of 'models.dart';

abstract class BaseSchema {
  /// [fields] used for querying, filtering and faceting.
  final Set<Field> fields;

  BaseSchema(this.fields);

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['fields'] = fields.map((field) => field.toMap()).toList();
    return map;
  }

  @override
  String toString() => toMap().toString();
}

class Schema extends BaseSchema {
  /// [name] of the collection.
  final String name;

  /// Number of documents currently in the collection [name].
  final int? documentCount;

  /// A field in [fields] which will determine the order in which the search
  /// results are ranked when a `sort_by` clause is not provided during
  /// searching.
  final Field? defaultSortingField;

  /// Boolean to enable nested fields on the schema, only available for typesense 0.24 or more
  final bool? enableNestedFields;

  /// Timestamp when the collection was created.
  final int? createdAt;

  /// Number of memory shards used by the collection.
  final int? numMemoryShards;

  /// List of curation set names associated with this collection.
  final List<String>? curationSets;

  /// List of synonym set names associated with this collection.
  final List<String>? synonymSets;

  /// List of special characters to index at the collection level.
  final List<String>? symbolsToIndex;

  /// List of characters to use as token separators at the collection level.
  final List<String>? tokenSeparators;

  Schema(
    this.name,
    super.fields, {
    this.defaultSortingField,
    this.documentCount,
    this.enableNestedFields,
    this.createdAt,
    this.numMemoryShards,
    this.curationSets,
    this.synonymSets,
    this.symbolsToIndex,
    this.tokenSeparators,
  });

  factory Schema.fromMap(Map<String, dynamic> map) {
    if ((map['name'] as String).isEmpty) {
      throw ArgumentError('Ensure Schema.name is not empty');
    }
    final Set<Field> fields = (map['fields'] != null)
        ? (map['fields'] as List).map((field) => Field.fromMap(field)).toSet()
        : {};

    final String? sortingFieldName = map['default_sorting_field'];
    final Field? defaultSortingField = (fields.isNotEmpty &&
            sortingFieldName != null &&
            sortingFieldName.isNotEmpty)
        ? fields.firstWhere(
            (field) => map['default_sorting_field'] == field.name,
            orElse: () => throw _defaultSortingFieldNotInSchema(
              sortingFieldName,
            ),
          )
        : null;
    final bool? enableNestedFields = map["enable_nested_fields"];

    return Schema(
      map['name'],
      fields,
      documentCount: map['num_documents'] ?? 0,
      defaultSortingField: defaultSortingField,
      enableNestedFields: enableNestedFields,
      createdAt: map['created_at'],
      numMemoryShards: map['num_memory_shards'],
      curationSets: (map['curation_sets'] as List?)?.cast<String>(),
      synonymSets: (map['synonym_sets'] as List?)?.cast<String>(),
      symbolsToIndex: (map['symbols_to_index'] as List?)?.cast<String>(),
      tokenSeparators: (map['token_separators'] as List?)?.cast<String>(),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['name'] = name;
    if (defaultSortingField != null) {
      map['default_sorting_field'] = defaultSortingField!.name;
    }
    if (documentCount != null) {
      map['num_documents'] = documentCount;
    }
    if (enableNestedFields != null) {
      map['enable_nested_fields'] = enableNestedFields;
    }
    if (createdAt != null) {
      map['created_at'] = createdAt;
    }
    if (numMemoryShards != null) {
      map['num_memory_shards'] = numMemoryShards;
    }
    if (curationSets != null) {
      map['curation_sets'] = curationSets;
    }
    if (synonymSets != null) {
      map['synonym_sets'] = synonymSets;
    }
    if (symbolsToIndex != null) {
      map['symbols_to_index'] = symbolsToIndex;
    }
    if (tokenSeparators != null) {
      map['token_separators'] = tokenSeparators;
    }
    return map;
  }
}

class UpdateSchema extends BaseSchema {
  /// List of synonym set IDs to associate with the collection.
  final List<String>? synonymSets;

  /// List of curation set IDs to associate with the collection.
  final List<String>? curationSets;

  /// List of special characters to index at the collection level.
  final List<String>? symbolsToIndex;

  /// List of characters to use as token separators at the collection level.
  final List<String>? tokenSeparators;

  UpdateSchema(
    Set<UpdateField> super.fields, {
    this.synonymSets,
    this.curationSets,
    this.symbolsToIndex,
    this.tokenSeparators,
  });

  factory UpdateSchema.fromMap(Map<String, dynamic> map) {
    final Set<UpdateField> fields = (map['fields'] != null)
        ? (map['fields'] as List)
            .map((field) => UpdateField.fromMap(field))
            .toSet()
        : {};

    return UpdateSchema(
      fields,
      synonymSets: (map['synonym_sets'] as List?)?.cast<String>(),
      curationSets: (map['curation_sets'] as List?)?.cast<String>(),
      symbolsToIndex: (map['symbols_to_index'] as List?)?.cast<String>(),
      tokenSeparators: (map['token_separators'] as List?)?.cast<String>(),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    if (synonymSets != null) {
      map['synonym_sets'] = synonymSets;
    }
    if (curationSets != null) {
      map['curation_sets'] = curationSets;
    }
    if (symbolsToIndex != null) {
      map['symbols_to_index'] = symbolsToIndex;
    }
    if (tokenSeparators != null) {
      map['token_separators'] = tokenSeparators;
    }
    return map;
  }
}

ArgumentError _defaultSortingFieldNotInSchema(String name) =>
    ArgumentError('Ensure defaultSortingField "$name" is present in fields');
