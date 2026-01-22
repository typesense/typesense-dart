import 'models/models.dart';
import 'services/api_call.dart';
import 'analytics_rules.dart';

class AnalyticsRule {
  final String _name;
  final ApiCall _apiCall;

  AnalyticsRule(String name, ApiCall apiCall)
      : _name = name,
        _apiCall = apiCall;

  Future<AnalyticsRuleSchema> retrieve() async {
    final response = await _apiCall.get(_endpointPath);
    return AnalyticsRuleSchema.fromJson(response);
  }

  Future<AnalyticsRuleDeleteSchema> delete() async {
    final response = await _apiCall.delete(_endpointPath);
    return AnalyticsRuleDeleteSchema.fromJson(response);
  }

  String get _endpointPath =>
      '${AnalyticsRules.resourcepath}/${Uri.encodeComponent(_name)}';
}
