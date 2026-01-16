import 'models/models.dart';
import 'services/api_call.dart';
import 'conversations_models.dart';

class ConversationModel {
  final String _id;
  final ApiCall _apiCall;

  ConversationModel(String id, ApiCall apiCall)
      : _id = id,
        _apiCall = apiCall;

  Future<ConversationModelCreateSchema> update(
      ConversationModelCreateSchema params) async {
    final response =
        await _apiCall.put(_endpointPath, bodyParameters: params.toJson());
    return ConversationModelCreateSchema.fromJson(response);
  }

  Future<ConversationModelSchema> retrieve() async {
    final response = await _apiCall.get(_endpointPath);
    return ConversationModelSchema.fromJson(response);
  }

  Future<ConversationModelDeleteSchema> delete() async {
    final response = await _apiCall.delete(_endpointPath);
    return ConversationModelDeleteSchema.fromJson(response);
  }

  String get _endpointPath =>
      '${ConversationsModels.resourcepath}/${Uri.encodeComponent(_id)}';
}
