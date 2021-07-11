import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'services/api_call.dart';

class Keys {
  final ApiCall _apiCall;
  static const resourcepath = '/keys';

  Keys(ApiCall apiCall) : _apiCall = apiCall;

  /// Creates a key according to the specified [params].
  ///
  /// Typesense allows creating API Keys with fine-grain access control. The
  /// acess can be restricted on both a per-collection and per-action level.
  Future<Map<String, dynamic>> create(Map<String, dynamic> params) async {
    return await _apiCall.post(resourcepath, bodyParameters: params);
  }

  /// Retrieves metadata of all the keys.
  Future<Map<String, dynamic>> retrieve() async {
    return await _apiCall.get(resourcepath);
  }

  /// Generates scoped search API keys that have embedded search parameters in
  /// them.
  ///
  /// Only a key generated with the `documents:search` action will be accepted
  /// by the server, when used with the search endpoint.
  ///
  /// Scoped search keys should only be generated *server-side*, so as to not
  /// leak the unscoped main search key to clients.
  String generateScopedSearchKey(
      String searchKey, Map<String, dynamic> parameters) {
    final paramsJSON = json.encode(parameters),
        hmacSha256 = Hmac(sha256, utf8.encode(searchKey)),
        digest =
            base64Encode(hmacSha256.convert(utf8.encode(paramsJSON)).bytes),
        keyPrefix = searchKey.substring(0, 4),
        rawScopedKey = '$digest$keyPrefix$paramsJSON';

    return base64Encode(rawScopedKey.codeUnits);
  }
}
