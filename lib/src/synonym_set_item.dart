import 'models/models.dart';
import 'services/api_call.dart';
import 'synonym_sets.dart';

class SynonymSetItem {
  final String _synonymSetName;
  final String _itemId;
  final ApiCall _apiCall;

  SynonymSetItem(String synonymSetName, String itemId, ApiCall apiCall)
      : _synonymSetName = synonymSetName,
        _itemId = itemId,
        _apiCall = apiCall;

  Future<SynonymItemSchema> retrieve() async {
    final response = await _apiCall.get(_endpointPath);
    return SynonymItemSchema.fromJson(response);
  }

  Future<SynonymItemSchema> upsert(SynonymItemSchema params) async {
    final response = await _apiCall.put(
      _endpointPath,
      bodyParameters: params.toJson(),
    );
    return SynonymItemSchema.fromJson(response);
  }

  Future<SynonymItemDeleteSchema> delete() async {
    final response = await _apiCall.delete(_endpointPath);
    return SynonymItemDeleteSchema.fromJson(response);
  }

  String get _endpointPath =>
      '${SynonymSets.resourcepath}/${Uri.encodeComponent(_synonymSetName)}/items/${Uri.encodeComponent(_itemId)}';
}
