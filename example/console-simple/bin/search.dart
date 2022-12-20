import 'package:typesense/typesense.dart';
import 'package:logging/logging.dart';

import 'util.dart';
import 'collections.dart' as collections;
import 'documents.dart' as documents;

final log = Logger('Search');

Future<void> runExample(Client client) async {
  logInfoln(log, '--Search example--');
  await init(client);
  await search(client);
  await geosearch(client);
  await multisearch(client);
  await collections.delete(client);
}

final _documents = [
  {
    'id': '124',
    'company_name': 'Stark Industries',
    'num_employees': 5215,
    'country': 'USA'
  },
  {
    'id': '125',
    'company_name': 'Acme Corp',
    'num_employees': 1002,
    'country': 'France'
  },
  {
    'id': '127',
    'company_name': 'Stark Corp',
    'num_employees': 1031,
    'country': 'USA'
  },
  {
    'id': '126',
    'company_name': 'Doofenshmirtz Inc',
    'num_employees': 2,
    'country': 'Tri-State Area'
  }
];

Future<void> init(Client client) async {
  await documents.init(client);
  await documents.importDocs(client, 'companies', _documents);
}

Future<void> search(Client client) async {
  try {
    logInfoln(log, 'Searching for documents.');
    log.fine(
      await client.collection('companies').documents.search(
        {
          'q': 'Stark',
          'query_by': 'company_name',
        },
      ),
    );

    logInfoln(log, 'Searching for non-existent documents.');
    log.fine(
      await client.collection('companies').documents.search(
        {
          'q': 'Non Existent',
          'query_by': 'company_name',
        },
      ),
    );

    logInfoln(log, 'Searching for more documents.');
    log.fine(
      await client.collection('companies').documents.search(
        {
          'q': 'stark',
          'query_by': 'company_name',
          'filter_by': 'num_employees:>100',
          'sort_by': 'num_employees:desc',
        },
      ),
    );

    logInfoln(log, 'Searching for documents and grouping the result.');
    log.fine(
      await client.collection('companies').documents.search(
        {
          'q': 'stark',
          'query_by': 'company_name',
          'filter_by': 'num_employees:>100',
          'sort_by': 'num_employees:desc',
          'group_by': 'country',
          'group_limit': '1'
        },
      ),
    );
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}

Future<void> geosearch(Client client) async {
  try {
    await collections.create(
        client,
        CreateSchema(
          'places',
          {
            CreateField('title', type: Type.string),
            CreateField('points', type: Type.int32),
            CreateField('location', type: Type.geopoint),
          },
          defaultSortingField: CreateField('points', type: Type.int32),
        ));
    await documents.importDocs(client, 'places', [
      {
        'title': 'Louvre Museuem',
        'points': 1,
        'location': [48.86093481609114, 2.33698396872901]
      }
    ]);

    logInfoln(log, 'Geosearching.');
    log.fine(await client.collection('places').documents.search({
      'q': '*',
      'query_by': 'title',
      'filter_by': 'location:(48.90615915923891, 2.3435897727061175, 5.1 km)',
      'sort_by': 'location(48.853, 2.344):asc'
    }));

    await collections.delete(client, 'places');
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}

Future<void> multisearch(Client client) async {
  try {
    logInfoln(log, 'Executing multiple searches.');
    log.fine(await client.multiSearch.perform({
      'searches': [
        {'q': 'Inc'},
        {'q': 'Acme'}
      ]
    }, queryParams: {
      'query_by': 'company_name',
      'collection': 'companies'
    }));
  } on RequestException catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  } catch (e, stackTrace) {
    log.severe(e, stackTrace);
  }
}
