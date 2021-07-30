import 'field.dart';

class Schema {
  /// [name] of the collection.
  final String name;

  /// [fields] that are to be indexed for querying, filtering and faceting.
  final Set<Field> fields;

  /// A field in [fields] which will determine the order in which the search
  /// results are ranked when a `sort_by` clause is not provided during
  /// searching.
  final Field? defaultSortingField;

  /// Number of documents currently in the collection [name].
  final int? documentCount;

  Schema(this.name, this.fields,
      {this.defaultSortingField, this.documentCount}) {
    if (name.isEmpty) {
      throw ArgumentError('Ensure Schema.name is not empty');
    }
    if (fields.isEmpty) {
      throw ArgumentError('Ensure Schema.fields is not empty');
    }
    if (defaultSortingField != null && defaultSortingField!.name.isNotEmpty) {
      if (!fields.contains(defaultSortingField)) {
        throw _defaultSortingFieldNotInSchema(defaultSortingField!.name);
      }
      if (!(defaultSortingField!.type == Type.int32 ||
          defaultSortingField!.type == Type.float)) {
        throw ArgumentError(
            'Ensure type of Schema.defaultSortingField "${defaultSortingField!.name}" is int32 / float');
      }
    }
  }

  factory Schema.fromMap(Map<String, dynamic> map) {
    final Set<Field> fields = (map['fields'] != null)
        ? (map['fields'] as List).map((field) => Field.fromMap(field)).toSet()
        : throw ArgumentError('Ensure Schema.fields is set');

    final String? sortingFieldName = map['default_sorting_field'];
    final Field? defaultSortingField = (fields.isNotEmpty &&
            sortingFieldName != null &&
            sortingFieldName.isNotEmpty)
        ? fields.firstWhere(
            (field) => map['default_sorting_field'] == field.name,
            orElse: () =>
                throw _defaultSortingFieldNotInSchema(sortingFieldName),
          )
        : null;

    return Schema(
      map['name'],
      fields,
      documentCount: map['num_documents'],
      defaultSortingField: defaultSortingField,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['fields'] = fields.map((field) => field.toMap()).toList();
    map['default_sorting_field'] = defaultSortingField?.name ?? '';
    return map;
  }

  @override
  String toString() => toMap().toString();
}

ArgumentError _defaultSortingFieldNotInSchema(String name) => ArgumentError(
    'Ensure Schema.defaultSortingField "$name" is present in Schema.fields');
