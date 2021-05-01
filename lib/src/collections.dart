import 'package:typesense/src/api_call.dart';

class Collections {
  ApiCall _apicall;
  static const String RESOURCEPATH = '/collections';

  Collections(apicall) {
    this._apicall = apicall;
  }

  retrieve() {
    return this._apicall.get(Collections.RESOURCEPATH);
  }

  create(schema) {
    return this._apicall.post(Collections.RESOURCEPATH, bodyParameters: schema);
  }
}
