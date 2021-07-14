# typesense-dart [![pub package][pubShield]][package] [![CircleCI][CircleCIShield]][CircleCI] [![codecov][codecovBadge]][codecov] [![pub points][pubScoreBadge]][pubScore]

Dart client library for accessing the [Typesense HTTP API][typesense].

Note: This package is still under development. Version `0.2.0` will be fully migrated to null safety; [related issue][nnbd]. Some existing APIs might change or new APIs might be available in the future.

## Installation

Add `typesense-dart` as a [dependency in your pubspec.yaml file](https://flutter.dev/using-packages/).

```@yaml
dependencies:
  typesense-dart: ^0.1.0
```

## Usage

Read the documentation here: [https://typesense.org/docs/api/][docs]

Tests are also a good place to know how the library works internally: [test](test)

**Note: When using this library in a user-facing app, please be sure to use an API Key that only allows search operations instead of the `master` API key.** See [keys.dart](example/console-simple/bin/keys.dart) for an example of how to generate a search only API key.

See [Configuration](lib/src/configuration.dart) class for a list of all client configuration options.

### Examples

The examples that walk you through on how to use the client: [main.dart](example/console-simple/bin/main.dart)

Make sure to [README](example/console-simple/README.md) beforehand.

## Contributing

Visit [CONTRIBUTING.md](CONTRIBUTING.md)

[nnbd]: https://github.com/typesense/typesense-dart/issues/37
[docs]: https://typesense.org/docs/api/
[pubShield]: https://img.shields.io/pub/v/typesense-dart.svg
[package]: https://pub.dev/packages/typesense-dart
[CircleCIShield]: https://circleci.com/gh/typesense/typesense-dart.svg?style=shield
[CircleCI]: https://circleci.com/gh/typesense/typesense-dart
[codecovBadge]: https://codecov.io/gh/typesense/typesense-dart/branch/master/graph/badge.svg?token=UV6MPDKS07
[codecov]: https://codecov.io/gh/typesense/typesense-dart
[pubScoreBadge]: https://badges.bar/typesense-dart/pub%20points
[pubScore]: https://pub.dev/packages/typesense-dart/score
[typesense]: https://github.com/typesense/typesense
