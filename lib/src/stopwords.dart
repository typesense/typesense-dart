import 'models/models.dart';
import 'services/api_call.dart';

class Stopwords {
  final ApiCall _apiCall;
  static const String resourcepath = '/stopwords';

  Stopwords(ApiCall apiCall) : _apiCall = apiCall;

  /// Creates/updates a stopwords set corresponding to [stopwordId].
  Future<StopwordSchema> upsert(
      String stopwordId, StopwordCreateSchema params) async {
    final response = await _apiCall.put(
      '$resourcepath/$stopwordId',
      bodyParameters: params.toJson(),
    );
    return StopwordSchema.fromJson(response);
  }

  /// Retrieves all stopwords sets.
  Future<StopwordsRetrieveSchema> retrieve() async {
    final response = await _apiCall.get(resourcepath);
    return StopwordsRetrieveSchema.fromJson(response);
  }
}
