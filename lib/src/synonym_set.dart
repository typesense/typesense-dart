import 'models/models.dart';
import 'services/api_call.dart';
import 'synonym_sets.dart';
import 'synonym_set_items.dart';
import 'synonym_set_item.dart';

class SynonymSet {
  final String _name;
  final ApiCall _apiCall;
  final SynonymSetItems _items;
  final _individualItems = <String, SynonymSetItem>{};

  SynonymSet(String name, ApiCall apiCall)
      : _name = name,
        _apiCall = apiCall,
        _items = SynonymSetItems(name, apiCall);

  Future<SynonymSetRetrieveSchema> retrieve() async {
    final response = await _apiCall.get(_endpointPath);
    return SynonymSetRetrieveSchema.fromJson(response);
  }

  Future<SynonymSetCreateSchema> upsert(SynonymSetCreateSchema params) async {
    final response = await _apiCall.put(
      _endpointPath,
      bodyParameters: params.toJson(),
    );
    return SynonymSetCreateSchema.fromJson(response);
  }

  Future<SynonymSetDeleteSchema> delete() async {
    final response = await _apiCall.delete(_endpointPath);
    return SynonymSetDeleteSchema.fromJson(response);
  }

  SynonymSetItems items() => _items;

  SynonymSetItem item(String itemId) {
    if (!_individualItems.containsKey(itemId)) {
      _individualItems[itemId] = SynonymSetItem(_name, itemId, _apiCall);
    }
    return _individualItems[itemId]!;
  }

  /// Retrieves items in the synonym set with optional pagination.
  Future<List<SynonymItemSchema>> listItems({
    int? limit,
    int? offset,
  }) async {
    return _items.retrieve(limit: limit, offset: offset);
  }

  /// Retrieves a single synonym item by [itemId].
  Future<SynonymItemSchema> getItem(String itemId) async {
    return item(itemId).retrieve();
  }

  /// Creates/updates a synonym item by [itemId].
  Future<SynonymItemSchema> upsertItem(
      String itemId, SynonymItemSchema params) async {
    return item(itemId).upsert(params);
  }

  /// Deletes a synonym item by [itemId].
  Future<SynonymItemDeleteSchema> deleteItem(String itemId) async {
    return item(itemId).delete();
  }

  String get _endpointPath =>
      '${SynonymSets.resourcepath}/${Uri.encodeComponent(_name)}';
}
