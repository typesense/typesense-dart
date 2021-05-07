import 'field.dart';

class Schema {
  final String name;
  final Set<Field> fields;
  final Field defaultSortingField;

  Schema(this.name, this.fields, this.defaultSortingField) {
    if (name == null || name.isEmpty) {
      throw ArgumentError('Ensure Schema.name is set');
    }
    if (fields == null || fields.isEmpty) {
      throw ArgumentError('Ensure Schema.fields is set');
    }
    if (defaultSortingField == null) {
      throw ArgumentError('Ensure Schema.defaultSortingField is set');
    }
    if (!fields.contains(defaultSortingField)) {
      throw ArgumentError(
          'Ensure Schema.defaultSortingField is present in Schema.fields');
    }
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['fields'] = fields.map((field) => field.toMap()).toList();
    map['default_sorting_field'] = defaultSortingField.name;
    return map;
  }
}
