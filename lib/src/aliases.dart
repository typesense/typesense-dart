import 'package:typesense/src/services/api_call.dart';

class Aliases {
  final ApiCall _apiCall;
  static const String RESOURCEPATH = '/aliases';

  Aliases(ApiCall apicall) : _apiCall = apicall;

  /// Creates/updates an alias corresponding to [aliasName].
  Future<Map<String, dynamic>> upsert(
      String aliasName, Map<String, String> mapping) async {
    return await _apiCall.put(
      '$RESOURCEPATH/$aliasName',
      bodyParameters: mapping,
    );
  }

  /// Retrieves all aliases and the corresponding collections that they map to.
  Future<Map<String, dynamic>> retrieve() async {
    return await _apiCall.get(RESOURCEPATH);
  }
}
