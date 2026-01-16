import 'models/models.dart';
import 'services/api_call.dart';
import 'conversations.dart';

class Conversation {
  final String _id;
  final ApiCall _apiCall;

  Conversation(String id, ApiCall apiCall)
      : _id = id,
        _apiCall = apiCall;

  Future<List<ConversationSchema>> retrieve() async {
    final response = await _apiCall.getList(_endpointPath);
    return response
        .map((item) =>
            ConversationSchema.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<ConversationUpdateSchema> update(
      ConversationUpdateSchema params) async {
    final response =
        await _apiCall.put(_endpointPath, bodyParameters: params.toJson());
    return ConversationUpdateSchema.fromJson(response);
  }

  Future<ConversationDeleteSchema> delete() async {
    final response = await _apiCall.delete(_endpointPath);
    return ConversationDeleteSchema.fromJson(response);
  }

  String get _endpointPath =>
      '${Conversations.resourcepath}/${Uri.encodeComponent(_id)}';
}
