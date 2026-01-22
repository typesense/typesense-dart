part of 'models.dart';

class CurationIncludeSchema {
  final String id;
  final int position;

  CurationIncludeSchema({
    required this.id,
    required this.position,
  });

  factory CurationIncludeSchema.fromJson(Map<String, dynamic> json) =>
      CurationIncludeSchema(
        id: json['id'] as String,
        position: json['position'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'position': position,
      };
}

class CurationExcludeSchema {
  final String id;

  CurationExcludeSchema({required this.id});

  factory CurationExcludeSchema.fromJson(Map<String, dynamic> json) =>
      CurationExcludeSchema(
        id: json['id'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
      };
}

class CurationRuleSchema {
  final String? query;
  final String? match;
  final String? filterBy;
  final List<String>? tags;
  final bool? synonyms;
  final bool? stem;
  final String? stemmingDictionary;

  CurationRuleSchema({
    this.query,
    this.match,
    this.filterBy,
    this.tags,
    this.synonyms,
    this.stem,
    this.stemmingDictionary,
  });

  factory CurationRuleSchema.fromJson(Map<String, dynamic> json) =>
      CurationRuleSchema(
        query: json['query'] as String?,
        match: json['match'] as String?,
        filterBy: json['filter_by'] as String?,
        tags: (json['tags'] as List?)?.cast<String>(),
        synonyms: json['synonyms'] as bool?,
        stem: json['stem'] as bool?,
        stemmingDictionary: json['stemming_dictionary'] as String?,
      );

  Map<String, dynamic> toJson() => {
        if (query != null) 'query': query,
        if (match != null) 'match': match,
        if (filterBy != null) 'filter_by': filterBy,
        if (tags != null) 'tags': tags,
        if (synonyms != null) 'synonyms': synonyms,
        if (stem != null) 'stem': stem,
        if (stemmingDictionary != null)
          'stemming_dictionary': stemmingDictionary,
      };
}

class CurationDiversitySimilarityMetricSchema {
  final String field;
  final String method;
  final double weight;

  CurationDiversitySimilarityMetricSchema({
    required this.field,
    required this.method,
    required this.weight,
  });

  factory CurationDiversitySimilarityMetricSchema.fromJson(
          Map<String, dynamic> json) =>
      CurationDiversitySimilarityMetricSchema(
        field: json['field'] as String,
        method: json['method'] as String,
        weight: (json['weight'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'field': field,
        'method': method,
        'weight': weight,
      };
}

class CurationDiversitySchema {
  final List<CurationDiversitySimilarityMetricSchema> similarityMetric;

  CurationDiversitySchema({required this.similarityMetric});

  factory CurationDiversitySchema.fromJson(Map<String, dynamic> json) =>
      CurationDiversitySchema(
        similarityMetric: (json['similarity_metric'] as List? ?? [])
            .map((item) => CurationDiversitySimilarityMetricSchema.fromJson(
                Map<String, dynamic>.from(item as Map)))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'similarity_metric':
            similarityMetric.map((metric) => metric.toJson()).toList(),
      };
}

class CurationObjectSchema {
  final String id;
  final CurationRuleSchema? rule;
  final List<CurationIncludeSchema>? includes;
  final List<CurationExcludeSchema>? excludes;
  final String? filterBy;
  final String? sortBy;
  final String? replaceQuery;
  final bool? removeMatchedTokens;
  final bool? filterCuratedHits;
  final int? effectiveFromTs;
  final int? effectiveToTs;
  final bool? stopProcessing;
  final CurationDiversitySchema? diversity;
  final Map<String, dynamic>? metadata;

  CurationObjectSchema({
    required this.id,
    this.rule,
    this.includes,
    this.excludes,
    this.filterBy,
    this.sortBy,
    this.replaceQuery,
    this.removeMatchedTokens,
    this.filterCuratedHits,
    this.effectiveFromTs,
    this.effectiveToTs,
    this.stopProcessing,
    this.diversity,
    this.metadata,
  });

  factory CurationObjectSchema.fromJson(Map<String, dynamic> json) =>
      CurationObjectSchema(
        id: json['id'] as String,
        rule: json['rule'] == null
            ? null
            : CurationRuleSchema.fromJson(
                Map<String, dynamic>.from(json['rule'] as Map),
              ),
        includes: (json['includes'] as List?)
            ?.map((item) => CurationIncludeSchema.fromJson(
                Map<String, dynamic>.from(item as Map)))
            .toList(),
        excludes: (json['excludes'] as List?)
            ?.map((item) => CurationExcludeSchema.fromJson(
                Map<String, dynamic>.from(item as Map)))
            .toList(),
        filterBy: json['filter_by'] as String?,
        sortBy: json['sort_by'] as String?,
        replaceQuery: json['replace_query'] as String?,
        removeMatchedTokens: json['remove_matched_tokens'] as bool?,
        filterCuratedHits: json['filter_curated_hits'] as bool?,
        effectiveFromTs: json['effective_from_ts'] as int?,
        effectiveToTs: json['effective_to_ts'] as int?,
        stopProcessing: json['stop_processing'] as bool?,
        diversity: json['diversity'] == null
            ? null
            : CurationDiversitySchema.fromJson(
                Map<String, dynamic>.from(json['diversity'] as Map),
              ),
        metadata: (json['metadata'] as Map?)?.cast<String, dynamic>(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        if (rule != null) 'rule': rule!.toJson(),
        if (includes != null) 'includes': includes!.map((e) => e.toJson()).toList(),
        if (excludes != null) 'excludes': excludes!.map((e) => e.toJson()).toList(),
        if (filterBy != null) 'filter_by': filterBy,
        if (sortBy != null) 'sort_by': sortBy,
        if (replaceQuery != null) 'replace_query': replaceQuery,
        if (removeMatchedTokens != null)
          'remove_matched_tokens': removeMatchedTokens,
        if (filterCuratedHits != null) 'filter_curated_hits': filterCuratedHits,
        if (effectiveFromTs != null) 'effective_from_ts': effectiveFromTs,
        if (effectiveToTs != null) 'effective_to_ts': effectiveToTs,
        if (stopProcessing != null) 'stop_processing': stopProcessing,
        if (diversity != null) 'diversity': diversity!.toJson(),
        if (metadata != null) 'metadata': metadata,
      };
}

class CurationSetUpsertSchema {
  final List<CurationObjectSchema> items;

  CurationSetUpsertSchema({required this.items});

  Map<String, dynamic> toJson() => {
        'items': items.map((e) => e.toJson()).toList(),
      };
}

class CurationSetSchema {
  final String? name;
  final List<CurationObjectSchema> items;

  CurationSetSchema({
    this.name,
    required this.items,
  });

  factory CurationSetSchema.fromJson(Map<String, dynamic> json) =>
      CurationSetSchema(
        name: json['name'] as String?,
        items: (json['items'] as List? ?? [])
            .map((item) =>
                CurationObjectSchema.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList(),
      );
}

class CurationSetsListEntrySchema {
  final String name;
  final List<CurationObjectSchema> items;

  CurationSetsListEntrySchema({
    required this.name,
    required this.items,
  });

  factory CurationSetsListEntrySchema.fromJson(Map<String, dynamic> json) =>
      CurationSetsListEntrySchema(
        name: json['name'] as String,
        items: (json['items'] as List? ?? [])
            .map((item) =>
                CurationObjectSchema.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList(),
      );
}

class CurationSetDeleteResponseSchema {
  final String name;

  CurationSetDeleteResponseSchema({required this.name});

  factory CurationSetDeleteResponseSchema.fromJson(Map<String, dynamic> json) =>
      CurationSetDeleteResponseSchema(
        name: json['name'] as String,
      );
}

class CurationItemDeleteResponseSchema {
  final String id;

  CurationItemDeleteResponseSchema({required this.id});

  factory CurationItemDeleteResponseSchema.fromJson(Map<String, dynamic> json) =>
      CurationItemDeleteResponseSchema(
        id: json['id'] as String,
      );
}
