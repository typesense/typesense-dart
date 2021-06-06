import 'dart:io';

import 'package:typesense/typesense.dart';

void main() async {
  final config = Configuration(
        nodes: {
          Node(
            protocol: 'http',
            host: InternetAddress.loopbackIPv4.address,
            port: 8108,
          ),
        },
        apiKey: 'xyz',
      ),
      client = Client(config); // Replace with your configuration

  final schema = await client.collections.create(Schema(
    'companies',
    {
      Field('company_name', Type.string),
      Field('num_employees', Type.int32),
      Field('country', Type.string, isFacetable: true),
    },
    defaultSortingField: Field('num_employees', Type.int32),
  ));

  print(schema);

  await client.collection('companies').delete();
}
