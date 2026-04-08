import '../domain/routine.dart';
import '../domain/time_block.dart';
import 'routine_local_datasource.dart';
import '../../../core/logging/logger.dart';
import '../../../core/error/app_error.dart';

/// Repository for routine data access
///
/// Implements repository pattern for clean separation of data layer.
/// Provides high-level API for routine operations with error handling.
class RoutineRepository {
  RoutineRepository(this._localDatasource);

  final RoutineLocalDatasource _localDatasource;

  /// Save routine to local storage
  Future<void> saveRoutine(Routine routine) async {
    try {
      await _localDatasource.saveRoutine(routine);
      AppLogger.info('Routine saved: ${routine.id}');
    } catch (e) {
      AppLogger.error('Failed to save routine', error: e);
      throw DatabaseError('Failed to save routine', e);
    }
  }

  /// Get routine for specific date
  Future<Routine?> getRoutineForDate(DateTime date) async {
    try {
      return await _localDatasource.getRoutineByDate(date);
    } catch (e) {
      AppLogger.error('Failed to get routine for date', error: e);
      throw DatabaseError('Failed to load routine', e);
    }
  }

  /// Get routine by ID
  Future<Routine?> getRoutineById(String routineId) async {
    try {
      return await _localDatasource.getRoutineById(routineId);
    } catch (e) {
      AppLogger.error('Failed to get routine by ID', error: e);
      throw DatabaseError('Failed to load routine', e);
    }
  }

  /// Get all routines (paginated)
  Future<List<Routine>> getAllRoutines({
    int limit = 30,
    int offset = 0,
  }) async {
    try {
      return await _localDatasource.getAllRoutines(
        limit: limit,
        offset: offset,
      );
    } catch (e) {
      AppLogger.error('Failed to get all routines', error: e);
      throw DatabaseError('Failed to load routines', e);
    }
  }

  /// Get routines in date range
  Future<List<Routine>> getRoutinesInRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      return await _localDatasource.getRoutinesInRange(start, end);
    } catch (e) {
      AppLogger.error('Failed to get routines in range', error: e);
      throw DatabaseError('Failed to load routines', e);
    }
  }

  /// Get today's routine
  Future<Routine?> getTodaysRoutine() async {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    return getRoutineForDate(todayDate);
  }

  /// Accept a routine
  Future<void> acceptRoutine(String routineId) async {
    try {
      await _localDatasource.updateRoutineAcceptance(routineId, true);
      AppLogger.info('Routine accepted: $routineId');
    } catch (e) {
      AppLogger.error('Failed to accept routine', error: e);
      throw DatabaseError('Failed to update routine', e);
    }
  }

  /// Update time block
  Future<void> updateTimeBlock(TimeBlock block) async {
    try {
      await _localDatasource.updateTimeBlock(block);
      AppLogger.info('Time block updated: ${block.id}');
    } catch (e) {
      AppLogger.error('Failed to update time block', error: e);
      throw DatabaseError('Failed to update time block', e);
    }
  }

  /// Delete routine
  Future<void> deleteRoutine(String routineId) async {
    try {
      await _localDatasource.deleteRoutine(routineId);
      AppLogger.info('Routine deleted: $routineId');
    } catch (e) {
      AppLogger.error('Failed to delete routine', error: e);
      throw DatabaseError('Failed to delete routine', e);
    }
  }

  /// Clean up old routines (90+ days)
  Future<int> cleanupOldRoutines() async {
    try {
      final cutoffDate = DateTime.now().subtract(const Duration(days: 90));
      final deletedCount =
          await _localDatasource.deleteRoutinesOlderThan(cutoffDate);
      AppLogger.info('Cleaned up $deletedCount old routines');
      return deletedCount;
    } catch (e) {
      AppLogger.error('Failed to cleanup old routines', error: e);
      throw DatabaseError('Failed to cleanup routines', e);
    }
  }

  /// Check if routine exists for date
  Future<bool> hasRoutineForDate(DateTime date) async {
    final routine = await getRoutineForDate(date);
    return routine != null;
  }

  /// Get routine statistics
  Future<Map<String, dynamic>> getStatistics() async {
    try {
      final allRoutines = await getAllRoutines(limit: 1000);

      return {
        'total_routines': allRoutines.length,
        'accepted_routines':
            allRoutines.where((r) => r.isAccepted).length,
        'average_blocks': allRoutines.isEmpty
            ? 0
            : allRoutines.fold<int>(0, (sum, r) => sum + r.timeBlocks.length) /
                allRoutines.length,
        'latest_routine_date':
            allRoutines.isEmpty ? null : allRoutines.first.date,
      };
    } catch (e) {
      AppLogger.error('Failed to get statistics', error: e);
      return {};
    }
  }
}
