import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'services/api_call.dart';

class Keys {
  final ApiCall _apiCall;
  static const RESOURCEPATH = '/keys';

  Keys(ApiCall apiCall) : _apiCall = apiCall;

  Future<Map<String, dynamic>> create(Map<String, dynamic> params) async {
    return await _apiCall.post(RESOURCEPATH, bodyParameters: params);
  }

  Future<Map<String, dynamic>> retrieve() async {
    return await _apiCall.get(RESOURCEPATH);
  }
}

String generateScopedSearchKey(
    String searchKey, Map<String, dynamic> parameters) {
  final paramsJSON = json.encode(parameters),
      hmacSha256 = Hmac(sha256, utf8.encode(searchKey)),
      digest = base64Encode(hmacSha256.convert(utf8.encode(paramsJSON)).bytes),
      keyPrefix = searchKey.substring(0, 4),
      rawScopedKey = '$digest$keyPrefix$paramsJSON';

  return base64Encode(rawScopedKey.codeUnits);
}
