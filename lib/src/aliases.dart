import 'package:typesense/src/api_call.dart';

import 'models/alias.dart';

class Aliases {
  final ApiCall _apicall;
  static const String RESOURCEPATH = '/aliases';

  Aliases(ApiCall apicall) : _apicall = apicall;

  Future<Alias> upsert(Alias alias) async {
    return Alias.fromMap(
      await _apicall.put(
        _aliasEndpoint(alias.name),
        bodyParameters: alias.collectionNameAsMap,
      ),
    );
  }

  Future<Alias> delete(String aliasName) async {
    return Alias.fromMap(
      await _apicall.delete(
        _aliasEndpoint(aliasName),
      ),
    );
  }

  Future<Alias> retrieve(String aliasName) async {
    return Alias.fromMap(
      await _apicall.get(
        _aliasEndpoint(aliasName),
      ),
    );
  }

  Future<Set<Alias>> retrieveAll() async {
    return ((await _apicall.get(
      RESOURCEPATH,
    ))['aliases'] as List)
        .map(
          (map) => Alias.fromMap(map),
        )
        .toSet();
  }

  String _aliasEndpoint(String name) => '$RESOURCEPATH/$name';
}
