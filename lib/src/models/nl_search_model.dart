part of 'models.dart';

class NLSearchModelBase {
  final String modelName;
  final String? apiKey;
  final String? apiUrl;
  final int? maxBytes;
  final double? temperature;
  final String? systemPrompt;
  final double? topP;
  final int? topK;
  final List<String>? stopSequences;
  final String? apiVersion;
  final String? projectId;
  final String? accessToken;
  final String? refreshToken;
  final String? clientId;
  final String? clientSecret;
  final String? region;
  final int? maxOutputTokens;
  final String? accountId;

  NLSearchModelBase({
    required this.modelName,
    this.apiKey,
    this.apiUrl,
    this.maxBytes,
    this.temperature,
    this.systemPrompt,
    this.topP,
    this.topK,
    this.stopSequences,
    this.apiVersion,
    this.projectId,
    this.accessToken,
    this.refreshToken,
    this.clientId,
    this.clientSecret,
    this.region,
    this.maxOutputTokens,
    this.accountId,
  });

  Map<String, dynamic> toJson() => {
        'model_name': modelName,
        if (apiKey != null) 'api_key': apiKey,
        if (apiUrl != null) 'api_url': apiUrl,
        if (maxBytes != null) 'max_bytes': maxBytes,
        if (temperature != null) 'temperature': temperature,
        if (systemPrompt != null) 'system_prompt': systemPrompt,
        if (topP != null) 'top_p': topP,
        if (topK != null) 'top_k': topK,
        if (stopSequences != null) 'stop_sequences': stopSequences,
        if (apiVersion != null) 'api_version': apiVersion,
        if (projectId != null) 'project_id': projectId,
        if (accessToken != null) 'access_token': accessToken,
        if (refreshToken != null) 'refresh_token': refreshToken,
        if (clientId != null) 'client_id': clientId,
        if (clientSecret != null) 'client_secret': clientSecret,
        if (region != null) 'region': region,
        if (maxOutputTokens != null) 'max_output_tokens': maxOutputTokens,
        if (accountId != null) 'account_id': accountId,
      };

  static NLSearchModelBase fromJson(Map<String, dynamic> json) =>
      NLSearchModelBase(
        modelName: json['model_name'] as String,
        apiKey: json['api_key'] as String?,
        apiUrl: json['api_url'] as String?,
        maxBytes: json['max_bytes'] as int?,
        temperature: (json['temperature'] as num?)?.toDouble(),
        systemPrompt: json['system_prompt'] as String?,
        topP: (json['top_p'] as num?)?.toDouble(),
        topK: json['top_k'] as int?,
        stopSequences: (json['stop_sequences'] as List?)?.cast<String>(),
        apiVersion: json['api_version'] as String?,
        projectId: json['project_id'] as String?,
        accessToken: json['access_token'] as String?,
        refreshToken: json['refresh_token'] as String?,
        clientId: json['client_id'] as String?,
        clientSecret: json['client_secret'] as String?,
        region: json['region'] as String?,
        maxOutputTokens: json['max_output_tokens'] as int?,
        accountId: json['account_id'] as String?,
      );
}

class NLSearchModelCreateSchema extends NLSearchModelBase {
  final String? id;

  NLSearchModelCreateSchema({
    this.id,
    required super.modelName,
    super.apiKey,
    super.apiUrl,
    super.maxBytes,
    super.temperature,
    super.systemPrompt,
    super.topP,
    super.topK,
    super.stopSequences,
    super.apiVersion,
    super.projectId,
    super.accessToken,
    super.refreshToken,
    super.clientId,
    super.clientSecret,
    super.region,
    super.maxOutputTokens,
    super.accountId,
  });

  factory NLSearchModelCreateSchema.fromJson(Map<String, dynamic> json) =>
      NLSearchModelCreateSchema(
        id: json['id'] as String?,
        modelName: json['model_name'] as String,
        apiKey: json['api_key'] as String?,
        apiUrl: json['api_url'] as String?,
        maxBytes: json['max_bytes'] as int?,
        temperature: (json['temperature'] as num?)?.toDouble(),
        systemPrompt: json['system_prompt'] as String?,
        topP: (json['top_p'] as num?)?.toDouble(),
        topK: json['top_k'] as int?,
        stopSequences: (json['stop_sequences'] as List?)?.cast<String>(),
        apiVersion: json['api_version'] as String?,
        projectId: json['project_id'] as String?,
        accessToken: json['access_token'] as String?,
        refreshToken: json['refresh_token'] as String?,
        clientId: json['client_id'] as String?,
        clientSecret: json['client_secret'] as String?,
        region: json['region'] as String?,
        maxOutputTokens: json['max_output_tokens'] as int?,
        accountId: json['account_id'] as String?,
      );

  @override
  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        ...super.toJson(),
      };
}

class NLSearchModelSchema extends NLSearchModelBase {
  final String id;

  NLSearchModelSchema({
    required this.id,
    required super.modelName,
    super.apiKey,
    super.apiUrl,
    super.maxBytes,
    super.temperature,
    super.systemPrompt,
    super.topP,
    super.topK,
    super.stopSequences,
    super.apiVersion,
    super.projectId,
    super.accessToken,
    super.refreshToken,
    super.clientId,
    super.clientSecret,
    super.region,
    super.maxOutputTokens,
    super.accountId,
  });

  factory NLSearchModelSchema.fromJson(Map<String, dynamic> json) =>
      NLSearchModelSchema(
        id: json['id'] as String,
        modelName: json['model_name'] as String,
        apiKey: json['api_key'] as String?,
        apiUrl: json['api_url'] as String?,
        maxBytes: json['max_bytes'] as int?,
        temperature: (json['temperature'] as num?)?.toDouble(),
        systemPrompt: json['system_prompt'] as String?,
        topP: (json['top_p'] as num?)?.toDouble(),
        topK: json['top_k'] as int?,
        stopSequences: (json['stop_sequences'] as List?)?.cast<String>(),
        apiVersion: json['api_version'] as String?,
        projectId: json['project_id'] as String?,
        accessToken: json['access_token'] as String?,
        refreshToken: json['refresh_token'] as String?,
        clientId: json['client_id'] as String?,
        clientSecret: json['client_secret'] as String?,
        region: json['region'] as String?,
        maxOutputTokens: json['max_output_tokens'] as int?,
        accountId: json['account_id'] as String?,
      );
}

class NLSearchModelUpdateSchema extends NLSearchModelBase {
  NLSearchModelUpdateSchema({
    required super.modelName,
    super.apiKey,
    super.apiUrl,
    super.maxBytes,
    super.temperature,
    super.systemPrompt,
    super.topP,
    super.topK,
    super.stopSequences,
    super.apiVersion,
    super.projectId,
    super.accessToken,
    super.refreshToken,
    super.clientId,
    super.clientSecret,
    super.region,
    super.maxOutputTokens,
    super.accountId,
  });

  factory NLSearchModelUpdateSchema.fromJson(Map<String, dynamic> json) =>
      NLSearchModelUpdateSchema(
        modelName: json['model_name'] as String? ?? '',
        apiKey: json['api_key'] as String?,
        apiUrl: json['api_url'] as String?,
        maxBytes: json['max_bytes'] as int?,
        temperature: (json['temperature'] as num?)?.toDouble(),
        systemPrompt: json['system_prompt'] as String?,
        topP: (json['top_p'] as num?)?.toDouble(),
        topK: json['top_k'] as int?,
        stopSequences: (json['stop_sequences'] as List?)?.cast<String>(),
        apiVersion: json['api_version'] as String?,
        projectId: json['project_id'] as String?,
        accessToken: json['access_token'] as String?,
        refreshToken: json['refresh_token'] as String?,
        clientId: json['client_id'] as String?,
        clientSecret: json['client_secret'] as String?,
        region: json['region'] as String?,
        maxOutputTokens: json['max_output_tokens'] as int?,
        accountId: json['account_id'] as String?,
      );
}

class NLSearchModelDeleteSchema {
  final String id;

  NLSearchModelDeleteSchema({required this.id});

  factory NLSearchModelDeleteSchema.fromJson(Map<String, dynamic> json) =>
      NLSearchModelDeleteSchema(
        id: json['id'] as String,
      );
}
