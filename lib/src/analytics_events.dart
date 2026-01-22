import 'models/models.dart';
import 'services/api_call.dart';

class AnalyticsEvents {
  final ApiCall _apiCall;
  static const String eventsPath = '/analytics/events';
  static const String flushPath = '/analytics/flush';
  static const String statusPath = '/analytics/status';

  AnalyticsEvents(ApiCall apiCall) : _apiCall = apiCall;

  Future<AnalyticsEventCreateResponse> create(
      AnalyticsEventCreateSchema event) async {
    final response =
        await _apiCall.post(eventsPath, bodyParameters: event.toJson());
    return AnalyticsEventCreateResponse.fromJson(response);
  }

  Future<AnalyticsEventsRetrieveSchema> retrieve({
    required String userId,
    required String name,
    required int n,
  }) async {
    final response = await _apiCall.get(
      eventsPath,
      queryParams: {
        'user_id': userId,
        'name': name,
        'n': n.toString(),
      },
    );
    return AnalyticsEventsRetrieveSchema.fromJson(response);
  }

  Future<AnalyticsEventCreateResponse> flush() async {
    final response = await _apiCall.post(flushPath, bodyParameters: {});
    return AnalyticsEventCreateResponse.fromJson(response);
  }

  Future<AnalyticsStatus> status() async {
    final response = await _apiCall.get(statusPath);
    return AnalyticsStatus.fromJson(response);
  }
}
