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

  Schema(
    this.name,
    super.fields, {
    this.defaultSortingField,
    this.documentCount,
    this.enableNestedFields,
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
    return map;
  }
}

class UpdateSchema extends BaseSchema {
  UpdateSchema(Set<UpdateField> super.fields);

  factory UpdateSchema.fromMap(Map<String, dynamic> map) {
    final Set<UpdateField> fields = (map['fields'] != null)
        ? (map['fields'] as List)
            .map((field) => UpdateField.fromMap(field))
            .toSet()
        : {};

    return UpdateSchema(
      fields,
    );
  }
}

ArgumentError _defaultSortingFieldNotInSchema(String name) =>
    ArgumentError('Ensure defaultSortingField "$name" is present in fields');
