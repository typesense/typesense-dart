import 'models/models.dart';
import 'services/api_call.dart';
import 'curation_sets.dart';
import 'curation_set_items.dart';
import 'curation_set_item.dart';

class CurationSet {
  final String _name;
  final ApiCall _apiCall;
  final CurationSetItems _items;
  final _individualItems = <String, CurationSetItem>{};

  CurationSet(String name, ApiCall apiCall)
      : _name = name,
        _apiCall = apiCall,
        _items = CurationSetItems(name, apiCall);

  Future<CurationSetSchema> upsert(CurationSetUpsertSchema params) async {
    final response = await _apiCall.put(
      _endpointPath,
      bodyParameters: params.toJson(),
    );
    return CurationSetSchema.fromJson(Map<String, dynamic>.from(response));
  }

  Future<CurationSetSchema> retrieve() async {
    final response = await _apiCall.get(_endpointPath);
    return CurationSetSchema.fromJson(Map<String, dynamic>.from(response));
  }

  Future<CurationSetDeleteResponseSchema> delete() async {
    final response = await _apiCall.delete(_endpointPath);
    return CurationSetDeleteResponseSchema.fromJson(
      Map<String, dynamic>.from(response),
    );
  }

  CurationSetItems items() => _items;

  CurationSetItem item(String itemId) {
    if (!_individualItems.containsKey(itemId)) {
      _individualItems[itemId] = CurationSetItem(_name, itemId, _apiCall);
    }
    return _individualItems[itemId]!;
  }

  /// Retrieves items in the curation set with optional pagination.
  Future<List<CurationObjectSchema>> listItems({
    int? limit,
    int? offset,
  }) async {
    return _items.retrieve(limit: limit, offset: offset);
  }

  /// Retrieves a single curation set item by [itemId].
  Future<CurationObjectSchema> getItem(String itemId) async {
    return item(itemId).retrieve();
  }

  /// Creates/updates a curation set item by [itemId].
  Future<CurationObjectSchema> upsertItem(
      String itemId, CurationObjectSchema params) async {
    return item(itemId).upsert(params);
  }

  /// Deletes a curation set item by [itemId].
  Future<CurationItemDeleteResponseSchema> deleteItem(String itemId) async {
    return item(itemId).delete();
  }

  String get _endpointPath =>
      '${CurationSets.resourcepath}/${Uri.encodeComponent(_name)}';
}
