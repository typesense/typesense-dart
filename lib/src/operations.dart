import 'services/api_call.dart';

class Operations {
  final ApiCall _apiCall;
  static const String resourcepath = '/operations';

  const Operations(ApiCall apiCall) : _apiCall = apiCall;

  /// Creates a point-in-time snapshot of a Typesense node's state and data at
  /// the specified [snapshotPath].
  ///
  /// A backup of the specified snapshot directory can be created and then later
  /// restored, if needed, as a data directory.
  Future<Map<String, dynamic>> createSnapshot(String snapshotPath) async {
    return await _apiCall.post('$resourcepath/snapshot',
        queryParams: {'snapshot_path': snapshotPath});
  }

  /// Triggers a follower node to initiate the raft voting process, which
  /// triggers leader re-election.
  ///
  /// The follower node against which this operation is run will become the new
  /// leader, once this command succeeds.
  Future<Map<String, dynamic>> initLeaderElection() async {
    return await _apiCall.post('$resourcepath/vote');
  }

  /// Start logging the requests which take more than [threshold] duration to
  /// complete.
  ///
  /// Slow requests are logged to the primary log file, with the prefix `SLOW
  /// REQUEST`.
  Future<Map<String, dynamic>> toggleSlowRequestLog(Duration threshold) async {
    return await _apiCall.post('/config', bodyParameters: {
      'log-slow-requests-time-ms': threshold.inMilliseconds
    });
  }
}
