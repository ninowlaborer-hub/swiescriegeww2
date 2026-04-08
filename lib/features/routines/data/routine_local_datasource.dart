import 'package:drift/drift.dart';
import '../../../core/database/database.dart';
import '../domain/routine.dart' as domain;
import '../domain/time_block.dart' as domain;
import '../domain/routine_explanation.dart';
import 'package:uuid/uuid.dart';

/// Local datasource for routines using Drift
///
/// Handles all database operations for routines and time blocks.
/// Uses SQLCipher encrypted database for data at rest.
class RoutineLocalDatasource {
  RoutineLocalDatasource(this._database);

  final AppDatabase _database;
  final _uuid = const Uuid();

  /// Save a routine and its time blocks to local database
  Future<int> saveRoutine(domain.Routine routine) async {
    return await _database.transaction(() async {
      // Normalize date to midnight
      final normalizedDate = DateTime(routine.date.year, routine.date.month, routine.date.day);

      // First check if routine exists by date (to prevent duplicates)
      final existingByDate = await (_database.select(_database.routines)
            ..where((tbl) => tbl.date.equals(normalizedDate))
            ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)])
            ..limit(1))
          .get();

      // Then check by UUID
      final existingByUuid = await (_database.select(_database.routines)
            ..where((tbl) => tbl.uuid.equals(routine.id)))
          .getSingleOrNull();

      int routineId;

      // If there's an existing routine for this date but different UUID, delete it
      if (existingByDate.isNotEmpty && existingByUuid == null) {
        final oldRoutine = existingByDate.first;
        await (_database.delete(_database.timeBlocks)
              ..where((tbl) => tbl.routineId.equals(oldRoutine.id)))
            .go();
        await (_database.delete(_database.routines)
              ..where((tbl) => tbl.id.equals(oldRoutine.id)))
            .go();
      }

      if (existingByUuid != null) {
        // Update existing routine
        await (_database.update(_database.routines)
              ..where((tbl) => tbl.id.equals(existingByUuid.id)))
            .write(
          RoutinesCompanion(
            uuid: Value(routine.id),
            date: Value(normalizedDate),
            title: Value(routine.title),
            explanation: Value(routine.explanation?.formattedText),
            confidenceScore: Value(routine.confidenceScore),
            isAccepted: Value(routine.isAccepted),
            updatedAt: Value(routine.updatedAt),
          ),
        );
        routineId = existingByUuid.id;

        // Delete existing time blocks for this routine
        await (_database.delete(_database.timeBlocks)
              ..where((tbl) => tbl.routineId.equals(routineId)))
            .go();
      } else {
        // Insert new routine
        routineId = await _database.into(_database.routines).insert(
          RoutinesCompanion.insert(
            uuid: routine.id,
            date: normalizedDate,
            title: routine.title,
            explanation: Value(routine.explanation?.formattedText),
            confidenceScore: Value(routine.confidenceScore),
            isAccepted: Value(routine.isAccepted),
            createdAt: routine.createdAt,
            updatedAt: routine.updatedAt,
          ),
        );
      }

      // Insert time blocks
      for (final block in routine.timeBlocks) {
        await _database.into(_database.timeBlocks).insert(
          TimeBlocksCompanion.insert(
            uuid: block.id,
            routineId: routineId,
            title: block.title,
            description: Value(block.description),
            startTime: block.startTime,
            endTime: block.endTime,
            activityType: block.activityType,
            category: Value(block.category),
            priority: Value(block.priority),
            isSnoozed: Value(block.isSnoozed),
            snoozedUntil: Value(block.snoozedUntil),
            source: Value(block.source),
            createdAt: block.createdAt,
            updatedAt: block.updatedAt,
          ),
        );
      }

      return routineId;
    });
  }

  /// Get routine by date
  Future<domain.Routine?> getRoutineByDate(DateTime date) async {
    // Normalize the date to midnight to ensure we're comparing dates only
    final normalizedDate = DateTime(date.year, date.month, date.day);

    // Get the most recently updated routine for this date
    // Use limit(1) instead of getSingleOrNull to handle duplicates
    final routines = await (_database.select(_database.routines)
          ..where((tbl) => tbl.date.equals(normalizedDate))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)])
          ..limit(1))
        .get();

    if (routines.isEmpty) return null;

    final routine = routines.first;
    final timeBlocks = await (_database.select(_database.timeBlocks)
          ..where((tbl) => tbl.routineId.equals(routine.id)))
        .get();

    return _mapToRoutine(routine, timeBlocks);
  }

  /// Get routine by ID
  Future<domain.Routine?> getRoutineById(String routineId) async {
    final routine = await (_database.select(_database.routines)
          ..where((tbl) => tbl.uuid.equals(routineId)))
        .getSingleOrNull();

    if (routine == null) return null;

    final timeBlocks = await (_database.select(_database.timeBlocks)
          ..where((tbl) => tbl.routineId.equals(routine.id)))
        .get();

    return _mapToRoutine(routine, timeBlocks);
  }

  /// Get all routines (paginated)
  Future<List<domain.Routine>> getAllRoutines({
    int limit = 30,
    int offset = 0,
  }) async {
    final routines = await (_database.select(_database.routines)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)])
          ..limit(limit, offset: offset))
        .get();

    final routineList = <domain.Routine>[];

    for (final routine in routines) {
      final timeBlocks = await (_database.select(_database.timeBlocks)
            ..where((tbl) => tbl.routineId.equals(routine.id)))
          .get();

      routineList.add(_mapToRoutine(routine, timeBlocks));
    }

    return routineList;
  }

  /// Get routines in date range
  Future<List<domain.Routine>> getRoutinesInRange(
    DateTime start,
    DateTime end,
  ) async {
    final routines = await (_database.select(_database.routines)
          ..where((tbl) => tbl.date.isBetweenValues(start, end))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.date)]))
        .get();

    final routineList = <domain.Routine>[];

    for (final routine in routines) {
      final timeBlocks = await (_database.select(_database.timeBlocks)
            ..where((tbl) => tbl.routineId.equals(routine.id)))
          .get();

      routineList.add(_mapToRoutine(routine, timeBlocks));
    }

    return routineList;
  }

  /// Update routine acceptance status
  Future<void> updateRoutineAcceptance(String routineId, bool isAccepted) async {
    await (_database.update(_database.routines)
          ..where((tbl) => tbl.uuid.equals(routineId)))
        .write(
      RoutinesCompanion(
        isAccepted: Value(isAccepted),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Update time block
  Future<void> updateTimeBlock(domain.TimeBlock block) async {
    await (_database.update(_database.timeBlocks)
          ..where((tbl) => tbl.uuid.equals(block.id)))
        .write(
      TimeBlocksCompanion(
        title: Value(block.title),
        description: Value(block.description),
        startTime: Value(block.startTime),
        endTime: Value(block.endTime),
        activityType: Value(block.activityType),
        category: Value(block.category),
        priority: Value(block.priority),
        isSnoozed: Value(block.isSnoozed),
        snoozedUntil: Value(block.snoozedUntil),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Delete routine and its time blocks
  Future<void> deleteRoutine(String routineId) async {
    await _database.transaction(() async {
      final routine = await (_database.select(_database.routines)
            ..where((tbl) => tbl.uuid.equals(routineId)))
          .getSingleOrNull();

      if (routine != null) {
        // Delete time blocks first (foreign key)
        await (_database.delete(_database.timeBlocks)
              ..where((tbl) => tbl.routineId.equals(routine.id)))
            .go();

        // Delete routine
        await (_database.delete(_database.routines)
              ..where((tbl) => tbl.id.equals(routine.id)))
            .go();
      }
    });
  }

  /// Delete routines older than specified date
  Future<int> deleteRoutinesOlderThan(DateTime cutoffDate) async {
    return await _database.transaction(() async {
      // Get old routine IDs
      final oldRoutines = await (_database.select(_database.routines)
            ..where((tbl) => tbl.createdAt.isSmallerThanValue(cutoffDate)))
          .get();

      var deletedCount = 0;

      for (final routine in oldRoutines) {
        // Delete time blocks
        await (_database.delete(_database.timeBlocks)
              ..where((tbl) => tbl.routineId.equals(routine.id)))
            .go();

        // Delete routine
        await (_database.delete(_database.routines)
              ..where((tbl) => tbl.id.equals(routine.id)))
            .go();

        deletedCount++;
      }

      return deletedCount;
    });
  }

  /// Map database rows to domain Routine object
  domain.Routine _mapToRoutine(
    Routine routine,
    List<TimeBlock> timeBlocks,
  ) {
    return domain.Routine(
      id: routine.uuid,
      date: routine.date,
      title: routine.title,
      timeBlocks: timeBlocks
          .map((block) => domain.TimeBlock(
                id: block.uuid,
                routineId: routine.uuid,
                title: block.title,
                description: block.description,
                startTime: block.startTime,
                endTime: block.endTime,
                activityType: block.activityType,
                category: block.category,
                priority: block.priority,
                isSnoozed: block.isSnoozed,
                snoozedUntil: block.snoozedUntil,
                source: block.source,
                createdAt: block.createdAt,
                updatedAt: block.updatedAt,
              ))
          .toList(),
      explanation: routine.explanation != null
          ? RoutineExplanation(
              summary: routine.explanation!,
              factors: [],
            )
          : null,
      confidenceScore: routine.confidenceScore,
      isAccepted: routine.isAccepted,
      createdAt: routine.createdAt,
      updatedAt: routine.updatedAt,
    );
  }
}
