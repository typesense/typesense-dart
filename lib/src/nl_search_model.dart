import 'models/models.dart';
import 'services/api_call.dart';
import 'nl_search_models.dart';

class NLSearchModel {
  final String _id;
  final ApiCall _apiCall;

  NLSearchModel(String id, ApiCall apiCall)
      : _id = id,
        _apiCall = apiCall;

  Future<NLSearchModelSchema> retrieve() async {
    final response = await _apiCall.get(_endpointPath);
    return NLSearchModelSchema.fromJson(response);
  }

  Future<NLSearchModelSchema> update(NLSearchModelUpdateSchema schema) async {
    final response =
        await _apiCall.put(_endpointPath, bodyParameters: schema.toJson());
    return NLSearchModelSchema.fromJson(response);
  }

  Future<NLSearchModelDeleteSchema> delete() async {
    final response = await _apiCall.delete(_endpointPath);
    return NLSearchModelDeleteSchema.fromJson(response);
  }

  String get _endpointPath =>
      '${NLSearchModels.resourcepath}/${Uri.encodeComponent(_id)}';
}
