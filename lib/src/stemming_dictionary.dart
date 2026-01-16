import 'models/models.dart';
import 'services/api_call.dart';
import 'stemming_dictionaries.dart';

class StemmingDictionary {
  final String _id;
  final ApiCall _apiCall;

  StemmingDictionary(String id, ApiCall apiCall)
      : _id = id,
        _apiCall = apiCall;

  Future<StemmingDictionarySchema> retrieve() async {
    final response = await _apiCall.get(_endpointPath);
    return StemmingDictionarySchema.fromJson(response);
  }

  String get _endpointPath =>
      '${StemmingDictionaries.resourcepath}/${Uri.encodeComponent(_id)}';
}
