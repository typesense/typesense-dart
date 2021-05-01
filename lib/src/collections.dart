import 'package:typesense/src/api_call.dart';

class Collections {
  ApiCall _apicall;
  static const String RESOURCEPATH = '/collections';

  Collections(ApiCall apicall) {
    this._apicall = apicall;
  }

  Future<Map<String, dynamic>> retrieve() async {
    return this._apicall.get(Collections.RESOURCEPATH);
  }

  Future<Map<String, dynamic>> create(Map<String, dynamic> schema) async {
    return await this
        ._apicall
        .post(Collections.RESOURCEPATH, bodyParameters: schema);
  }
}
