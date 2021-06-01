import 'services/api_call.dart';

class Debug {
  static const String RESOURCEPATH = '/debug';
  final ApiCall _apicall;

  Debug(ApiCall apicall) : _apicall = apicall;
  Future<Map<String, dynamic>> retrieve() async {
    return this._apicall.get(Debug.RESOURCEPATH);
  }
}
