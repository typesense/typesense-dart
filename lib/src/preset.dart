import 'presets.dart';
import 'services/api_call.dart';

class Preset {
  final String _presetName;
  final ApiCall _apiCall;

  Preset(String presetName, ApiCall apiCall)
      : _presetName = presetName,
        _apiCall = apiCall;

  Future<Map<String, dynamic>> retrieve() async {
    return await _apiCall.get(_endpointPath);
  }

  Future<Map<String, dynamic>> delete() async {
    return await _apiCall.delete(_endpointPath);
  }

  String get _endpointPath => '${Presets.resourcepath}/$_presetName';
}
