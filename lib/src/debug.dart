import 'services/api_call.dart';

class Debug {
  static const String resourcepath = '/debug';
  final ApiCall _apicall;

  Debug(ApiCall apicall) : _apicall = apicall;
  Future<Map<String, dynamic>> retrieve() async {
    return _apicall.get(Debug.resourcepath);
  }
}
