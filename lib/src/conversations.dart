import 'models/models.dart';
import 'services/api_call.dart';
import 'conversations_models.dart';
import 'conversation_model.dart';

class Conversations {
  final ApiCall _apiCall;
  static const String resourcepath = '/conversations';
  final ConversationsModels _models;
  final _individualModels = <String, ConversationModel>{};

  Conversations(ApiCall apiCall)
      : _apiCall = apiCall,
        _models = ConversationsModels(apiCall);

  Future<ConversationsRetrieveSchema> retrieve() async {
    final response = await _apiCall.get(resourcepath);
    return ConversationsRetrieveSchema.fromJson(response);
  }

  ConversationsModels models() => _models;

  ConversationModel model(String id) {
    if (!_individualModels.containsKey(id)) {
      _individualModels[id] = ConversationModel(id, _apiCall);
    }
    return _individualModels[id]!;
  }
}
