import 'services/api_call.dart';
import 'stemming_dictionaries.dart';
import 'stemming_dictionary.dart';

class Stemming {
  final ApiCall _apiCall;
  final StemmingDictionaries _dictionaries;
  final _individualDictionaries = <String, StemmingDictionary>{};

  Stemming(ApiCall apiCall)
      : _apiCall = apiCall,
        _dictionaries = StemmingDictionaries(apiCall);

  StemmingDictionaries get dictionaries => _dictionaries;

  StemmingDictionary dictionary(String id) {
    if (!_individualDictionaries.containsKey(id)) {
      _individualDictionaries[id] = StemmingDictionary(id, _apiCall);
    }
    return _individualDictionaries[id]!;
  }
}
