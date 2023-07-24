import 'services/api_call.dart';

class Presets {
  final ApiCall _apiCall;
  static const resourcepath = '/presets';

  Presets(ApiCall apiCall) : _apiCall = apiCall;

  /// Creates/updates a preset corresponding to [presetName].
  Future<Map<String, dynamic>> upsert(
      String presetName, Map<String, dynamic> mapping) async {
    return await _apiCall.put(
      '$resourcepath/$presetName',
      bodyParameters: mapping,
    );
  }

  /// Retrieves all aliases and the corresponding collections that they map to.
  Future<Map<String, dynamic>> retrieve() async {
    return await _apiCall.get(resourcepath);
  }
}
