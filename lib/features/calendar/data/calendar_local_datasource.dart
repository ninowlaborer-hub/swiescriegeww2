import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/database/database.dart';
import '../../../core/logging/logger.dart';
import '../domain/calendar_event.dart';
import '../domain/calendar_source.dart';

/// Local datasource for calendar data
///
/// Handles caching of calendar events and sources in encrypted local database.
/// Implements offline-first strategy with cache expiration.
class CalendarLocalDatasource {
  CalendarLocalDatasource(this._database);

  final AppDatabase _database;

  // MARK: - Calendar Sources

  /// Save calendar sources to cache
  Future<void> saveCalendarSources(List<CalendarSource> sources) async {
    await _database.transaction(() async {
      for (final source in sources) {
        await _database.into(_database.calendarCache).insert(
              CalendarCacheCompanion.insert(
                eventId: source.id, // Use source ID as event ID for sources
                calendarId: source.id,
                calendarName: source.name,
                title: source.name, // Use name as title for sources
                startTime: DateTime.now(), // Placeholder for sources
                endTime: DateTime.now(), // Placeholder for sources
                accountName: Value(source.accountName),
                accountType: Value(source.accountType),
                color: Value(source.color),
                isSelected: Value(source.isSelected),
                isPrimary: Value(source.isPrimary),
                isReadOnly: Value(source.isReadOnly),
                sourceType: Value(source.sourceType?.toString()),
                metadata: Value(source.metadata != null ? jsonEncode(source.metadata) : null),
                lastSyncedAt: DateTime.now(),
                createdAt: source.createdAt,
                updatedAt: source.updatedAt,
              ),
              mode: InsertMode.insertOrReplace,
            );
      }
    });

    AppLogger.info('Saved ${sources.length} calendar sources to cache');
  }

  /// Get all cached calendar sources
  Future<List<CalendarSource>> getCalendarSources() async {
    final query = _database.select(_database.calendarCache)
      ..orderBy([
        (tbl) => OrderingTerm(expression: tbl.isPrimary, mode: OrderingMode.desc),
        (tbl) => OrderingTerm(expression: tbl.calendarName),
      ]);

    final rows = await query.get();

    return rows.map(_mapToCalendarSource).toList();
  }

  /// Get selected calendar sources
  Future<List<CalendarSource>> getSelectedCalendarSources() async {
    final query = _database.select(_database.calendarCache)
      ..where((tbl) => tbl.isSelected.equals(true))
      ..orderBy([
        (tbl) => OrderingTerm(expression: tbl.isPrimary, mode: OrderingMode.desc),
        (tbl) => OrderingTerm(expression: tbl.calendarName),
      ]);

    final rows = await query.get();

    return rows.map(_mapToCalendarSource).toList();
  }

  /// Update calendar source selection
  Future<void> updateCalendarSelection(String calendarId, bool isSelected) async {
    await (_database.update(_database.calendarCache)
          ..where((tbl) => tbl.calendarId.equals(calendarId)))
        .write(CalendarCacheCompanion(
      isSelected: Value(isSelected),
    ));

    AppLogger.info('Updated calendar selection: $calendarId = $isSelected');
  }

  /// Get last sync time for calendar sources
  Future<DateTime?> getLastCalendarSyncTime() async {
    final query = _database.select(_database.calendarCache)
      ..orderBy([
        (tbl) => OrderingTerm(
              expression: tbl.lastSyncedAt,
              mode: OrderingMode.desc,
            ),
      ])
      ..limit(1);

    final row = await query.getSingleOrNull();
    return row?.lastSyncedAt;
  }

  // MARK: - Calendar Events (stored in CalendarCache table as JSON)

  /// Save calendar events to cache
  ///
  /// Events are stored as JSON in the metadata field.
  /// This is a simplified approach - for production, consider a separate events table.
  Future<void> saveCalendarEvents(
    String calendarId,
    List<CalendarEvent> events,
  ) async {
    // Get existing calendar source
    final query = _database.select(_database.calendarCache)
      ..where((tbl) => tbl.calendarId.equals(calendarId));

    final existing = await query.getSingleOrNull();

    if (existing == null) {
      AppLogger.warning('Calendar source not found: $calendarId');
      return;
    }

    // Store events as JSON in metadata
    final eventsJson = events.map((e) => e.toJson()).toList();

    // Decode existing metadata or create new
    Map<String, dynamic> metadata = {};
    if (existing.metadata != null) {
      try {
        metadata = jsonDecode(existing.metadata!) as Map<String, dynamic>;
      } catch (e) {
        // Invalid JSON, start fresh
      }
    }
    metadata['cached_events'] = eventsJson;

    await (_database.update(_database.calendarCache)
          ..where((tbl) => tbl.calendarId.equals(calendarId)))
        .write(CalendarCacheCompanion(
      metadata: Value(jsonEncode(metadata)),
      lastSyncedAt: Value(DateTime.now()),
    ));

    AppLogger.info('Cached ${events.length} events for calendar: $calendarId');
  }

  /// Get cached events for a calendar
  Future<List<CalendarEvent>> getCachedEvents(String calendarId) async {
    final query = _database.select(_database.calendarCache)
      ..where((tbl) => tbl.calendarId.equals(calendarId));

    final row = await query.getSingleOrNull();

    if (row == null || row.metadata == null) {
      return [];
    }

    try {
      final metadata = jsonDecode(row.metadata!) as Map<String, dynamic>;
      final eventsJson = metadata['cached_events'] as List?;
      if (eventsJson == null) {
        return [];
      }

      return eventsJson
          .cast<Map<String, dynamic>>()
          .map((json) => CalendarEvent.fromJson(json))
          .toList();
    } catch (e) {
      AppLogger.warning('Failed to decode cached events: $e');
      return [];
    }
  }

  /// Get all cached events from selected calendars
  Future<List<CalendarEvent>> getAllCachedEvents() async {
    final sources = await getSelectedCalendarSources();
    final allEvents = <CalendarEvent>[];

    for (final source in sources) {
      final events = await getCachedEvents(source.id);
      allEvents.addAll(events);
    }

    // Sort by start time
    allEvents.sort((a, b) => a.startTime.compareTo(b.startTime));

    return allEvents;
  }

  /// Get cached events for date range
  Future<List<CalendarEvent>> getCachedEventsForDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final allEvents = await getAllCachedEvents();

    return allEvents.where((event) {
      return event.startTime.isBefore(endDate) &&
          event.endTime.isAfter(startDate);
    }).toList();
  }

  /// Clear calendar cache
  Future<void> clearCalendarCache() async {
    await _database.delete(_database.calendarCache).go();
    AppLogger.info('Cleared calendar cache');
  }

  /// Clear events cache for specific calendar
  Future<void> clearEventsCache(String calendarId) async {
    final query = _database.select(_database.calendarCache)
      ..where((tbl) => tbl.calendarId.equals(calendarId));

    final existing = await query.getSingleOrNull();

    if (existing == null) {
      return;
    }

    // Decode metadata, remove cached events, re-encode
    Map<String, dynamic> metadata = {};
    if (existing.metadata != null) {
      try {
        metadata = jsonDecode(existing.metadata!) as Map<String, dynamic>;
      } catch (e) {
        // Invalid JSON, start fresh
      }
    }
    metadata.remove('cached_events');

    await (_database.update(_database.calendarCache)
          ..where((tbl) => tbl.calendarId.equals(calendarId)))
        .write(CalendarCacheCompanion(
      metadata: Value(jsonEncode(metadata)),
    ));

    AppLogger.info('Cleared events cache for calendar: $calendarId');
  }

  // MARK: - Helper Methods

  CalendarSource _mapToCalendarSource(CalendarCacheData row) {
    CalendarSourceType? sourceType;
    if (row.sourceType != null) {
      try {
        sourceType = CalendarSourceType.values.firstWhere(
          (e) => e.toString() == row.sourceType,
        );
      } catch (e) {
        // Invalid source type, leave as null
      }
    }

    Map<String, dynamic>? metadata;
    if (row.metadata != null) {
      try {
        metadata = jsonDecode(row.metadata!) as Map<String, dynamic>;
      } catch (e) {
        // Invalid JSON, leave as null
      }
    }

    return CalendarSource(
      id: row.calendarId,
      name: row.calendarName,
      accountName: row.accountName,
      accountType: row.accountType,
      color: row.color,
      isSelected: row.isSelected,
      isPrimary: row.isPrimary,
      isReadOnly: row.isReadOnly,
      sourceType: sourceType,
      metadata: metadata,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  /// Get cache statistics
  Future<Map<String, dynamic>> getCacheStatistics() async {
    final sources = await getCalendarSources();
    final selectedSources = await getSelectedCalendarSources();
    final allEvents = await getAllCachedEvents();
    final lastSyncTime = await getLastCalendarSyncTime();

    return {
      'total_calendars': sources.length,
      'selected_calendars': selectedSources.length,
      'cached_events': allEvents.length,
      'last_sync': lastSyncTime?.toIso8601String(),
    };
  }
}
