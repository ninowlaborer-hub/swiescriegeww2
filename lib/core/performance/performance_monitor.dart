// core/performance/performance_monitor.dart
import '../logging/logger.dart';

/// Performance monitoring service
/// Tracks key metrics like app launch time, routine generation time, etc.
/// Per success criteria: Routine generation <5s, app launch <2s
class PerformanceMonitor {
  PerformanceMonitor();

  // Performance metrics storage
  final Map<String, List<PerformanceMetric>> _metrics = {};
  static const int _maxMetricsPerType = 100;

  // Active timers
  final Map<String, DateTime> _activeTimers = {};

  /// Start a performance timer
  void startTimer(String operationName) {
    _activeTimers[operationName] = DateTime.now();
    AppLogger.debug('Performance timer started: $operationName');
  }

  /// End a performance timer and record metric
  Duration? endTimer(String operationName, {Map<String, dynamic>? metadata}) {
    final startTime = _activeTimers.remove(operationName);
    if (startTime == null) {
      AppLogger.warning('No active timer found for: $operationName');
      return null;
    }

    final duration = DateTime.now().difference(startTime);
    _recordMetric(
      operationName: operationName,
      duration: duration,
      metadata: metadata,
    );

    AppLogger.info(
      'Performance: $operationName completed in ${duration.inMilliseconds}ms',
    );

    // Check against thresholds
    _checkThreshold(operationName, duration);

    return duration;
  }

  /// Record a performance metric
  void _recordMetric({
    required String operationName,
    required Duration duration,
    Map<String, dynamic>? metadata,
  }) {
    final metric = PerformanceMetric(
      operationName: operationName,
      duration: duration,
      timestamp: DateTime.now(),
      metadata: metadata,
    );

    _metrics.putIfAbsent(operationName, () => []).add(metric);

    // Keep list size manageable
    if (_metrics[operationName]!.length > _maxMetricsPerType) {
      _metrics[operationName]!.removeAt(0);
    }
  }

  /// Check if duration exceeds threshold and log warning
  void _checkThreshold(String operationName, Duration duration) {
    final threshold = _getThreshold(operationName);
    if (threshold != null && duration > threshold) {
      AppLogger.warning(
        'Performance warning: $operationName took ${duration.inMilliseconds}ms '
        '(threshold: ${threshold.inMilliseconds}ms)',
      );
    }
  }

  /// Get performance threshold for operation
  Duration? _getThreshold(String operationName) {
    switch (operationName) {
      case PerformanceOperation.appLaunch:
        return const Duration(seconds: 2); // FR requirement
      case PerformanceOperation.routineGeneration:
        return const Duration(seconds: 5); // FR requirement
      case PerformanceOperation.calendarSync:
        return const Duration(seconds: 3);
      case PerformanceOperation.weatherFetch:
        return const Duration(seconds: 2);
      case PerformanceOperation.sleepAnalysis:
        return const Duration(seconds: 2);
      case PerformanceOperation.databaseQuery:
        return const Duration(milliseconds: 500);
      case PerformanceOperation.mlInference:
        return const Duration(seconds: 3);
      default:
        return null;
    }
  }

  /// Get metrics for an operation
  List<PerformanceMetric> getMetrics(String operationName) {
    return _metrics[operationName] ?? [];
  }

  /// Get all metrics
  Map<String, List<PerformanceMetric>> getAllMetrics() {
    return Map.unmodifiable(_metrics);
  }

  /// Get average duration for an operation
  Duration? getAverageDuration(String operationName) {
    final metrics = _metrics[operationName];
    if (metrics == null || metrics.isEmpty) return null;

    final totalMs = metrics.fold<int>(
      0,
      (sum, metric) => sum + metric.duration.inMilliseconds,
    );
    return Duration(milliseconds: totalMs ~/ metrics.length);
  }

  /// Get performance statistics for an operation
  PerformanceStatistics? getStatistics(String operationName) {
    final metrics = _metrics[operationName];
    if (metrics == null || metrics.isEmpty) return null;

    final durations = metrics.map((m) => m.duration.inMilliseconds).toList()
      ..sort();

    final min = durations.first;
    final max = durations.last;
    final avg = durations.reduce((a, b) => a + b) / durations.length;
    final median = durations[durations.length ~/ 2];

    // Calculate p95 (95th percentile)
    final p95Index = (durations.length * 0.95).ceil() - 1;
    final p95 = durations[p95Index];

    final threshold = _getThreshold(operationName);
    final exceedsThreshold = threshold != null
        ? metrics.where((m) => m.duration > threshold).length
        : 0;

    return PerformanceStatistics(
      operationName: operationName,
      sampleCount: metrics.length,
      minMs: min,
      maxMs: max,
      avgMs: avg.round(),
      medianMs: median,
      p95Ms: p95,
      thresholdMs: threshold?.inMilliseconds,
      exceedsThresholdCount: exceedsThreshold,
    );
  }

  /// Get performance report
  PerformanceReport generateReport() {
    final operationStats = <PerformanceStatistics>[];
    for (final operationName in _metrics.keys) {
      final stats = getStatistics(operationName);
      if (stats != null) {
        operationStats.add(stats);
      }
    }

    return PerformanceReport(
      timestamp: DateTime.now(),
      operations: operationStats,
    );
  }

  /// Clear all metrics
  void clearMetrics() {
    _metrics.clear();
    AppLogger.info('Performance metrics cleared');
  }

  /// Clear metrics for specific operation
  void clearOperationMetrics(String operationName) {
    _metrics.remove(operationName);
    AppLogger.info('Performance metrics cleared for: $operationName');
  }
}

/// Performance metric
class PerformanceMetric {
  final String operationName;
  final Duration duration;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  PerformanceMetric({
    required this.operationName,
    required this.duration,
    required this.timestamp,
    this.metadata,
  });
}

/// Performance statistics for an operation
class PerformanceStatistics {
  final String operationName;
  final int sampleCount;
  final int minMs;
  final int maxMs;
  final int avgMs;
  final int medianMs;
  final int p95Ms;
  final int? thresholdMs;
  final int exceedsThresholdCount;

  PerformanceStatistics({
    required this.operationName,
    required this.sampleCount,
    required this.minMs,
    required this.maxMs,
    required this.avgMs,
    required this.medianMs,
    required this.p95Ms,
    this.thresholdMs,
    required this.exceedsThresholdCount,
  });

  bool get meetsThreshold {
    if (thresholdMs == null) return true;
    return p95Ms <= thresholdMs!;
  }

  String toFormattedString() {
    final buffer = StringBuffer();
    buffer.writeln('$operationName:');
    buffer.writeln('  Samples: $sampleCount');
    buffer.writeln('  Min: ${minMs}ms');
    buffer.writeln('  Max: ${maxMs}ms');
    buffer.writeln('  Avg: ${avgMs}ms');
    buffer.writeln('  Median: ${medianMs}ms');
    buffer.writeln('  P95: ${p95Ms}ms');
    if (thresholdMs != null) {
      buffer.writeln('  Threshold: ${thresholdMs}ms');
      buffer.writeln(
        '  Exceeds threshold: $exceedsThresholdCount/$sampleCount',
      );
      buffer.writeln('  Meets target: ${meetsThreshold ? "YES" : "NO"}');
    }
    return buffer.toString();
  }
}

/// Performance report
class PerformanceReport {
  final DateTime timestamp;
  final List<PerformanceStatistics> operations;

  PerformanceReport({required this.timestamp, required this.operations});

  String toFormattedString() {
    final buffer = StringBuffer();
    buffer.writeln('Performance Report - ${timestamp.toIso8601String()}');
    buffer.writeln('='.padRight(60, '='));
    buffer.writeln();

    for (final stats in operations) {
      buffer.write(stats.toFormattedString());
      buffer.writeln();
    }

    return buffer.toString();
  }
}

/// Common performance operations
class PerformanceOperation {
  static const String appLaunch = 'app_launch';
  static const String routineGeneration = 'routine_generation';
  static const String calendarSync = 'calendar_sync';
  static const String weatherFetch = 'weather_fetch';
  static const String sleepAnalysis = 'sleep_analysis';
  static const String databaseQuery = 'database_query';
  static const String mlInference = 'ml_inference';
  static const String cloudBackup = 'cloud_backup';
  static const String cloudRestore = 'cloud_restore';
  static const String encryption = 'encryption';
  static const String decryption = 'decryption';
}

/// Extension for easy performance tracking
extension PerformanceTracking<T> on Future<T> Function() {
  /// Execute function with performance tracking
  Future<T> trackPerformance(
    PerformanceMonitor monitor,
    String operationName, {
    Map<String, dynamic>? metadata,
  }) async {
    monitor.startTimer(operationName);
    try {
      final result = await this();
      monitor.endTimer(operationName, metadata: metadata);
      return result;
    } catch (e) {
      monitor.endTimer(operationName, metadata: {...?metadata, 'error': true});
      rethrow;
    }
  }
}
