import 'models/models.dart';
import 'services/api_call.dart';
import 'curation_sets.dart';

class CurationSetItems {
  final String _name;
  final ApiCall _apiCall;

  CurationSetItems(String name, ApiCall apiCall)
      : _name = name,
        _apiCall = apiCall;

  Future<List<CurationObjectSchema>> retrieve({
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
            CurationObjectSchema.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  String get _endpointPath =>
      '${CurationSets.resourcepath}/${Uri.encodeComponent(_name)}/items';
}
