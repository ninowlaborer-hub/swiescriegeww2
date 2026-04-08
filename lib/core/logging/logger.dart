import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';

/// Application logger for Swisscierge
///
/// Provides structured logging with different levels:
/// - Debug: Development/debugging information
/// - Info: General informational messages
/// - Warning: Warning messages for potential issues
/// - Error: Error messages with stack traces
///
/// Logs are only printed in debug mode to avoid performance impact in production.
class AppLogger {
  const AppLogger._();

  /// Log debug message (only in debug mode)
  static void debug(String message, {Object? error}) {
    if (AppConfig.isDebugMode) {
      developer.log(
        message,
        name: 'Swisscierge',
        level: 500, // Debug level
        error: error,
      );
    }
  }

  /// Log info message
  static void info(String message) {
    developer.log(
      message,
      name: 'Swisscierge',
      level: 800, // Info level
    );
  }

  /// Log warning message
  static void warning(String message, {Object? error}) {
    developer.log(
      message,
      name: 'Swisscierge',
      level: 900, // Warning level
      error: error,
    );
  }

  /// Log error message with stack trace
  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: 'Swisscierge',
      level: 1000, // Error level
      error: error,
      stackTrace: stackTrace,
    );

    // In debug mode, also print to console for visibility
    if (kDebugMode) {
      debugPrint('ERROR: $message');
      if (error != null) {
        debugPrint('Error object: $error');
      }
      if (stackTrace != null) {
        debugPrint('Stack trace:\n$stackTrace');
      }
    }
  }

  /// Log routine generation event (for analytics/monitoring)
  static void logRoutineGeneration({
    required String routineId,
    required DateTime date,
    required Duration generationTime,
  }) {
    info(
      'Routine generated: $routineId for $date in ${generationTime.inMilliseconds}ms',
    );
  }

  /// Log calendar sync event
  static void logCalendarSync({
    required int eventCount,
    required Duration syncTime,
  }) {
    info('Calendar synced: $eventCount events in ${syncTime.inMilliseconds}ms');
  }

  /// Log weather fetch event
  static void logWeatherFetch({
    required String source,
    required bool fromCache,
  }) {
    info('Weather fetched from $source (cached: $fromCache)');
  }

  /// Log database cleanup event
  static void logDatabaseCleanup({
    required int routinesDeleted,
    required int sizeMB,
  }) {
    info(
      'Database cleanup: $routinesDeleted routines deleted, ${sizeMB}MB remaining',
    );
  }

  /// Log performance metric
  static void logPerformance({
    required String operation,
    required Duration duration,
  }) {
    final ms = duration.inMilliseconds;
    if (ms > 5000) {
      // Log as warning if operation takes > 5 seconds
      warning('Performance: $operation took ${ms}ms (slow)');
    } else {
      debug('Performance: $operation took ${ms}ms');
    }
  }
}
