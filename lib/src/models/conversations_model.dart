part of 'models.dart';

class ConversationModelCreateSchema {
  final String? id;
  final String modelName;
  final String? apiKey;
  final String? systemPrompt;
  final int maxBytes;
  final String? historyCollection;
  final String? accountId;
  final String? url;
  final int? ttl;
  final String? vllmUrl;
  final String? openaiUrl;
  final String? openaiPath;

  ConversationModelCreateSchema({
    this.id,
    required this.modelName,
    this.apiKey,
    this.systemPrompt,
    required this.maxBytes,
    this.historyCollection,
    this.accountId,
    this.url,
    this.ttl,
    this.vllmUrl,
    this.openaiUrl,
    this.openaiPath,
  });

  factory ConversationModelCreateSchema.fromJson(Map<String, dynamic> json) =>
      ConversationModelCreateSchema(
        id: json['id'] as String?,
        modelName: json['model_name'] as String,
        apiKey: json['api_key'] as String?,
        systemPrompt: json['system_prompt'] as String?,
        maxBytes: json['max_bytes'] as int,
        historyCollection: json['history_collection'] as String?,
        accountId: json['account_id'] as String?,
        url: json['url'] as String?,
        ttl: json['ttl'] as int?,
        vllmUrl: json['vllm_url'] as String?,
        openaiUrl: json['openai_url'] as String?,
        openaiPath: json['openai_path'] as String?,
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'model_name': modelName,
        if (apiKey != null) 'api_key': apiKey,
        if (systemPrompt != null) 'system_prompt': systemPrompt,
        'max_bytes': maxBytes,
        if (historyCollection != null) 'history_collection': historyCollection,
        if (accountId != null) 'account_id': accountId,
        if (url != null) 'url': url,
        if (ttl != null) 'ttl': ttl,
        if (vllmUrl != null) 'vllm_url': vllmUrl,
        if (openaiUrl != null) 'openai_url': openaiUrl,
        if (openaiPath != null) 'openai_path': openaiPath,
      };
}

class ConversationModelSchema extends ConversationModelCreateSchema {
  final String id;

  ConversationModelSchema({
    required this.id,
    required super.modelName,
    super.apiKey,
    super.systemPrompt,
    required super.maxBytes,
    super.historyCollection,
    super.accountId,
    super.url,
    super.ttl,
    super.vllmUrl,
    super.openaiUrl,
    super.openaiPath,
  }) : super(id: id);

  factory ConversationModelSchema.fromJson(Map<String, dynamic> json) =>
      ConversationModelSchema(
        id: json['id'] as String,
        modelName: json['model_name'] as String,
        apiKey: json['api_key'] as String?,
        systemPrompt: json['system_prompt'] as String?,
        maxBytes: json['max_bytes'] as int,
        historyCollection: json['history_collection'] as String?,
        accountId: json['account_id'] as String?,
        url: json['url'] as String?,
        ttl: json['ttl'] as int?,
        vllmUrl: json['vllm_url'] as String?,
        openaiUrl: json['openai_url'] as String?,
        openaiPath: json['openai_path'] as String?,
      );
}

class ConversationModelDeleteSchema {
  final String id;

  ConversationModelDeleteSchema({required this.id});

  factory ConversationModelDeleteSchema.fromJson(Map<String, dynamic> json) =>
      ConversationModelDeleteSchema(
        id: json['id'] as String,
      );
}
