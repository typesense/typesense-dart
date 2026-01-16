import 'models/models.dart';
import 'services/api_call.dart';
import 'curation_sets.dart';

class CurationSetItem {
  final String _name;
  final String _itemId;
  final ApiCall _apiCall;

  CurationSetItem(String name, String itemId, ApiCall apiCall)
      : _name = name,
        _itemId = itemId,
        _apiCall = apiCall;

  Future<CurationObjectSchema> retrieve() async {
    final response = await _apiCall.get(_endpointPath);
    return CurationObjectSchema.fromJson(Map<String, dynamic>.from(response));
  }

  Future<CurationObjectSchema> upsert(CurationObjectSchema params) async {
    final response = await _apiCall.put(
      _endpointPath,
      bodyParameters: params.toJson(),
    );
    return CurationObjectSchema.fromJson(Map<String, dynamic>.from(response));
  }

  Future<CurationItemDeleteResponseSchema> delete() async {
    final response = await _apiCall.delete(_endpointPath);
    return CurationItemDeleteResponseSchema.fromJson(
      Map<String, dynamic>.from(response),
    );
  }

  String get _endpointPath =>
      '${CurationSets.resourcepath}/${Uri.encodeComponent(_name)}/items/${Uri.encodeComponent(_itemId)}';
}
