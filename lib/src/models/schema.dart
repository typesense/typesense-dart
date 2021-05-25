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

  Schema(this.name, this.fields, {this.defaultSortingField}) {
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

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['fields'] = fields.map((field) => field.toMap()).toList();
    map['default_sorting_field'] = defaultSortingField?.name ?? '';
    return map;
  }
}
