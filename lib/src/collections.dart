import 'models/models.dart';
import 'services/api_call.dart';
import 'services/collections_api_call.dart';

class Collections {
  final ApiCall _apicall;
  final CollectionsApiCall _collectionsApiCall;
  static const String resourcepath = '/collections';

  Collections(ApiCall apicall, CollectionsApiCall collectionsApiCall)
      : _apicall = apicall,
        _collectionsApiCall = collectionsApiCall;

  /// Returns [Schema] of all your collections. The collections are returned
  /// sorted by creation date, with the most recent collections appearing first.
  Future<List<Schema>> retrieve() async {
    return (await _collectionsApiCall.get(resourcepath))
        .map((schema) => Schema.fromMap(schema))
        .toList(growable: false);
  }

  /// Creates a new collection with the [schema].
  Future<Schema> create(CollectionCreateSchema schema) async {
    return Schema.fromMap(await _apicall.post(
      resourcepath,
      bodyParameters: schema.toMap(),
    ));
  }
}
