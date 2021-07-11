# Description
A simple command-line application to showcase typesense examples.

# Setup
The configuration of the client can be updated to reflect your setup. The included example emulates a multi-node setup, following setup is required to run it as is:

1. Download Typesense server binary ([link](https://typesense.org/downloads/)).
2. The file [typesense-server-nodes](server_configuration/typesense-server-nodes) contains a list of comma-separated values representing the peer nodes and the port on which they accept peer communication. For example, in `192.168.43.11:8107:8108` the node `192.168.43.11:8107` accepts peer communication at port `8108`. Update these CSV's to reflect your setup.
3. Spin up three instances of the server following the pattern: 
  `./typesense-server --config=[path to node7108.ini] --nodes=[path to typesense-server-nodes]`. Same for `node8108.ini` and `node9108.ini`. These files are present in [`server_configuration/`](server_configuration/).

# Execution
After all three nodes are running, change current directory to `typesense-dart/example/console-simple/` and issue the following command:

`dart bin/main.dart`