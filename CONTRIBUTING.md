# Contribution

Thanks for your interest in contributing! [Feedback][feedback] and [Pull Requests][pr] are most welcome!

Also, you can join our [Slack Community][invite] and say hello 👋️!

[feedback]: https://github.com/typesense/typesense-dart/issues/new/choose
[pr]: https://github.com/typesense/typesense-dart/pulls
[invite]: https://join.slack.com/t/typesense-community/shared_invite/zt-mx4nbsbn-AuOL89O7iBtvkz136egSJg

## Prerequisites

- Dart SDK 3.6.1+
- A running Typesense server for testing (Docker is recommended)

You can override the default testing server connection via the following environment variables:

| Variable             | Default     |
| -------------------- | ----------- |
| `TYPESENSE_HOST`     | `127.0.0.1` |
| `TYPESENSE_PORT`     | `8108`      |
| `TYPESENSE_PROTOCOL` | `http`      |
| `TYPESENSE_API_KEY`  | `xyz`       |

## Getting started

Clone the repository:

```sh
git clone https://github.com/typesense/typesense-dart.git
cd typesense-dart
```

Install dependencies:

```sh
dart pub get
```

## Running tests

Generate test mocks:

```shell
dart run build_runner build
```

Start the local Typesense server (via Docker):

```sh
docker compose up -d
```

Run all tests:

```sh
dart test
```

Stop the Typesense server:

```sh
docker compose down
```

## Formatting

```sh
dart format .
```

## Static analysis

```sh
dart analyze
```

## Before submitting

Please ensure:

- All tests pass
- Code is formatted `dart format .`
- `dart analyze` reports no issues
- New features include tests

Thank you!
