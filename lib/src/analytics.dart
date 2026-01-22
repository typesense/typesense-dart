import 'services/api_call.dart';
import 'analytics_rules.dart';
import 'analytics_rule.dart';
import 'analytics_events.dart';

class Analytics {
  final ApiCall _apiCall;
  final AnalyticsRules _rules;
  final AnalyticsEvents _events;
  final _individualRules = <String, AnalyticsRule>{};

  Analytics(ApiCall apiCall)
      : _apiCall = apiCall,
        _rules = AnalyticsRules(apiCall),
        _events = AnalyticsEvents(apiCall);

  AnalyticsRules rules() => _rules;

  AnalyticsRule rule(String name) {
    if (!_individualRules.containsKey(name)) {
      _individualRules[name] = AnalyticsRule(name, _apiCall);
    }
    return _individualRules[name]!;
  }

  AnalyticsEvents events() => _events;
}
