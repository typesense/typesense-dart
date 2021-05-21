import 'package:typesense/src/services/api_call.dart';

import 'models/alias.dart';

class Aliases {
  final ApiCall _apiCall;
  static const String RESOURCEPATH = '/aliases';

  Aliases(ApiCall apicall) : _apiCall = apicall;

  Future<Alias> upsert(Alias alias) async {
    return Alias.fromMap(
      await _apiCall.put(
        '$RESOURCEPATH/${alias.name}',
        bodyParameters: alias.collectionNameAsMap,
      ),
    );
  }

  Future<Set<Alias>> retrieve() async {
    return ((await _apiCall.get(
      RESOURCEPATH,
    ))['aliases'] as List)
        .map(
          (map) => Alias.fromMap(map),
        )
        .toSet();
  }
}
