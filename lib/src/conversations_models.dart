import 'models/models.dart';
import 'services/api_call.dart';
import 'conversation_model.dart';

class ConversationsModels {
  final ApiCall _apiCall;
  static const String resourcepath = '/conversations/models';
  final _individualModels = <String, ConversationModel>{};

  ConversationsModels(ApiCall apiCall) : _apiCall = apiCall;

  Future<ConversationModelCreateSchema> create(
      ConversationModelCreateSchema params) async {
    final response =
        await _apiCall.post(resourcepath, bodyParameters: params.toJson());
    return ConversationModelCreateSchema.fromJson(response);
  }

  Future<List<ConversationModelSchema>> retrieve() async {
    final response = await _apiCall.getList(resourcepath);
    return response
        .map((item) =>
            ConversationModelSchema.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  ConversationModel operator [](String modelId) {
    if (!_individualModels.containsKey(modelId)) {
      _individualModels[modelId] = ConversationModel(modelId, _apiCall);
    }
    return _individualModels[modelId]!;
  }
}
