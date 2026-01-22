import 'models/models.dart';
import 'services/api_call.dart';
import 'stopwords.dart';

class Stopword {
  final String id;
  final ApiCall _apiCall;

  const Stopword(this.id, ApiCall apiCall) : _apiCall = apiCall;

  /// Retrieves a stopwords set.
  Future<StopwordSchema> retrieve() async {
    final response = await _apiCall.get(
      '${Stopwords.resourcepath}/$id',
    );
    return StopwordSchema.fromJson(response);
  }

  /// Deletes a stopwords set.
  Future<StopwordDeleteSchema> delete() async {
    final response = await _apiCall.delete(
      '${Stopwords.resourcepath}/$id',
    );
    return StopwordDeleteSchema.fromJson(response);
  }
}
