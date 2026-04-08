// core/performance/optimization_guide.dart

/// Performance Optimization Guide for Swisscierge
///
/// This document provides guidance on meeting performance requirements:
/// - App launch: <2 seconds (FR requirement)
/// - Routine generation: <5 seconds (FR requirement)
/// - Calendar sync, weather fetch: <3 seconds (best practice)
/// - Database queries: <500ms (best practice)
library;

class PerformanceOptimizationGuide {
  /// Get optimization recommendations based on performance metrics
  static List<OptimizationRecommendation> getRecommendations({
    required int appLaunchMs,
    required int routineGenerationMs,
    int? calendarSyncMs,
    int? weatherFetchMs,
    int? mlInferenceMs,
  }) {
    final recommendations = <OptimizationRecommendation>[];

    // App launch optimizations
    if (appLaunchMs > 2000) {
      recommendations.addAll([
        OptimizationRecommendation(
          category: OptimizationCategory.appLaunch,
          severity: Severity.critical,
          issue: 'App launch exceeds 2s target ($appLaunchMs ms)',
          suggestions: [
            'Defer non-critical initialization to after first frame',
            'Use lazy loading for heavy services',
            'Optimize database initialization (use async)',
            'Reduce initial widget tree complexity',
            'Profile with Flutter DevTools Timeline',
          ],
        ),
      ]);
    }

    // Routine generation optimizations
    if (routineGenerationMs > 5000) {
      recommendations.addAll([
        OptimizationRecommendation(
          category: OptimizationCategory.routineGeneration,
          severity: Severity.critical,
          issue:
              'Routine generation exceeds 5s target ($routineGenerationMs ms)',
          suggestions: [
            'Optimize ML model inference (use quantized models)',
            'Cache calendar and weather data',
            'Parallelize independent data fetches',
            'Use database indexes for time-range queries',
            'Profile ML inference separately from data gathering',
          ],
        ),
      ]);
    }

    // Calendar sync optimizations
    if (calendarSyncMs != null && calendarSyncMs > 3000) {
      recommendations.add(
        OptimizationRecommendation(
          category: OptimizationCategory.dataSync,
          severity: Severity.warning,
          issue: 'Calendar sync is slow ($calendarSyncMs ms)',
          suggestions: [
            'Fetch only needed date range (not entire calendar)',
            'Use incremental sync with lastSyncedAt timestamp',
            'Cache calendar data locally',
            'Batch database inserts for multiple events',
          ],
        ),
      );
    }

    // ML inference optimizations
    if (mlInferenceMs != null && mlInferenceMs > 3000) {
      recommendations.add(
        OptimizationRecommendation(
          category: OptimizationCategory.mlInference,
          severity: Severity.warning,
          issue: 'ML inference is slow ($mlInferenceMs ms)',
          suggestions: [
            'Use quantized TFLite models (reduce size by 75%)',
            'Enable GPU delegate on supported devices',
            'Reduce model input size (limit context window)',
            'Consider using Core ML on iOS for better performance',
            'Profile with ML-specific tools',
          ],
        ),
      );
    }

    return recommendations;
  }

  /// Get general best practices
  static List<BestPractice> getBestPractices() {
    return [
      BestPractice(
        category: 'Database',
        practices: [
          'Use indexes on frequently queried columns (userId, createdAt, date)',
          'Batch inserts/updates when possible',
          'Use database transactions for multi-step operations',
          'Vacuum database periodically to reclaim space',
          'Query only needed columns (avoid SELECT *)',
          'Use streaming queries for large result sets',
        ],
      ),
      BestPractice(
        category: 'ML/AI',
        practices: [
          'Use TFLite quantized models (int8) instead of full float32',
          'Enable hardware acceleration (GPU delegate, NNAPI)',
          'Cache model outputs when inputs haven\'t changed',
          'Limit context window size to reduce inference time',
          'Run inference in background isolate to avoid UI jank',
          'Profile inference separately from pre/post-processing',
        ],
      ),
      BestPractice(
        category: 'Network',
        practices: [
          'Use caching for weather and calendar data',
          'Set appropriate cache TTL (weather: 1h, calendar: 15min)',
          'Implement exponential backoff for retries',
          'Use connection pooling for HTTP requests',
          'Compress request/response payloads',
          'Parallelize independent network calls',
        ],
      ),
      BestPractice(
        category: 'UI/Widgets',
        practices: [
          'Use const constructors wherever possible',
          'Implement RepaintBoundary for complex widgets',
          'Use ListView.builder for long lists (not ListView)',
          'Avoid rebuilding entire tree (use keys, providers)',
          'Use Image caching for repeated images',
          'Defer expensive operations until after first frame',
        ],
      ),
      BestPractice(
        category: 'State Management',
        practices: [
          'Use Riverpod family for parameterized providers',
          'Implement autoDispose for short-lived providers',
          'Keep provider scope as narrow as possible',
          'Use select() to rebuild only when specific fields change',
          'Avoid unnecessary provider invalidations',
        ],
      ),
      BestPractice(
        category: 'Memory',
        practices: [
          'Dispose controllers and streams properly',
          'Use WeakReference for caches when appropriate',
          'Limit in-memory cache sizes (e.g., 100 items)',
          'Monitor memory usage with DevTools',
          'Clear old data periodically (90-day retention)',
        ],
      ),
    ];
  }

  /// Get device compatibility checklist
  static List<String> getCompatibilityChecklist() {
    return [
      '✓ Test on iOS 13+ (minimum supported version)',
      '✓ Test on iPhone 8 and newer (performance baseline)',
      '✓ Test on iPad (responsive layout)',
      '✓ Test on Android 10+ (minimum supported version)',
      '✓ Test on mid-range Android device (performance baseline)',
      '✓ Test with reduced motion enabled',
      '✓ Test with VoiceOver/TalkBack enabled',
      '✓ Test in airplane mode (offline functionality)',
      '✓ Test with poor network (3G simulation)',
      '✓ Test with database containing 90 days of data',
      '✓ Test ML inference on different device tiers',
      '✓ Verify ML model size is <50MB',
      '✓ Verify app size is <100MB',
      '✓ Test battery impact (should be minimal)',
    ];
  }

  /// Get ML model optimization strategies
  static List<String> getMLOptimizations() {
    return [
      'Model Quantization: Convert float32 to int8 (75% size reduction, minimal accuracy loss)',
      'Use TFLite models instead of full TensorFlow',
      'Enable GPU delegation on iOS (Core ML) and Android (GPU Delegate)',
      'Reduce model input size: Limit calendar events, weather data points',
      'Cache embeddings: Don\'t re-compute for unchanged inputs',
      'Use streaming inference for large contexts',
      'Profile with: flutter run --profile && DevTools',
      'Monitor with: Performance overlay in debug mode',
      'Benchmark on target devices: iPhone 8, mid-range Android',
    ];
  }

  /// Get database optimization strategies
  static List<String> getDatabaseOptimizations() {
    return [
      'Indexes: CREATE INDEX idx_routines_date ON routines(date)',
      'Indexes: CREATE INDEX idx_routines_created_at ON routines(created_at)',
      'Indexes: CREATE INDEX idx_time_blocks_routine_id ON time_blocks(routine_id)',
      'Use EXPLAIN QUERY PLAN to identify slow queries',
      'Batch operations: Use transactions for bulk inserts',
      'Vacuum: Run VACUUM periodically to reclaim space',
      'Limit queries: Use LIMIT and OFFSET for pagination',
      'Stream results: Use watch() instead of get() for large datasets',
      'Clean old data: Delete records >90 days automatically',
    ];
  }
}

/// Optimization recommendation
class OptimizationRecommendation {
  final OptimizationCategory category;
  final Severity severity;
  final String issue;
  final List<String> suggestions;

  OptimizationRecommendation({
    required this.category,
    required this.severity,
    required this.issue,
    required this.suggestions,
  });

  String toFormattedString() {
    final buffer = StringBuffer();
    buffer.writeln('[${severity.name.toUpperCase()}] ${category.name}');
    buffer.writeln('Issue: $issue');
    buffer.writeln('Suggestions:');
    for (final suggestion in suggestions) {
      buffer.writeln('  • $suggestion');
    }
    return buffer.toString();
  }
}

enum OptimizationCategory {
  appLaunch,
  routineGeneration,
  dataSync,
  mlInference,
  databaseQuery,
  networkRequest,
  uiRendering,
}

enum Severity {
  critical, // Exceeds requirements
  warning, // Approaching limits
  info, // Could be improved
}

class BestPractice {
  final String category;
  final List<String> practices;

  BestPractice({required this.category, required this.practices});
}
