```dart
import 'dart:io';

import 'package:typesense/typesense.dart';


void main() async {
  final host = InternetAddress.loopbackIPv4.address;
  final config = Configuration(
    // Replace with your configuration
    nodes: {
      Node(
        host: host,
        port: 7108,
        protocol: 'http',
      ),
      Node(
        host: host,
        port: 8108,
        protocol: 'http',
      ),
      Node(
        host: host,
        port: 9108,
        protocol: 'http',
      ),
    },
    apiKey: 'xyz',
    numRetries: 3, // A total of 4 tries (1 original try + 3 retries)
    connectionTimeout: Duration(seconds: 2),
  );
  final client = Client(config);
  
  await client.collections.retrieve();
}
```

For an exhaustive list of examples, visit [`typesense-dart/example/console-simple/`](https://github.com/typesense/typesense-dart/tree/master/example/console-simple)
