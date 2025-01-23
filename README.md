# Typesense

 [![pub package][pubShield]][package] [![github actions status][githubBadge]][githubActions] [![pub likes][pubLikesBadge]][pubScore] [![pub points][pubScoreBadge]][pubScore] [![pub downloads][pubDownloadsBadge]][pubScore]

Dart client library for accessing the HTTP API of [Typesense][typesense] search engine.

Note: This package is still under development. Some existing APIs might change or new APIs might be available in the future.

## Installation

Add `typesense` as a [dependency in your pubspec.yaml file](https://flutter.dev/using-packages/).

```@yaml
dependencies:
  typesense: ^0.5.1
```

## Usage

Read the documentation here: [https://typesense.org/docs/api/][docs]

Tests are also a good place to know how the library works internally: [test](test)

**Note: When using this library in a user-facing app, please be sure to use an API Key that only allows search operations instead of the `master` API key.** See [keys.dart](example/console-simple/bin/keys.dart) for an example of how to generate a search only API key.

See [Configuration](lib/src/configuration.dart) class for a list of all client configuration options.

### Examples


```dart
import 'dart:io';

import 'package:typesense/typesense.dart';


void main() async {
  // Replace with your configuration
  final host = InternetAddress.loopbackIPv4.address, protocol = Protocol.http;
  final config = Configuration(
    // Api key
    'xyz',
    nodes: {
      Node(
        protocol,
        host,
        port: 7108,
      ),
      Node.withUri(
        Uri(
          scheme: 'http',
          host: host,
          port: 8108,
        ),
      ),
      Node(
        protocol,
        host,
        port: 9108,
      ),
    },
    numRetries: 3, // A total of 4 tries (1 original try + 3 retries)
    connectionTimeout: const Duration(seconds: 2),
  );

  final client = Client(config);

  final searchParameters = {
    'q': 'stark',
    'query_by': 'company_name',
    'filter_by': 'num_employees:>100',
    'sort_by': 'num_employees:desc'
  };

  await client.collection('companies').documents.search(searchParameters);
}
```

The examples that walk you through on how to use the client: [main.dart](example/console-simple/bin/main.dart)

Make sure to [README](example/console-simple/README.md) beforehand.

## Compatibility

| Typesense Server | typesense-dart |
|------------------|----------------|
| \>= v0.24.0 | \>= v0.5.0 |
| \>= v0.22.0 | \>= v0.3.0 |
| \>= v0.21.0 | \>= v0.1.1 |

## Contributing

Visit [CONTRIBUTING.md](CONTRIBUTING.md)

## Credits

This library is authored and maintained by our awesome community of contributors:

- [happy-san](https://github.com/happy-san)
- [harisarang](https://github.com/harisarang)
- [mafreud](https://github.com/mafreud)

[nnbd]: https://github.com/typesense/typesense-dart/issues/37
[docs]: https://typesense.org/docs/api/
[githubBadge]: https://github.com/typesense/typesense-dart/actions/workflows/dart.yml/badge.svg
[githubActions]: https://github.com/typesense/typesense-dart/actions
[pubShield]: https://img.shields.io/pub/v/typesense.svg
[package]: https://pub.dev/packages/typesense
[codecovBadge]: https://codecov.io/gh/typesense/typesense-dart/branch/master/graph/badge.svg?token=UV6MPDKS07
[codecov]: https://codecov.io/gh/typesense/typesense-dart
[pubScoreBadge]: https://img.shields.io/pub/points/typesense
[pubScore]: https://pub.dev/packages/typesense/score
[typesense]: https://github.com/typesense/typesense
[pubLikesBadge]: https://img.shields.io/pub/likes/typesense
[pubDownloadsBadge]: https://img.shields.io/pub/dm/typesense
