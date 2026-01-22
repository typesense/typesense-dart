part of 'models.dart';

class AnalyticsEventCreateSchema {
  final String? type;
  final String name;
  final Map<String, dynamic> data;

  AnalyticsEventCreateSchema({
    this.type,
    required this.name,
    required this.data,
  });

  Map<String, dynamic> toJson() => {
        if (type != null) 'type': type,
        'name': name,
        'data': data,
      };
}

class AnalyticsEventItemSchema {
  final String name;
  final String? eventType;
  final String? collection;
  final int? timestamp;
  final String? userId;
  final String? docId;
  final List<String>? docIds;
  final String? query;

  AnalyticsEventItemSchema({
    required this.name,
    this.eventType,
    this.collection,
    this.timestamp,
    this.userId,
    this.docId,
    this.docIds,
    this.query,
  });

  factory AnalyticsEventItemSchema.fromJson(Map<String, dynamic> json) =>
      AnalyticsEventItemSchema(
        name: json['name'] as String,
        eventType: json['event_type'] as String?,
        collection: json['collection'] as String?,
        timestamp: json['timestamp'] as int?,
        userId: json['user_id'] as String?,
        docId: json['doc_id'] as String?,
        docIds: (json['doc_ids'] as List?)?.cast<String>(),
        query: json['query'] as String?,
      );
}

class AnalyticsEventsRetrieveSchema {
  final List<AnalyticsEventItemSchema> events;

  AnalyticsEventsRetrieveSchema({required this.events});

  factory AnalyticsEventsRetrieveSchema.fromJson(Map<String, dynamic> json) =>
      AnalyticsEventsRetrieveSchema(
        events: (json['events'] as List? ?? [])
            .map((item) =>
                AnalyticsEventItemSchema.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList(),
      );
}

class AnalyticsEventCreateResponse {
  final bool ok;

  AnalyticsEventCreateResponse({required this.ok});

  factory AnalyticsEventCreateResponse.fromJson(Map<String, dynamic> json) =>
      AnalyticsEventCreateResponse(
        ok: json['ok'] as bool,
      );
}

class AnalyticsStatus {
  final int? popularPrefixQueries;
  final int? nohitsPrefixQueries;
  final int? logPrefixQueries;
  final int? queryLogEvents;
  final int? queryCounterEvents;
  final int? docLogEvents;
  final int? docCounterEvents;

  AnalyticsStatus({
    this.popularPrefixQueries,
    this.nohitsPrefixQueries,
    this.logPrefixQueries,
    this.queryLogEvents,
    this.queryCounterEvents,
    this.docLogEvents,
    this.docCounterEvents,
  });

  factory AnalyticsStatus.fromJson(Map<String, dynamic> json) => AnalyticsStatus(
        popularPrefixQueries: json['popular_prefix_queries'] as int?,
        nohitsPrefixQueries: json['nohits_prefix_queries'] as int?,
        logPrefixQueries: json['log_prefix_queries'] as int?,
        queryLogEvents: json['query_log_events'] as int?,
        queryCounterEvents: json['query_counter_events'] as int?,
        docLogEvents: json['doc_log_events'] as int?,
        docCounterEvents: json['doc_counter_events'] as int?,
      );
}

class AnalyticsRuleParams {
  final String? destinationCollection;
  final int? limit;
  final bool? captureSearchRequests;
  final List<String>? metaFields;
  final bool? expandQuery;
  final String? counterField;
  final int? weight;

  AnalyticsRuleParams({
    this.destinationCollection,
    this.limit,
    this.captureSearchRequests,
    this.metaFields,
    this.expandQuery,
    this.counterField,
    this.weight,
  });

  Map<String, dynamic> toJson() => {
        if (destinationCollection != null)
          'destination_collection': destinationCollection,
        if (limit != null) 'limit': limit,
        if (captureSearchRequests != null)
          'capture_search_requests': captureSearchRequests,
        if (metaFields != null) 'meta_fields': metaFields,
        if (expandQuery != null) 'expand_query': expandQuery,
        if (counterField != null) 'counter_field': counterField,
        if (weight != null) 'weight': weight,
      };

  factory AnalyticsRuleParams.fromJson(Map<String, dynamic> json) =>
      AnalyticsRuleParams(
        destinationCollection: json['destination_collection'] as String?,
        limit: json['limit'] as int?,
        captureSearchRequests: json['capture_search_requests'] as bool?,
        metaFields: (json['meta_fields'] as List?)?.cast<String>(),
        expandQuery: json['expand_query'] as bool?,
        counterField: json['counter_field'] as String?,
        weight: json['weight'] as int?,
      );
}

class AnalyticsRuleCreateSchema {
  final String name;
  final String type;
  final String collection;
  final String eventType;
  final String? ruleTag;
  final AnalyticsRuleParams? params;

  AnalyticsRuleCreateSchema({
    required this.name,
    required this.type,
    required this.collection,
    required this.eventType,
    this.ruleTag,
    this.params,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'collection': collection,
        'event_type': eventType,
        if (ruleTag != null) 'rule_tag': ruleTag,
        if (params != null) 'params': params!.toJson(),
      };

  factory AnalyticsRuleCreateSchema.fromJson(Map<String, dynamic> json) =>
      AnalyticsRuleCreateSchema(
        name: json['name'] as String,
        type: json['type'] as String,
        collection: json['collection'] as String,
        eventType: json['event_type'] as String,
        ruleTag: json['rule_tag'] as String?,
        params: json['params'] == null
            ? null
            : AnalyticsRuleParams.fromJson(
                Map<String, dynamic>.from(json['params'] as Map)),
      );
}

class AnalyticsRuleUpsertSchema {
  final String? name;
  final String? type;
  final String? collection;
  final String? eventType;
  final String? ruleTag;
  final AnalyticsRuleParams? params;

  AnalyticsRuleUpsertSchema({
    this.name,
    this.type,
    this.collection,
    this.eventType,
    this.ruleTag,
    this.params,
  });

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        if (type != null) 'type': type,
        if (collection != null) 'collection': collection,
        if (eventType != null) 'event_type': eventType,
        if (ruleTag != null) 'rule_tag': ruleTag,
        if (params != null) 'params': params!.toJson(),
      };
}

class AnalyticsRuleSchema extends AnalyticsRuleCreateSchema {
  AnalyticsRuleSchema({
    required super.name,
    required super.type,
    required super.collection,
    required super.eventType,
    super.ruleTag,
    super.params,
  });

  factory AnalyticsRuleSchema.fromJson(Map<String, dynamic> json) =>
      AnalyticsRuleSchema(
        name: json['name'] as String,
        type: json['type'] as String,
        collection: json['collection'] as String,
        eventType: json['event_type'] as String,
        ruleTag: json['rule_tag'] as String?,
        params: json['params'] == null
            ? null
            : AnalyticsRuleParams.fromJson(
                Map<String, dynamic>.from(json['params'] as Map)),
      );
}

class AnalyticsRuleDeleteSchema {
  final String name;

  AnalyticsRuleDeleteSchema({required this.name});

  factory AnalyticsRuleDeleteSchema.fromJson(Map<String, dynamic> json) =>
      AnalyticsRuleDeleteSchema(
        name: json['name'] as String,
      );
}

class AnalyticsRulesRetrieveSchema {
  final List<AnalyticsRuleSchema> rules;

  AnalyticsRulesRetrieveSchema({required this.rules});

  factory AnalyticsRulesRetrieveSchema.fromJson(Map<String, dynamic> json) =>
      AnalyticsRulesRetrieveSchema(
        rules: (json['rules'] as List? ?? [])
            .map((item) =>
                AnalyticsRuleSchema.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList(),
      );
}
