part of 'models.dart';

class StemmingDictionaryCreateSchema {
  final String word;
  final String root;

  StemmingDictionaryCreateSchema({
    required this.word,
    required this.root,
  });

  factory StemmingDictionaryCreateSchema.fromJson(Map<String, dynamic> json) =>
      StemmingDictionaryCreateSchema(
        word: json['word'] as String,
        root: json['root'] as String,
      );

  Map<String, dynamic> toJson() => {
        'word': word,
        'root': root,
      };
}

class StemmingDictionarySchema {
  final String id;
  final List<StemmingDictionaryCreateSchema> words;

  StemmingDictionarySchema({
    required this.id,
    required this.words,
  });

  factory StemmingDictionarySchema.fromJson(Map<String, dynamic> json) =>
      StemmingDictionarySchema(
        id: json['id'] as String,
        words: (json['words'] as List? ?? [])
            .map((item) => StemmingDictionaryCreateSchema.fromJson(
                Map<String, dynamic>.from(item as Map)))
            .toList(),
      );
}

class StemmingDictionariesRetrieveSchema {
  final List<String> dictionaries;

  StemmingDictionariesRetrieveSchema({required this.dictionaries});

  factory StemmingDictionariesRetrieveSchema.fromJson(
          Map<String, dynamic> json) =>
      StemmingDictionariesRetrieveSchema(
        dictionaries: (json['dictionaries'] as List? ?? []).cast<String>(),
      );
}
