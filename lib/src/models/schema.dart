import 'field.dart';

class Schema {
  /// [name] of the collection.
  final String name;

  /// [fields] that are to be indexed for querying, filtering and faceting.
  final Set<Field> fields;

  /// A field in [fields] which will determine the order in which the search
  /// results are ranked when a `sort_by` clause is not provided during
  /// searching.
  final Field defaultSortingField;

  /// Number of documents currently in the collection [name].
  final int documentCount;

  Schema(this.name, this.fields,
      {this.defaultSortingField, this.documentCount = 0}) {
    if (name == null || name.isEmpty) {
      throw ArgumentError('Ensure Schema.name is set');
    }
    if (fields == null || fields.isEmpty) {
      throw ArgumentError('Ensure Schema.fields is set');
    }
    if (defaultSortingField != null) {
      if (!fields.contains(defaultSortingField)) {
        throw ArgumentError(
            'Ensure Schema.defaultSortingField is present in Schema.fields');
      }
      if (!(defaultSortingField.type == Type.int32 ||
          defaultSortingField.type == Type.float)) {
        throw ArgumentError(
            'Ensure type of Schema.defaultSortingField is int32 / float');
      }
    }
  }

  factory Schema.fromMap(Map<String, dynamic> map) {
    final fields = (map['fields'] != null)
            ? (map['fields'] as List)
                .map((field) => Field.fromMap(field))
                .toSet()
            : null,
        defaultSortingField = (fields != null)
            ? fields.firstWhere(
                (field) => map['default_sorting_field'] == field.name,
                orElse: () => Field(map['default_sorting_field'], Type.auto),
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
