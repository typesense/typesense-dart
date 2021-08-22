import 'package:http/http.dart' as http;

import '../models/node.dart';

typedef Request = Future<http.Response> Function(Node);
typedef Send<R> = Future<R> Function(Request);
