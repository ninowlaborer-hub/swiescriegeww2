// core/database/database_maintenance.dart
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';

import '../logging/logger.dart';
import 'database.dart';

/// Database maintenance utilities
/// Handles cleanup and size monitoring per FR-036 (100MB limit, 90-day history)
class DatabaseMaintenance {
  final AppDatabase _database;

  DatabaseMaintenance(this._database);

  /// Cleanup old routines (older than 90 days) per FR-036
  Future<int> cleanupOldRoutines() async {
    try {
      final cutoffDate = DateTime.now().subtract(const Duration(days: 90));
      AppLogger.info('Cleaning up routines older than $cutoffDate');

      final deleted = await (_database.delete(
        _database.routines,
      )..where((tbl) => tbl.createdAt.isSmallerThanValue(cutoffDate))).go();

      AppLogger.info('Deleted $deleted old routines');
      return deleted;
    } on Exception catch (e, stack) {
      AppLogger.error(
        'Failed to cleanup old routines',
        error: e,
        stackTrace: stack,
      );
      return 0;
    }
  }

  /// Cleanup old calendar cache (older than 7 days)
  Future<int> cleanupOldCalendarCache() async {
    try {
      final cutoffDate = DateTime.now().subtract(const Duration(days: 7));
      AppLogger.info('Cleaning up calendar cache older than $cutoffDate');

      final deleted = await (_database.delete(
        _database.calendarCache,
      )..where((tbl) => tbl.lastSyncedAt.isSmallerThanValue(cutoffDate))).go();

      AppLogger.info('Deleted $deleted old calendar cache entries');
      return deleted;
    } catch (e, stack) {
      AppLogger.error(
        'Failed to cleanup calendar cache',
        error: e,
        stackTrace: stack,
      );
      return 0;
    }
  }

  /// Cleanup old weather cache (older than 24 hours)
  Future<int> cleanupOldWeatherCache() async {
    try {
      final cutoffDate = DateTime.now().subtract(const Duration(hours: 24));
      AppLogger.info('Cleaning up weather cache older than $cutoffDate');

      final deleted = await (_database.delete(
        _database.weatherCache,
      )..where((tbl) => tbl.fetchedAt.isSmallerThanValue(cutoffDate))).go();

      AppLogger.info('Deleted $deleted old weather cache entries');
      return deleted;
    } catch (e, stack) {
      AppLogger.error(
        'Failed to cleanup weather cache',
        error: e,
        stackTrace: stack,
      );
      return 0;
    }
  }

  /// Run full database cleanup (all old data)
  Future<Map<String, int>> runFullCleanup() async {
    AppLogger.info('Starting full database cleanup');

    final results = {
      'routines': await cleanupOldRoutines(),
      'calendar_cache': await cleanupOldCalendarCache(),
      'weather_cache': await cleanupOldWeatherCache(),
    };

    final totalDeleted = results.values.fold<int>(
      0,
      (sum, count) => sum + count,
    );
    AppLogger.info('Full cleanup complete: deleted $totalDeleted records');

    return results;
  }

  /// Get current database size in bytes
  Future<int> getDatabaseSize() async {
    try {
      final dbPath = await _getDatabasePath();
      final dbFile = File(dbPath);

      if (!await dbFile.exists()) {
        return 0;
      }

      final size = await dbFile.length();
      AppLogger.debug('Database size: ${_formatBytes(size)}');
      return size;
    } catch (e, stack) {
      AppLogger.error(
        'Failed to get database size',
        error: e,
        stackTrace: stack,
      );
      return 0;
    }
  }

  /// Check if database size exceeds limit (100MB per FR-036)
  Future<bool> isDatabaseSizeExceeded() async {
    const maxSizeBytes = 100 * 1024 * 1024; // 100MB
    final currentSize = await getDatabaseSize();

    if (currentSize > maxSizeBytes) {
      AppLogger.warning(
        'Database size (${_formatBytes(currentSize)}) exceeds limit (${_formatBytes(maxSizeBytes)})',
      );
      return true;
    }

    return false;
  }

  /// Get database size as a percentage of limit
  Future<double> getDatabaseSizePercentage() async {
    const maxSizeBytes = 100 * 1024 * 1024; // 100MB
    final currentSize = await getDatabaseSize();
    return (currentSize / maxSizeBytes) * 100;
  }

  /// Get database statistics
  Future<DatabaseStatistics> getDatabaseStatistics() async {
    try {
      final routines = await _database.select(_database.routines).get();
      final routineCount = routines.length;

      final timeBlocks = await _database.select(_database.timeBlocks).get();
      final timeBlockCount = timeBlocks.length;

      final calendarCache = await _database
          .select(_database.calendarCache)
          .get();
      final calendarCacheCount = calendarCache.length;

      final weatherCache = await _database.select(_database.weatherCache).get();
      final weatherCacheCount = weatherCache.length;

      final userPreferences = await _database
          .select(_database.userPreferences)
          .get();
      final preferenceCount = userPreferences.length;

      final totalSize = await getDatabaseSize();
      final sizePercentage = await getDatabaseSizePercentage();

      return DatabaseStatistics(
        routineCount: routineCount,
        timeBlockCount: timeBlockCount,
        calendarCacheCount: calendarCacheCount,
        weatherCacheCount: weatherCacheCount,
        preferenceCount: preferenceCount,
        totalSizeBytes: totalSize,
        sizePercentage: sizePercentage,
        isOverLimit: sizePercentage > 100,
      );
    } catch (e, stack) {
      AppLogger.error(
        'Failed to get database statistics',
        error: e,
        stackTrace: stack,
      );
      return DatabaseStatistics.empty();
    }
  }

  /// Vacuum database to reclaim space
  Future<void> vacuumDatabase() async {
    try {
      AppLogger.info('Starting database vacuum');
      await _database.customStatement('VACUUM');
      AppLogger.info('Database vacuum complete');
    } catch (e, stack) {
      AppLogger.error('Failed to vacuum database', error: e, stackTrace: stack);
    }
  }

  /// Get database file path
  Future<String> _getDatabasePath() async {
    final appDir = await getApplicationDocumentsDirectory();
    return '${appDir.path}/swisscierge.db';
  }

  /// Format bytes to human-readable string
  String _formatBytes(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }
}

/// Database statistics
class DatabaseStatistics {
  final int routineCount;
  final int timeBlockCount;
  final int calendarCacheCount;
  final int weatherCacheCount;
  final int preferenceCount;
  final int totalSizeBytes;
  final double sizePercentage;
  final bool isOverLimit;

  DatabaseStatistics({
    required this.routineCount,
    required this.timeBlockCount,
    required this.calendarCacheCount,
    required this.weatherCacheCount,
    required this.preferenceCount,
    required this.totalSizeBytes,
    required this.sizePercentage,
    required this.isOverLimit,
  });

  factory DatabaseStatistics.empty() {
    return DatabaseStatistics(
      routineCount: 0,
      timeBlockCount: 0,
      calendarCacheCount: 0,
      weatherCacheCount: 0,
      preferenceCount: 0,
      totalSizeBytes: 0,
      sizePercentage: 0,
      isOverLimit: false,
    );
  }

  int get totalRecordCount =>
      routineCount +
      timeBlockCount +
      calendarCacheCount +
      weatherCacheCount +
      preferenceCount;

  String get formattedSize {
    if (totalSizeBytes < 1024) {
      return '$totalSizeBytes B';
    } else if (totalSizeBytes < 1024 * 1024) {
      return '${(totalSizeBytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(totalSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  String get sizeStatus {
    if (sizePercentage < 50) {
      return 'Good';
    } else if (sizePercentage < 80) {
      return 'Fair';
    } else if (sizePercentage < 100) {
      return 'High';
    } else {
      return 'Over Limit';
    }
  }
}
