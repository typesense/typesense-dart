# Description
A simple command-line application to showcase typesense examples.

# Setup
The configuration of the client can be updated to reflect your setup. The included example emulates a multi-node cluster, following steps are required to run it as is:

1. Download Typesense server binary ([link](https://typesense.org/downloads/)).
2. The file [typesense-server-nodes](server_configuration/typesense-server-nodes) contains a list of comma-separated values representing the peer nodes and the port on which they accept peer communication. For example, in `192.168.43.11:8107:8108` the node `192.168.43.11:8107` accepts peer communication at port `8108`. Update these CSV's to reflect your setup.
3. Create separate `data directories` for each of the nodes, for example:

  `mkdir /tmp/typesense-server-data-7108`

  Similarly for `typesense-server-data-8108` and `typesense-server-data-9108`. Update the respective [config files][conf] if using some other directory.
  
4. Spin up three instances of the server following the pattern: 

  `./typesense-server --config=[path to node7108.ini] --nodes=[path to typesense-server-nodes]`.
  
  Similarly for `node8108.ini` and `node9108.ini`. These files are present in [`server_configuration/`][conf].

**To know more about command line arguments,** [follow this link][arguments].

# Execution
After all three nodes are running, change current directory to `typesense-dart/example/console-simple/` and issue the following command:

`dart bin/main.dart`

or

`dart example/console-simple/bin/main.dart` if still in root.

[arguments]: https://typesense.org/docs/0.21.0/guide/configure-typesense.html#using-command-line-arguments
[conf]: server_configuration/