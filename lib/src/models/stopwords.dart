part of 'models.dart';

class StopwordCreateSchema {
  final List<String> stopwords;
  final String? locale;

  StopwordCreateSchema({
    required this.stopwords,
    this.locale,
  });

  Map<String, dynamic> toJson() => {
        'stopwords': stopwords,
        if (locale != null) 'locale': locale,
      };
}

class StopwordSchema {
  final String id;
  final List<String> stopwords;
  final String? locale;

  StopwordSchema({
    required this.id,
    required this.stopwords,
    this.locale,
  });

  factory StopwordSchema.fromJson(Map<String, dynamic> json) {
    final dynamic stopwordsValue = json['stopwords'];
    if (!json.containsKey('id') && stopwordsValue is Map) {
      return StopwordSchema.fromJson(
          Map<String, dynamic>.from(stopwordsValue));
    }

    return StopwordSchema(
      id: json['id'] as String,
      stopwords: List<String>.from(json['stopwords'] as List),
      locale: json['locale'] as String?,
    );
  }
}

class StopwordsRetrieveSchema {
  final List<StopwordSchema> stopwords;

  StopwordsRetrieveSchema({
    required this.stopwords,
  });

  factory StopwordsRetrieveSchema.fromJson(Map<String, dynamic> json) {
    final items = (json['stopwords'] as List? ?? [])
        .map((item) =>
            StopwordSchema.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
    return StopwordsRetrieveSchema(stopwords: items);
  }
}

class StopwordDeleteSchema {
  final String id;

  StopwordDeleteSchema({required this.id});

  factory StopwordDeleteSchema.fromJson(Map<String, dynamic> json) =>
      StopwordDeleteSchema(id: json['id'] as String);
}
