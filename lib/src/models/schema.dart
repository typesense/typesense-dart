part of 'models.dart';

abstract class BaseSchema {
  /// [fields] used for querying, filtering and faceting.
  final Set<Field> fields;

  /// The synonym sets feature allows you to define search terms that should
  /// be considered equivalent.
  final Set<String>? synonymSets;

  /// List of curation set names associated with this collection.
  final Set<String>? curationSets;

  /// The fields within the metadata object are persisted and returned in the
  /// GET /collections end-point.
  final Map<String, String>? metadata;

  BaseSchema(
    this.fields, {
    this.synonymSets,
    this.curationSets,
    this.metadata,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (fields.isNotEmpty) {
      map['fields'] = fields.map((field) => field.toMap()).toList();
    }
    map['synonym_sets'] = synonymSets?.toList() ?? [];
    map['curation_sets'] = curationSets?.toList() ?? [];
    map['metadata'] = metadata ?? {};
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
    this.symbolsToIndex,
    this.tokenSeparators,
    super.curationSets,
    super.synonymSets,
    super.metadata,
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
      defaultSortingField: defaultSortingField,
      documentCount: map['num_documents'] ?? 0,
      enableNestedFields: enableNestedFields,
      createdAt: map['created_at'],
      numMemoryShards: map['num_memory_shards'],
      symbolsToIndex: (map['symbols_to_index'] as List?)?.cast<String>(),
      tokenSeparators: (map['token_separators'] as List?)?.cast<String>(),
      curationSets: (map['curation_sets'] as List?)?.cast<String>().toSet(),
      synonymSets: (map['synonym_sets'] as List?)?.cast<String>().toSet(),
      metadata: (map['metadata'] as Map?)?.cast<String, String>(),
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
  UpdateSchema(Set<UpdateField> super.fields,
      {super.synonymSets, super.curationSets, super.metadata});

  factory UpdateSchema.fromMap(Map<String, dynamic> map) {
    final Set<UpdateField> fields = (map['fields'] != null)
        ? (map['fields'] as List)
            .map((field) => UpdateField.fromMap(field))
            .toSet()
        : {};

    return UpdateSchema(
      fields,
      synonymSets: (map['synonym_sets'] as List?)?.cast<String>().toSet(),
      curationSets: (map['curation_sets'] as List?)?.cast<String>().toSet(),
      metadata: (map['metadata'] as Map?)?.cast<String, String>(),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    return map;
  }

  @override
  String toString() => toMap().toString();
}

ArgumentError _defaultSortingFieldNotInSchema(String name) =>
    ArgumentError('Ensure defaultSortingField "$name" is present in fields');
