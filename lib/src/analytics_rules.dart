import 'models/models.dart';
import 'services/api_call.dart';
import 'analytics_rule.dart';

class AnalyticsRules {
  final ApiCall _apiCall;
  static const String resourcepath = '/analytics/rules';
  final _individualRules = <String, AnalyticsRule>{};

  AnalyticsRules(ApiCall apiCall) : _apiCall = apiCall;

  Future<dynamic> create(Object rule) async {
    final body = rule is List<AnalyticsRuleCreateSchema>
        ? rule.map((item) => item.toJson()).toList()
        : (rule as AnalyticsRuleCreateSchema).toJson();
    final Object response =
        await _apiCall.post(resourcepath, bodyParameters: body);
    if (response is List) {
      return response.map((item) {
        final map = Map<String, dynamic>.from(item as Map);
        if (map.containsKey('error')) {
          return map;
        }
        return AnalyticsRuleSchema.fromJson(map);
      }).toList();
    }
    return AnalyticsRuleSchema.fromJson(
      Map<String, dynamic>.from(response as Map),
    );
  }

  Future<List<AnalyticsRuleSchema>> retrieve({String? ruleTag}) async {
    final query = <String, String>{};
    if (ruleTag != null) {
      query['rule_tag'] = ruleTag;
    }
    final response = await _apiCall.getList(
      resourcepath,
      queryParams: query.isEmpty ? null : query,
    );
    return response
        .map((item) =>
            AnalyticsRuleSchema.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<AnalyticsRuleSchema> upsert(
      String ruleName, AnalyticsRuleUpsertSchema update) async {
    final response = await _apiCall.put(
      '$resourcepath/${Uri.encodeComponent(ruleName)}',
      bodyParameters: update.toJson(),
    );
    return AnalyticsRuleSchema.fromJson(response);
  }

  AnalyticsRule operator [](String ruleName) {
    if (!_individualRules.containsKey(ruleName)) {
      _individualRules[ruleName] = AnalyticsRule(ruleName, _apiCall);
    }
    return _individualRules[ruleName]!;
  }
}
