part of 'models.dart';

class ConversationSchema {
  final int id;
  final List<dynamic> conversation;
  final int lastUpdated;
  final int ttl;

  ConversationSchema({
    required this.id,
    required this.conversation,
    required this.lastUpdated,
    required this.ttl,
  });

  factory ConversationSchema.fromJson(Map<String, dynamic> json) =>
      ConversationSchema(
        id: json['id'] as int,
        conversation: (json['conversation'] as List? ?? []).cast<dynamic>(),
        lastUpdated: json['last_updated'] as int,
        ttl: json['ttl'] as int,
      );
}

class ConversationUpdateSchema {
  final int ttl;

  ConversationUpdateSchema({required this.ttl});

  Map<String, dynamic> toJson() => {
        'ttl': ttl,
      };

  factory ConversationUpdateSchema.fromJson(Map<String, dynamic> json) =>
      ConversationUpdateSchema(
        ttl: json['ttl'] as int,
      );
}

class ConversationDeleteSchema {
  final int id;

  ConversationDeleteSchema({required this.id});

  factory ConversationDeleteSchema.fromJson(Map<String, dynamic> json) =>
      ConversationDeleteSchema(
        id: json['id'] as int,
      );
}

class ConversationsRetrieveSchema {
  final List<ConversationSchema> conversations;

  ConversationsRetrieveSchema({required this.conversations});

  factory ConversationsRetrieveSchema.fromJson(Map<String, dynamic> json) =>
      ConversationsRetrieveSchema(
        conversations: (json['conversations'] as List? ?? [])
            .map((item) =>
                ConversationSchema.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList(),
      );
}
