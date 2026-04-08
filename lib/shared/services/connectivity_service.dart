import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Connectivity service for offline detection
///
/// Monitors network connectivity state to enable offline-first behavior.
/// Used by services to determine when to sync vs. use cached data.
class ConnectivityService {
  ConnectivityService() {
    _init();
  }

  final Connectivity _connectivity = Connectivity();
  final StreamController<ConnectivityStatus> _statusController =
      StreamController<ConnectivityStatus>.broadcast();

  ConnectivityStatus _currentStatus = ConnectivityStatus.unknown;

  /// Stream of connectivity status changes
  Stream<ConnectivityStatus> get connectivityStream => _statusController.stream;

  /// Current connectivity status
  ConnectivityStatus get currentStatus => _currentStatus;

  /// Initialize connectivity monitoring
  void _init() {
    // Check initial connectivity
    _connectivity.checkConnectivity().then((result) {
      _updateStatus(result);
    });

    // Listen for connectivity changes
    _connectivity.onConnectivityChanged.listen((result) {
      _updateStatus(result);
    });
  }

  /// Update connectivity status
  void _updateStatus(List<ConnectivityResult> results) {
    // If any connection type is available, we're online
    final isConnected = results.any((result) =>
        result != ConnectivityResult.none);

    final newStatus = isConnected
        ? ConnectivityStatus.online
        : ConnectivityStatus.offline;

    if (newStatus != _currentStatus) {
      _currentStatus = newStatus;
      _statusController.add(_currentStatus);
    }
  }

  /// Dispose resources
  void dispose() {
    _statusController.close();
  }
}

/// Connectivity status enum
enum ConnectivityStatus {
  /// Device is online (any connection available)
  online,

  /// Device is offline (no connection)
  offline,

  /// Status unknown (initial state)
  unknown,
}
