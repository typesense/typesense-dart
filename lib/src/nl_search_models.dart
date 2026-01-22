import 'models/models.dart';
import 'services/api_call.dart';
import 'nl_search_model.dart';

class NLSearchModels {
  final ApiCall _apiCall;
  static const String resourcepath = '/nl_search_models';
  final _individualModels = <String, NLSearchModel>{};

  NLSearchModels(ApiCall apiCall) : _apiCall = apiCall;

  Future<NLSearchModelSchema> create(NLSearchModelCreateSchema schema) async {
    final response =
        await _apiCall.post(resourcepath, bodyParameters: schema.toJson());
    return NLSearchModelSchema.fromJson(response);
  }

  Future<List<NLSearchModelSchema>> retrieve() async {
    final response = await _apiCall.getList(resourcepath);
    return response
        .map((item) =>
            NLSearchModelSchema.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  NLSearchModel operator [](String modelId) {
    if (!_individualModels.containsKey(modelId)) {
      _individualModels[modelId] = NLSearchModel(modelId, _apiCall);
    }
    return _individualModels[modelId]!;
  }
}
