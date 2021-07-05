import 'package:typesense/typesense.dart';
import 'package:logging/logging.dart';

import 'util.dart';
import 'collections.dart' as collections;
import 'documents.dart' as documents;

final log = Logger('Search');

Future<void> runExample(Client client) async {
  logInfoln(log, '--Search example--');
  await init(client);
  // Give Typesense cluster a few hundred ms to create collection on all nodes,
  // before reading it right after (eventually consistent)
  await Future.delayed(Duration(milliseconds: 500));
  await search(client);
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
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
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
  } catch (e, stackTrace) {
    log.severe(e.message, e, stackTrace);
  }
}
