import '../../../core/logging/logger.dart';
import '../../../shared/services/connectivity_service.dart';
import '../data/calendar_repository.dart';
import 'calendar_event.dart';
import 'calendar_source.dart';

/// Calendar service
///
/// Orchestrates calendar operations with offline-first strategy.
/// Handles syncing, caching, and integration with routine generation.
class CalendarService {
  CalendarService({
    required this.repository,
    required this.connectivityService,
  });

  final CalendarRepository repository;
  final ConnectivityService connectivityService;

  // MARK: - Permissions

  /// Request calendar permissions
  Future<bool> requestPermissions() async {
    try {
      AppLogger.info('Requesting calendar permissions');
      return await repository.requestPermissions();
    } catch (e) {
      AppLogger.error('Failed to request calendar permissions', error: e);
      rethrow;
    }
  }

  /// Check if calendar permissions are granted
  Future<bool> hasPermissions() async {
    return await repository.hasPermissions();
  }

  /// Open device settings
  Future<void> openSettings() async {
    await repository.openSettings();
  }

  // MARK: - Calendar Sources

  /// Sync calendar sources from device
  ///
  /// This should be called when:
  /// - First time user grants permissions
  /// - User manually refreshes calendar list
  /// - App comes to foreground after being in background
  Future<List<CalendarSource>> syncCalendarSources() async {
    try {
      AppLogger.info('Syncing calendar sources from device');
      return await repository.syncCalendarSources();
    } catch (e) {
      AppLogger.error('Failed to sync calendar sources', error: e);
      rethrow;
    }
  }

  /// Get calendar sources (from cache)
  Future<List<CalendarSource>> getCalendarSources() async {
    try {
      return await repository.getCalendarSources();
    } catch (e) {
      AppLogger.error('Failed to get calendar sources', error: e);
      rethrow;
    }
  }

  /// Get selected calendar sources
  Future<List<CalendarSource>> getSelectedCalendarSources() async {
    try {
      return await repository.getSelectedCalendarSources();
    } catch (e) {
      AppLogger.error('Failed to get selected calendars', error: e);
      rethrow;
    }
  }

  /// Update calendar selection
  Future<void> updateCalendarSelection(
    String calendarId,
    bool isSelected,
  ) async {
    try {
      await repository.updateCalendarSelection(calendarId, isSelected);
      AppLogger.info('Calendar selection updated: $calendarId = $isSelected');
    } catch (e) {
      AppLogger.error('Failed to update calendar selection', error: e);
      rethrow;
    }
  }

  /// Select multiple calendars
  Future<void> selectCalendars(List<String> calendarIds) async {
    try {
      final allSources = await getCalendarSources();

      for (final source in allSources) {
        final shouldSelect = calendarIds.contains(source.id);
        await updateCalendarSelection(source.id, shouldSelect);
      }

      AppLogger.info('Updated selection for ${calendarIds.length} calendars');
    } catch (e) {
      AppLogger.error('Failed to select calendars', error: e);
      rethrow;
    }
  }

  // MARK: - Calendar Events

  /// Get calendar events for date range
  ///
  /// Uses offline-first strategy:
  /// 1. Return cached events if available and recent (< 1 hour)
  /// 2. Sync from device if cache is stale or empty
  /// 3. Fallback to cache on error
  Future<List<CalendarEvent>> getCalendarEvents({
    required DateTime startDate,
    required DateTime endDate,
    bool forceSync = false,
  }) async {
    try {
      AppLogger.info(
        'Getting calendar events from $startDate to $endDate (forceSync: $forceSync)',
      );

      return await repository.getCalendarEvents(
        startDate: startDate,
        endDate: endDate,
        forceSync: forceSync,
      );
    } catch (e) {
      AppLogger.error('Failed to get calendar events', error: e);
      rethrow;
    }
  }

  /// Get events for today
  Future<List<CalendarEvent>> getTodaysEvents() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return getCalendarEvents(
      startDate: startOfDay,
      endDate: endOfDay,
    );
  }

  /// Get events for next N days
  Future<List<CalendarEvent>> getUpcomingEvents({int days = 7}) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endDate = startOfDay.add(Duration(days: days));

    return getCalendarEvents(
      startDate: startOfDay,
      endDate: endDate,
    );
  }

  /// Get active event (happening now)
  Future<CalendarEvent?> getActiveEvent() async {
    final events = await getTodaysEvents();
    final now = DateTime.now();

    for (final event in events) {
      if (event.startTime.isBefore(now) && event.endTime.isAfter(now)) {
        return event;
      }
    }

    return null;
  }

  /// Get next upcoming event
  Future<CalendarEvent?> getNextEvent() async {
    final events = await getUpcomingEvents(days: 7);
    final now = DateTime.now();

    for (final event in events) {
      if (event.startTime.isAfter(now)) {
        return event;
      }
    }

    return null;
  }

  // MARK: - Event Creation

  /// Create calendar event from time block
  ///
  /// This is used when user accepts a routine and wants to
  /// write time blocks to their device calendar.
  Future<String> createEventFromTimeBlock({
    required String calendarId,
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    String? description,
    String? location,
    bool isAllDay = false,
  }) async {
    try {
      AppLogger.info('Creating calendar event: $title');

      return await repository.createCalendarEvent(
        calendarId: calendarId,
        title: title,
        startTime: startTime,
        endTime: endTime,
        description: description,
        location: location,
        isAllDay: isAllDay,
      );
    } catch (e) {
      AppLogger.error('Failed to create calendar event', error: e);
      rethrow;
    }
  }

  /// Update calendar event
  Future<void> updateCalendarEvent({
    required String eventId,
    required String calendarId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      AppLogger.info('Updating calendar event: $eventId');

      await repository.updateCalendarEvent(
        eventId: eventId,
        calendarId: calendarId,
        updates: updates,
      );
    } catch (e) {
      AppLogger.error('Failed to update calendar event', error: e);
      rethrow;
    }
  }

  /// Delete calendar event
  Future<void> deleteCalendarEvent({
    required String eventId,
    required String calendarId,
  }) async {
    try {
      AppLogger.info('Deleting calendar event: $eventId');

      await repository.deleteCalendarEvent(
        eventId: eventId,
        calendarId: calendarId,
      );
    } catch (e) {
      AppLogger.error('Failed to delete calendar event', error: e);
      rethrow;
    }
  }

  // MARK: - Sync Status

  /// Check if we're in offline mode
  bool get isOffline {
    return connectivityService.currentStatus == ConnectivityStatus.offline;
  }

  /// Get sync status information
  Future<Map<String, dynamic>> getSyncStatus() async {
    final cacheStats = await repository.getCacheStatistics();
    final hasPerms = await hasPermissions();
    final selectedCalendars = await getSelectedCalendarSources();

    return {
      'has_permissions': hasPerms,
      'selected_calendars': selectedCalendars.length,
      'is_offline': isOffline,
      ...cacheStats,
    };
  }

  /// Clear calendar cache
  Future<void> clearCache() async {
    try {
      await repository.clearCache();
      AppLogger.info('Calendar cache cleared');
    } catch (e) {
      AppLogger.error('Failed to clear calendar cache', error: e);
      rethrow;
    }
  }

  // MARK: - Integration Helpers

  /// Get calendar data for routine generation
  ///
  /// Returns events formatted for ML model input.
  /// Includes conflict detection and time block suggestions.
  Future<Map<String, dynamic>> getCalendarDataForRoutine({
    required DateTime date,
  }) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final events = await getCalendarEvents(
      startDate: startOfDay,
      endDate: endOfDay,
    );

    // Convert events to time block format for ML
    final eventBlocks = events.map((event) {
      return {
        'title': event.title,
        'start_time': event.startTime.toIso8601String(),
        'end_time': event.endTime.toIso8601String(),
        'is_meeting': event.isMeeting,
        'is_all_day': event.isAllDay,
        'activity_type': event.toTimeBlockData()['activity_type'],
        'location': event.location,
      };
    }).toList();

    // Calculate busy/free periods
    final busyPeriods = _calculateBusyPeriods(events, startOfDay, endOfDay);
    final freePeriods = _calculateFreePeriods(busyPeriods, startOfDay, endOfDay);

    return {
      'date': date.toIso8601String(),
      'events': eventBlocks,
      'busy_periods': busyPeriods,
      'free_periods': freePeriods,
      'total_events': events.length,
      'total_busy_minutes': _calculateTotalBusyMinutes(events),
    };
  }

  List<Map<String, dynamic>> _calculateBusyPeriods(
    List<CalendarEvent> events,
    DateTime startOfDay,
    DateTime endOfDay,
  ) {
    final busyPeriods = <Map<String, dynamic>>[];

    for (final event in events) {
      if (!event.isAllDay) {
        busyPeriods.add({
          'start': event.startTime.toIso8601String(),
          'end': event.endTime.toIso8601String(),
          'duration_minutes': event.durationMinutes,
        });
      }
    }

    return busyPeriods;
  }

  List<Map<String, dynamic>> _calculateFreePeriods(
    List<Map<String, dynamic>> busyPeriods,
    DateTime startOfDay,
    DateTime endOfDay,
  ) {
    if (busyPeriods.isEmpty) {
      return [
        {
          'start': startOfDay.toIso8601String(),
          'end': endOfDay.toIso8601String(),
          'duration_minutes': 24 * 60,
        }
      ];
    }

    final freePeriods = <Map<String, dynamic>>[];
    var currentTime = startOfDay;

    // Sort busy periods by start time
    final sortedBusy = List<Map<String, dynamic>>.from(busyPeriods)
      ..sort((a, b) => DateTime.parse(a['start'] as String)
          .compareTo(DateTime.parse(b['start'] as String)));

    for (final busy in sortedBusy) {
      final busyStart = DateTime.parse(busy['start'] as String);

      if (currentTime.isBefore(busyStart)) {
        freePeriods.add({
          'start': currentTime.toIso8601String(),
          'end': busyStart.toIso8601String(),
          'duration_minutes': busyStart.difference(currentTime).inMinutes,
        });
      }

      final busyEnd = DateTime.parse(busy['end'] as String);
      currentTime = busyEnd.isAfter(currentTime) ? busyEnd : currentTime;
    }

    // Add remaining free time after last busy period
    if (currentTime.isBefore(endOfDay)) {
      freePeriods.add({
        'start': currentTime.toIso8601String(),
        'end': endOfDay.toIso8601String(),
        'duration_minutes': endOfDay.difference(currentTime).inMinutes,
      });
    }

    return freePeriods;
  }

  int _calculateTotalBusyMinutes(List<CalendarEvent> events) {
    return events
        .where((e) => !e.isAllDay)
        .fold(0, (sum, event) => sum + event.durationMinutes);
  }
}
