import '../../../core/error/app_error.dart';
import '../../../core/logging/logger.dart';
import '../../../core/platform/calendar_bridge.dart';
import '../domain/calendar_event.dart';
import '../domain/calendar_source.dart';
import 'calendar_local_datasource.dart';

/// Calendar repository
///
/// Manages calendar data with offline-first strategy.
/// Syncs with device calendars and maintains local cache.
class CalendarRepository {
  CalendarRepository({
    required CalendarLocalDatasource localDatasource,
    required CalendarBridge calendarBridge,
  })  : _localDatasource = localDatasource,
        _calendarBridge = calendarBridge;

  final CalendarLocalDatasource _localDatasource;
  final CalendarBridge _calendarBridge;

  // MARK: - Permissions

  /// Request calendar permissions
  Future<bool> requestPermissions() async {
    try {
      return await _calendarBridge.requestPermissions();
    } on CalendarBridgeException catch (e) {
      AppLogger.error('Failed to request calendar permissions', error: e);
      throw PermissionError('Failed to request calendar permissions', e);
    } catch (e) {
      AppLogger.error('Unexpected error requesting permissions', error: e);
      throw UnknownError('Failed to request calendar permissions', e);
    }
  }

  /// Check if calendar permissions are granted
  Future<bool> hasPermissions() async {
    try {
      return await _calendarBridge.hasPermissions();
    } on CalendarBridgeException catch (e) {
      AppLogger.error('Failed to check calendar permissions', error: e);
      return false;
    } catch (e) {
      AppLogger.error('Unexpected error checking permissions', error: e);
      return false;
    }
  }

  /// Open device settings
  Future<void> openSettings() async {
    try {
      await _calendarBridge.openSettings();
    } on CalendarBridgeException catch (e) {
      AppLogger.error('Failed to open settings', error: e);
      throw UnknownError('Failed to open settings', e);
    }
  }

  // MARK: - Calendar Sources

  /// Get calendar sources from device and update cache
  Future<List<CalendarSource>> syncCalendarSources() async {
    try {
      final hasPerms = await hasPermissions();
      if (!hasPerms) {
        throw PermissionError(
          'Calendar permissions not granted',
          'Please grant calendar permissions in settings',
        );
      }

      final sources = await _calendarBridge.getCalendarSources();

      // Preserve selection state from cache
      final cached = await _localDatasource.getCalendarSources();
      final selectedIds = cached
          .where((c) => c.isSelected)
          .map((c) => c.id)
          .toSet();

      final sourcesWithSelection = sources.map((source) {
        final wasSelected = selectedIds.contains(source.id);
        return source.copyWith(isSelected: wasSelected);
      }).toList();

      await _localDatasource.saveCalendarSources(sourcesWithSelection);

      AppLogger.info('Synced ${sources.length} calendar sources from device');
      return sourcesWithSelection;
    } on CalendarBridgeException catch (e) {
      AppLogger.error('Failed to sync calendar sources', error: e);
      throw DataError('Failed to sync calendar sources', e);
    } catch (e) {
      AppLogger.error('Unexpected error syncing calendars', error: e);
      throw UnknownError('Failed to sync calendar sources', e);
    }
  }

  /// Get calendar sources from cache
  Future<List<CalendarSource>> getCalendarSources() async {
    try {
      return await _localDatasource.getCalendarSources();
    } catch (e) {
      AppLogger.error('Failed to get calendar sources from cache', error: e);
      throw DatabaseError('Failed to get calendar sources', e);
    }
  }

  /// Get selected calendar sources
  Future<List<CalendarSource>> getSelectedCalendarSources() async {
    try {
      return await _localDatasource.getSelectedCalendarSources();
    } catch (e) {
      AppLogger.error('Failed to get selected calendars', error: e);
      throw DatabaseError('Failed to get selected calendars', e);
    }
  }

  /// Update calendar selection
  Future<void> updateCalendarSelection(String calendarId, bool isSelected) async {
    try {
      await _localDatasource.updateCalendarSelection(calendarId, isSelected);
      AppLogger.info('Updated calendar selection: $calendarId = $isSelected');
    } catch (e) {
      AppLogger.error('Failed to update calendar selection', error: e);
      throw DatabaseError('Failed to update calendar selection', e);
    }
  }

  // MARK: - Calendar Events

  /// Sync calendar events from device
  Future<List<CalendarEvent>> syncCalendarEvents({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final hasPerms = await hasPermissions();
      if (!hasPerms) {
        throw PermissionError(
          'Calendar permissions not granted',
          'Please grant calendar permissions in settings',
        );
      }

      final selectedCalendars = await getSelectedCalendarSources();
      if (selectedCalendars.isEmpty) {
        AppLogger.info('No calendars selected, skipping sync');
        return [];
      }

      final calendarIds = selectedCalendars.map((c) => c.id).toList();
      final events = await _calendarBridge.getEvents(
        calendarIds: calendarIds,
        startDate: startDate,
        endDate: endDate,
      );

      // Cache events for each calendar
      final eventsByCalendar = <String, List<CalendarEvent>>{};
      for (final event in events) {
        eventsByCalendar.putIfAbsent(event.calendarId, () => []).add(event);
      }

      for (final entry in eventsByCalendar.entries) {
        await _localDatasource.saveCalendarEvents(entry.key, entry.value);
      }

      AppLogger.info('Synced ${events.length} calendar events from device');
      return events;
    } on CalendarBridgeException catch (e) {
      AppLogger.error('Failed to sync calendar events', error: e);
      throw DataError('Failed to sync calendar events', e);
    } catch (e) {
      AppLogger.error('Unexpected error syncing events', error: e);
      throw UnknownError('Failed to sync calendar events', e);
    }
  }

  /// Get calendar events (from cache or device)
  Future<List<CalendarEvent>> getCalendarEvents({
    required DateTime startDate,
    required DateTime endDate,
    bool forceSync = false,
  }) async {
    try {
      // Check if we need to sync
      if (forceSync) {
        return await syncCalendarEvents(
          startDate: startDate,
          endDate: endDate,
        );
      }

      // Try to get from cache first
      final cachedEvents = await _localDatasource.getCachedEventsForDateRange(
        startDate: startDate,
        endDate: endDate,
      );

      // If cache is empty or stale, sync
      final lastSyncTime = await _localDatasource.getLastCalendarSyncTime();
      final shouldSync = cachedEvents.isEmpty ||
          lastSyncTime == null ||
          DateTime.now().difference(lastSyncTime).inHours > 1;

      if (shouldSync) {
        final hasPerms = await hasPermissions();
        if (hasPerms) {
          return await syncCalendarEvents(
            startDate: startDate,
            endDate: endDate,
          );
        }
      }

      return cachedEvents;
    } catch (e) {
      AppLogger.error('Failed to get calendar events', error: e);
      // Return cached events as fallback
      return await _localDatasource.getCachedEventsForDateRange(
        startDate: startDate,
        endDate: endDate,
      );
    }
  }

  /// Create calendar event
  Future<String> createCalendarEvent({
    required String calendarId,
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    String? description,
    String? location,
    bool isAllDay = false,
  }) async {
    try {
      final hasPerms = await hasPermissions();
      if (!hasPerms) {
        throw PermissionError(
          'Calendar permissions not granted',
          'Please grant calendar permissions in settings',
        );
      }

      final eventId = await _calendarBridge.createEvent(
        calendarId: calendarId,
        title: title,
        startTime: startTime,
        endTime: endTime,
        description: description,
        location: location,
        isAllDay: isAllDay,
      );

      AppLogger.info('Created calendar event: $eventId');

      // Clear cache to force refresh
      await _localDatasource.clearEventsCache(calendarId);

      return eventId;
    } on CalendarBridgeException catch (e) {
      AppLogger.error('Failed to create calendar event', error: e);
      throw DataError('Failed to create calendar event', e);
    } catch (e) {
      AppLogger.error('Unexpected error creating event', error: e);
      throw UnknownError('Failed to create calendar event', e);
    }
  }

  /// Update calendar event
  Future<void> updateCalendarEvent({
    required String eventId,
    required String calendarId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      final hasPerms = await hasPermissions();
      if (!hasPerms) {
        throw PermissionError(
          'Calendar permissions not granted',
          'Please grant calendar permissions in settings',
        );
      }

      await _calendarBridge.updateEvent(
        eventId: eventId,
        calendarId: calendarId,
        updates: updates,
      );

      AppLogger.info('Updated calendar event: $eventId');

      // Clear cache to force refresh
      await _localDatasource.clearEventsCache(calendarId);
    } on CalendarBridgeException catch (e) {
      AppLogger.error('Failed to update calendar event', error: e);
      throw DataError('Failed to update calendar event', e);
    } catch (e) {
      AppLogger.error('Unexpected error updating event', error: e);
      throw UnknownError('Failed to update calendar event', e);
    }
  }

  /// Delete calendar event
  Future<void> deleteCalendarEvent({
    required String eventId,
    required String calendarId,
  }) async {
    try {
      final hasPerms = await hasPermissions();
      if (!hasPerms) {
        throw PermissionError(
          'Calendar permissions not granted',
          'Please grant calendar permissions in settings',
        );
      }

      await _calendarBridge.deleteEvent(
        eventId: eventId,
        calendarId: calendarId,
      );

      AppLogger.info('Deleted calendar event: $eventId');

      // Clear cache to force refresh
      await _localDatasource.clearEventsCache(calendarId);
    } on CalendarBridgeException catch (e) {
      AppLogger.error('Failed to delete calendar event', error: e);
      throw DataError('Failed to delete calendar event', e);
    } catch (e) {
      AppLogger.error('Unexpected error deleting event', error: e);
      throw UnknownError('Failed to delete calendar event', e);
    }
  }

  // MARK: - Cache Management

  /// Clear all calendar cache
  Future<void> clearCache() async {
    try {
      await _localDatasource.clearCalendarCache();
      AppLogger.info('Cleared calendar cache');
    } catch (e) {
      AppLogger.error('Failed to clear calendar cache', error: e);
      throw DatabaseError('Failed to clear calendar cache', e);
    }
  }

  /// Get cache statistics
  Future<Map<String, dynamic>> getCacheStatistics() async {
    try {
      return await _localDatasource.getCacheStatistics();
    } catch (e) {
      AppLogger.error('Failed to get cache statistics', error: e);
      return {};
    }
  }
}
