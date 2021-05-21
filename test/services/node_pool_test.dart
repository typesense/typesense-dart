import 'package:test/test.dart';

import 'package:typesense/src/services/node_pool.dart';
import 'package:typesense/src/models/node.dart';

import '../test_utils.dart';

void main() {
  group('NodePool', () {
    NodePool nodePool;
    setUp(() {
      nodePool = NodePool(ConfigurationFactory.withoutNearestNode());
    });

    test('has a nextNode field', () {
      expect(
          nodePool.nextNode,
          equals(Node(
            protocol: protocol,
            host: host,
            port: mockServerPort,
            path: pathToService,
          )));
    });
    test('has a setNodeHealthStatus method', () {
      final node = nodePool.nextNode, accessTime = DateTime.now();
      NodePool.setNodeHealthStatus(node, false, accessTime);

      expect(node.isHealthy, isFalse);
      expect(node.lastAccessTimestamp, accessTime);
    });
  });

  group('NodePool.nextNode', () {
    test('returns a node even when all the nodes are unhealthy', () {
      final node1 = Node(
            protocol: protocol,
            host: host,
            port: nearestServerPort,
            path: pathToService,
          ),
          node2 = Node(
            protocol: protocol,
            host: host,
            port: mockServerPort,
            path: pathToService,
          ),
          nodePool = NodePool(
              ConfigurationFactory.withoutNearestNode(nodes: {node1, node2}));
      NodePool.setNodeHealthStatus(node1, false, DateTime.now());
      NodePool.setNodeHealthStatus(node2, false, DateTime.now());

      expect(nodePool.nextNode, equals(node1));
      expect(nodePool.nextNode, equals(node2));
    });
    test("returns the nearest node, if present, while it's healthy", () {
      final nodePool = NodePool(ConfigurationFactory.withNearestNode());
      for (var i = 0; i < 4; i++) {
        final node = nodePool.nextNode;
        expect(
            node,
            equals(Node(
              protocol: protocol,
              host: host,
              port: nearestServerPort,
              path: pathToService,
            )));
        NodePool.setNodeHealthStatus(node, true, DateTime.now());
      }
      NodePool.setNodeHealthStatus(nodePool.nextNode, false, DateTime.now());

      final node = nodePool.nextNode; // nearest node is unhealthy now
      expect(
          node,
          equals(Node(
            protocol: protocol,
            host: host,
            port: mockServerPort, // nearest node is not returned
            path: pathToService,
          )));
      NodePool.setNodeHealthStatus(node, true, DateTime.now());
    });
    test('loops through nodes if nearest node is absent', () {
      final node1 = Node(
            protocol: protocol,
            host: host,
            port: nearestServerPort,
            path: pathToService,
          ),
          node2 = Node(
            protocol: protocol,
            host: host,
            port: mockServerPort,
            path: pathToService,
          ),
          nodePool = NodePool(
              ConfigurationFactory.withoutNearestNode(nodes: {node1, node2}));
      for (var i = 0; i < 4; i++) {
        final node = nodePool.nextNode;
        if (i % 2 == 0) {
          expect(node, equals(node1));
        } else {
          expect(node, equals(node2));
        }

        NodePool.setNodeHealthStatus(node, true, DateTime.now());
      }
    });
    test(
        'reconsiders an unhealthy node after Configuration.healthcheckInterval',
        () async {
      final node1 = Node(
            protocol: protocol,
            host: host,
            port: nearestServerPort,
            path: pathToService,
          ),
          node2 = Node(
            protocol: protocol,
            host: host,
            port: mockServerPort,
            path: pathToService,
          ),
          nodePool = NodePool(ConfigurationFactory.withoutNearestNode(
              healthcheckInterval: Duration(seconds: 1),
              nodes: {node1, node2}));

      expect(nodePool.nextNode, equals(node1));
      NodePool.setNodeHealthStatus(node1, false, DateTime.now());

      expect(nodePool.nextNode, equals(node2));
      expect(nodePool.nextNode,
          equals(node2)); // node2 is returned since node1 is unhealthy

      await Future.delayed(Duration(seconds: 1));
      expect(nodePool.nextNode, equals(node1));
    });
  });
}
