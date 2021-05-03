import 'package:typesense/src/api_call.dart';

class Collections {
  final ApiCall _apicall;
  static const String RESOURCEPATH = '/collections';

  Collections(ApiCall apicall) : _apicall = apicall;

  Future<Map<String, dynamic>> retrieve() async {
    return await _apicall.get(RESOURCEPATH);
  }

  Future<Map<String, dynamic>> create(Map<String, dynamic> schema) async {
    return await _apicall.post(RESOURCEPATH, bodyParameters: schema);
  }
}
