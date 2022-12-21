import 'package:typesense/typesense.dart';
import 'package:logging/logging.dart';

import 'util.dart';
import 'collections.dart' as collections;

final log = Logger('Aliases');

Future<void> runExample(Client client) async {
  logInfoln(log, '--Aliases example--');
  await init(client);
  await create(client);
  await addDocument(client);
  await search(client);
  await retrieveAll(client);
  await retrieve(client);
  await delete(client);
  await collections.delete(client, 'books_january');
}

final _hungerGamesBook = {
  'id': '1',
  'original_publication_year': 2008,
  'authors': ['Suzanne Collins'],
  'average_rating': 4.34,
  'publication_year': 2008,
  'publication_year_facet': '2008',
  'authors_facet': ['Suzanne Collins'],
  'title': 'The Hunger Games',
  'image_url': 'https://images.gr-assets.com/books/1447303603m/2767052.jpg',
  'ratings_count': 4780653
};

Future<void> init(Client client) async {
  await collections.create(
      client,
      Schema.fromMap({
        'name': 'books_january',
        'fields': [
          {'name': 'title', 'type': 'string'},
          {'name': 'authors', 'type': 'string[]'},
          {'name': 'authors_facet', 'type': 'string[]', 'facet': true},
          {'name': 'publication_year', 'type': 'int32'},
          {'name': 'publication_year_facet', 'type': 'string', 'facet': true},
          {'name': 'ratings_count', 'type': 'int32'},
          {'name': 'average_rating', 'type': 'float'},
          {'name': 'image_url', 'type': 'string'}
        ],
        'default_sorting_field': 'ratings_count'
      }));
}

Future<void> create(Client client) async {
  try {
    logInfoln(log, 'Creating alias "books".');
    log.fine(
      await client.aliases.upsert('books', {
        'collection_name': 'books_january',
      }),
    );

    await writePropagationDelay();
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}

Future<void> addDocument(Client client) async {
  try {
    logInfoln(log, 'Creating a document using alias "books".');
    log.fine(
      await client.collection('books').documents.create(_hungerGamesBook),
    );

    await writePropagationDelay();
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}

Future<void> search(Client client) async {
  try {
    logInfoln(log, 'Searching using alias "books".');
    log.fine(
      await client.collection('books').documents.search({
        'q': 'hunger',
        'query_by': 'title',
        'sort_by': 'ratings_count:desc'
      }),
    );
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}

Future<void> retrieveAll(Client client) async {
  try {
    logInfoln(log, 'Retrieving all aliases.');
    log.fine(await client.aliases.retrieve());
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}

Future<void> retrieve(Client client) async {
  try {
    logInfoln(log, 'Retrieving alias "books".');
    log.fine(await client.alias('books').retrieve());
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}

Future<void> delete(Client client) async {
  try {
    logInfoln(log, 'Deleting alias "books".');
    log.fine(await client.alias('books').delete());

    await writePropagationDelay();
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}
