```dart
import 'dart:io';

import 'package:typesense/typesense.dart';

void main() async {
  // Replace with your configuration
  final config = Configuration(
      nodes: {
        Node(
          protocol: 'http',
          host: InternetAddress.loopbackIPv4.address,
          port: 8108,
        ),
        Node(
          protocol: 'http',
          host: InternetAddress.loopbackIPv4.address,
          port: 7108,
        ),
        Node(
          protocol: 'http',
          host: InternetAddress.loopbackIPv4.address,
          port: 9108,
        ),
      },
      apiKey: 'xyz',
      numRetries: 3, // A total of 4 tries (1 original try + 3 retries)
      connectionTimeout:
          Duration(seconds: 10));
  
  final client = Client(config);
  await client.collections.retrieve();
}
```

For an exhaustive list of examples, visit [`typesense-dart/example/console-simple/`](https://github.com/typesense/typesense-dart/tree/master/example/console-simple)