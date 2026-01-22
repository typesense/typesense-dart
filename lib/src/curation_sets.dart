import 'models/models.dart';
import 'services/api_call.dart';
import 'curation_set.dart';

class CurationSets {
  final ApiCall _apiCall;
  static const String resourcepath = '/curation_sets';

  CurationSets(ApiCall apiCall) : _apiCall = apiCall;

  /// Retrieves all curation sets.
  Future<List<CurationSetsListEntrySchema>> retrieve() async {
    final response = await _apiCall.getList(resourcepath);
    return response
        .map((item) =>
            CurationSetsListEntrySchema.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  CurationSet operator [](String name) => CurationSet(name, _apiCall);
}
