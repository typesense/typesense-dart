import 'services/api_call.dart';
import 'aliases.dart';

class Alias {
  final String name;
  final ApiCall _apiCall;

  const Alias(this.name, ApiCall apiCall) : _apiCall = apiCall;

  /// Deletes an alias.
  Future<Map<String, dynamic>> delete() async {
    return await _apiCall.delete(
      '${Aliases.resourcepath}/$name',
    );
  }

  /// Retrieves an alias.
  Future<Map<String, dynamic>> retrieve() async {
    return await _apiCall.get(
      '${Aliases.resourcepath}/$name',
    );
  }
}
