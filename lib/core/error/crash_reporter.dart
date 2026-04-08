import 'package:flutter/foundation.dart';
import '../logging/logger.dart';

/// Privacy-respecting crash reporter
/// Only reports crashes if analytics is enabled and user has consented
/// Per FR-034: Respects immediate opt-out
class CrashReporter {
  CrashReporter();

  // In-memory crash log for debugging (not transmitted)
  final List<CrashReport> _localCrashLog = [];
  static const int _maxLocalCrashes = 10;

  /// Initialize crash reporting
  /// Sets up Flutter error handlers and zone error handling
  void initialize() {
    // Capture Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      _handleFlutterError(details);
    };

    // Capture errors outside Flutter framework (async errors)
    PlatformDispatcher.instance.onError = (error, stack) {
      _handlePlatformError(error, stack);
      return true; // Handled
    };

    AppLogger.info('Crash reporter initialized');
  }

  /// Handle Flutter framework errors
  void _handleFlutterError(FlutterErrorDetails details) {
    // Always log locally for debugging
    AppLogger.error(
      'Flutter error: ${details.exceptionAsString()}',
      error: details.exception,
      stackTrace: details.stack,
    );

    // Store in local crash log
    final crash = CrashReport(
      error: details.exception.toString(),
      stackTrace: details.stack?.toString(),
      timestamp: DateTime.now(),
      type: CrashType.flutter,
      isFatal: details.silent == false,
    );
    _addToLocalLog(crash);

    // In debug mode, also print to console
    if (kDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    }
  }

  /// Handle platform/async errors
  void _handlePlatformError(Object error, StackTrace stack) {
    AppLogger.error('Platform error: $error', error: error, stackTrace: stack);

    final crash = CrashReport(
      error: error.toString(),
      stackTrace: stack.toString(),
      timestamp: DateTime.now(),
      type: CrashType.platform,
      isFatal: true,
    );
    _addToLocalLog(crash);
  }

  /// Report a manually caught error
  void reportError(
    Object error,
    StackTrace? stackTrace, {
    String? context,
    bool isFatal = false,
  }) {
    AppLogger.error(
      'Reported error${context != null ? " ($context)" : ""}: $error',
      error: error,
      stackTrace: stackTrace,
    );

    final crash = CrashReport(
      error: error.toString(),
      stackTrace: stackTrace?.toString(),
      timestamp: DateTime.now(),
      type: CrashType.caught,
      context: context,
      isFatal: isFatal,
    );
    _addToLocalLog(crash);
  }

  /// Add crash to local log (for on-device debugging)
  void _addToLocalLog(CrashReport crash) {
    _localCrashLog.add(crash);
    if (_localCrashLog.length > _maxLocalCrashes) {
      _localCrashLog.removeAt(0);
    }
  }

  /// Extract error type without PII
  String _extractErrorType(String errorMessage) {
    // Extract just the exception class name
    final match = RegExp(
      r"^([A-Za-z][A-Za-z0-9_]*(?:Exception|Error))",
    ).firstMatch(errorMessage);
    if (match != null) {
      return match.group(1)!;
    }

    // Fallback to generic type
    return 'UnknownError';
  }

  /// Get local crash log (for debugging/support)
  List<CrashReport> getLocalCrashLog() {
    return List.unmodifiable(_localCrashLog);
  }

  /// Clear local crash log
  void clearLocalCrashLog() {
    _localCrashLog.clear();
    AppLogger.info('Local crash log cleared');
  }

  /// Get crash statistics
  Map<String, int> getCrashStatistics() {
    final stats = <String, int>{};
    for (final crash in _localCrashLog) {
      final type = _extractErrorType(crash.error);
      stats[type] = (stats[type] ?? 0) + 1;
    }
    return stats;
  }
}

/// Crash report data structure
class CrashReport {
  final String error;
  final String? stackTrace;
  final DateTime timestamp;
  final CrashType type;
  final String? context;
  final bool isFatal;

  CrashReport({
    required this.error,
    this.stackTrace,
    required this.timestamp,
    required this.type,
    this.context,
    this.isFatal = false,
  });

  String get formattedTimestamp =>
      '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')} '
      '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}';
}

/// Type of crash/error
enum CrashType {
  flutter, // Flutter framework errors
  platform, // Platform/async errors
  caught, // Manually reported errors
}
