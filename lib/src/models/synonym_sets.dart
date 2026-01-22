part of 'models.dart';

class SynonymItemSchema {
  final String id;
  final List<String> synonyms;
  final String? root;
  final String? locale;
  final List<String>? symbolsToIndex;

  SynonymItemSchema({
    required this.id,
    required this.synonyms,
    this.root,
    this.locale,
    this.symbolsToIndex,
  });

  factory SynonymItemSchema.fromJson(Map<String, dynamic> json) =>
      SynonymItemSchema(
        id: json['id'] as String,
        synonyms: (json['synonyms'] as List).cast<String>(),
        root: json['root'] as String?,
        locale: json['locale'] as String?,
        symbolsToIndex: (json['symbols_to_index'] as List?)?.cast<String>(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'synonyms': synonyms,
        if (root != null) 'root': root,
        if (locale != null) 'locale': locale,
        if (symbolsToIndex != null) 'symbols_to_index': symbolsToIndex,
      };
}

class SynonymItemDeleteSchema {
  final String id;

  SynonymItemDeleteSchema({required this.id});

  factory SynonymItemDeleteSchema.fromJson(Map<String, dynamic> json) =>
      SynonymItemDeleteSchema(
        id: json['id'] as String,
      );
}

class SynonymSetCreateSchema {
  final List<SynonymItemSchema> items;

  SynonymSetCreateSchema({required this.items});

  Map<String, dynamic> toJson() => {
        'items': items.map((item) => item.toJson()).toList(),
      };

  factory SynonymSetCreateSchema.fromJson(Map<String, dynamic> json) =>
      SynonymSetCreateSchema(
        items: (json['items'] as List? ?? [])
            .map((item) =>
                SynonymItemSchema.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList(),
      );
}

class SynonymSetSchema extends SynonymSetCreateSchema {
  final String name;

  SynonymSetSchema({
    required this.name,
    required super.items,
  });

  factory SynonymSetSchema.fromJson(Map<String, dynamic> json) =>
      SynonymSetSchema(
        name: json['name'] as String,
        items: (json['items'] as List? ?? [])
            .map((item) =>
                SynonymItemSchema.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList(),
      );
}

class SynonymSetRetrieveSchema extends SynonymSetCreateSchema {
  SynonymSetRetrieveSchema({required super.items});

  factory SynonymSetRetrieveSchema.fromJson(Map<String, dynamic> json) =>
      SynonymSetRetrieveSchema(
        items: (json['items'] as List? ?? [])
            .map((item) =>
                SynonymItemSchema.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList(),
      );
}

class SynonymSetDeleteSchema {
  final String name;

  SynonymSetDeleteSchema({required this.name});

  factory SynonymSetDeleteSchema.fromJson(Map<String, dynamic> json) =>
      SynonymSetDeleteSchema(
        name: json['name'] as String,
      );
}
