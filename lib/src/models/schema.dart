part of models;

abstract class BaseSchema {
  /// [fields] used for querying, filtering and faceting.
  final Set<Field> fields;

  BaseSchema(this.fields) {
    if (fields.isEmpty) {
      throw ArgumentError('Ensure BaseSchema.fields is not empty');
    }
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['fields'] = fields.map((field) => field.toMap()).toList();
    return map;
  }
}

class Schema extends BaseSchema {
  /// [name] of the collection.
  final String name;

  /// Number of documents currently in the collection [name].
  final int documentCount;

  /// A field in [fields] which will determine the order in which the search
  /// results are ranked when a `sort_by` clause is not provided during
  /// searching.
  final Field? defaultSortingField;

  Schema(
    this.name,
    super.fields, {
    this.defaultSortingField,
    required this.documentCount,
  });

  factory Schema.fromMap(Map<String, dynamic> map) {
    if ((map['name'] as String).isEmpty) {
      throw ArgumentError('Ensure Schema.name is not empty');
    }
    final Set<Field> fields = (map['fields'] != null)
        ? (map['fields'] as List).map((field) => Field.fromMap(field)).toSet()
        : throw ArgumentError('Ensure Schema.fields is set');

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

    return Schema(
      map['name'],
      fields,
      documentCount: map['num_documents'],
      defaultSortingField: defaultSortingField,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['name'] = name;
    if (defaultSortingField != null) {
      map['default_sorting_field'] = defaultSortingField!.name;
    }
    map['num_documents'] = documentCount;
    return map;
  }
}

class CreateSchema extends BaseSchema {
  /// [name] of the collection.
  final String name;

  /// A field in [fields] which will determine the order in which the search
  /// results are ranked when a `sort_by` clause is not provided during
  /// searching.
  final CreateField? defaultSortingField;

  CreateSchema(
    this.name,
    Set<CreateField> fields, {
    this.defaultSortingField,
  }) : super(fields) {
    if (name.isEmpty) {
      throw ArgumentError('Ensure CreateSchema.name is not empty');
    }
    if (defaultSortingField != null && defaultSortingField!.name.isNotEmpty) {
      if (!fields.contains(defaultSortingField)) {
        throw _defaultSortingFieldNotInSchema(defaultSortingField!.name);
      }
      if (!(defaultSortingField!.type == Type.int32 ||
          defaultSortingField!.type == Type.float)) {
        throw ArgumentError(
            'Ensure type of CreateSchema.defaultSortingField "${defaultSortingField!.name}" is int32 / float');
      }
    }
  }

  factory CreateSchema.fromMap(Map<String, dynamic> map) {
    if ((map['name'] as String).isEmpty) {
      throw ArgumentError('Ensure CreateSchema.name is not empty');
    }
    final Set<CreateField> fields = (map['fields'] != null)
        ? (map['fields'] as List)
            .map((field) => CreateField.fromMap(field))
            .toSet()
        : throw ArgumentError('Ensure CreateSchema.fields is set');

    final String? sortingFieldName = map['default_sorting_field'];
    final CreateField? defaultSortingField = (fields.isNotEmpty &&
            sortingFieldName != null &&
            sortingFieldName.isNotEmpty)
        ? fields.firstWhere(
            (field) => map['default_sorting_field'] == field.name,
            orElse: () => throw _defaultSortingFieldNotInSchema(
              sortingFieldName,
            ),
          )
        : null;

    return CreateSchema(
      map['name'],
      fields,
      defaultSortingField: defaultSortingField,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['name'] = name;
    if (defaultSortingField != null) {
      map['default_sorting_field'] = defaultSortingField!.name;
    }
    return map;
  }

  @override
  String toString() => toMap().toString();
}

class UpdateSchema extends BaseSchema {
  UpdateSchema(Set<UpdateField> fields) : super(fields);

  factory UpdateSchema.fromMap(Map<String, dynamic> map) {
    final Set<UpdateField> fields = (map['fields'] != null)
        ? (map['fields'] as List)
            .map((field) => UpdateField.fromMap(field))
            .toSet()
        : throw ArgumentError('Ensure UpdateSchema.fields is set');

    return UpdateSchema(
      fields,
    );
  }
}

ArgumentError _defaultSortingFieldNotInSchema(String name) =>
    ArgumentError('Ensure defaultSortingField "$name" is present in fields');
