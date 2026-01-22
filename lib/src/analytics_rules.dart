import 'dart:convert';

import 'models/models.dart';
import 'services/api_call.dart';
import 'analytics_rule.dart';

class AnalyticsRules {
  final ApiCall _apiCall;
  static const String resourcepath = '/analytics/rules';
  final _individualRules = <String, AnalyticsRule>{};

  AnalyticsRules(ApiCall apiCall) : _apiCall = apiCall;

  /// Creates a single analytics rule.
  Future<AnalyticsRuleSchema> create(AnalyticsRuleCreateSchema rule) async {
    final response = await _apiCall.post(
      resourcepath,
      bodyParameters: rule.toJson(),
    );
    return AnalyticsRuleSchema.fromJson(
      Map<String, dynamic>.from(response as Map),
    );
  }

  /// Creates multiple analytics rules.
  Future<List<AnalyticsRuleSchema>> createMany(
      List<AnalyticsRuleCreateSchema> rules) async {
    final body = rules.map((item) => item.toJson()).toList();
    final encodedBody = json.encode(body);
    final response = await _apiCall.sendList((node) => node.client!.post(
          _apiCall.getRequestUri(node, resourcepath),
          headers: _apiCall.defaultHeaders,
          body: encodedBody,
        ));
    return response.map((item) {
      return AnalyticsRuleSchema.fromJson(
        Map<String, dynamic>.from(item as Map),
      );
    }).toList();
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
