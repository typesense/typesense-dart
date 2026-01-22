import 'models/models.dart';
import 'services/api_call.dart';
import 'synonym_set.dart';

class SynonymSets {
  final ApiCall _apiCall;
  static const String resourcepath = '/synonym_sets';

  SynonymSets(ApiCall apiCall) : _apiCall = apiCall;

  /// Retrieves all synonym sets.
  Future<List<SynonymSetSchema>> retrieve() async {
    final response = await _apiCall.getList(resourcepath);
    return response
        .map((item) =>
            SynonymSetSchema.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  SynonymSet operator [](String synonymSetName) =>
      SynonymSet(synonymSetName, _apiCall);
}
