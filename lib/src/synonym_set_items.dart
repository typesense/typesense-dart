import 'models/models.dart';
import 'services/api_call.dart';
import 'synonym_sets.dart';

class SynonymSetItems {
  final String _synonymSetName;
  final ApiCall _apiCall;

  SynonymSetItems(String synonymSetName, ApiCall apiCall)
      : _synonymSetName = synonymSetName,
        _apiCall = apiCall;

  Future<List<SynonymItemSchema>> retrieve({
    int? limit,
    int? offset,
  }) async {
    final query = <String, String>{};
    if (limit != null) {
      query['limit'] = limit.toString();
    }
    if (offset != null) {
      query['offset'] = offset.toString();
    }
    final response = await _apiCall.getList(
      _endpointPath,
      queryParams: query.isEmpty ? null : query,
    );
    return response
        .map((item) =>
            SynonymItemSchema.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  String get _endpointPath =>
      '${SynonymSets.resourcepath}/${Uri.encodeComponent(_synonymSetName)}/items';
}
