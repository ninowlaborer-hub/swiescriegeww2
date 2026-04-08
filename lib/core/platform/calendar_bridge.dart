import 'package:flutter/services.dart';
import '../../features/calendar/domain/calendar_event.dart';
import '../../features/calendar/domain/calendar_source.dart';

/// Platform bridge for calendar access
///
/// Provides access to device native calendars via EventKit (iOS)
/// and Calendar Provider (Android). All operations are local to the device.
class CalendarBridge {
  static const MethodChannel _channel =
      MethodChannel('com.swisscierge/calendar');

  /// Request calendar permissions
  ///
  /// Returns true if permissions granted, false otherwise.
  /// On iOS: Requests EventKit calendar access
  /// On Android: Requests READ_CALENDAR and WRITE_CALENDAR permissions
  Future<bool> requestPermissions() async {
    try {
      final result = await _channel.invokeMethod<bool>('requestPermissions');
      return result ?? false;
    } on MissingPluginException catch (_) {
      // Calendar bridge not implemented yet, return false
      return false;
    } on PlatformException catch (e) {
      throw CalendarBridgeException(
        'Failed to request permissions',
        e.code,
        e.message,
      );
    }
  }

  /// Check if calendar permissions are granted
  Future<bool> hasPermissions() async {
    try {
      final result = await _channel.invokeMethod<bool>('hasPermissions');
      return result ?? false;
    } on MissingPluginException catch (_) {
      // Calendar bridge not implemented yet, return false
      return false;
    } on PlatformException catch (e) {
      throw CalendarBridgeException(
        'Failed to check permissions',
        e.code,
        e.message,
      );
    }
  }

  /// Get all calendar sources from device
  ///
  /// Returns list of calendars available on the device.
  /// Includes calendars from all accounts (Google, iCloud, etc.)
  Future<List<CalendarSource>> getCalendarSources() async {
    try {
      final result = await _channel.invokeMethod<List<dynamic>>('getCalendarSources');
      if (result == null) return [];

      return result
          .map((item) => CalendarSource.fromPlatform(
                id: item['id'] as String,
                name: item['name'] as String,
                accountName: item['account_name'] as String?,
                accountType: item['account_type'] as String?,
                color: item['color'] as int? ?? 0xFF2196F3,
                isPrimary: item['is_primary'] as bool? ?? false,
                isReadOnly: item['is_read_only'] as bool? ?? false,
                sourceType: item['source_type'] as String?,
                metadata: item['metadata'] as Map<String, dynamic>?,
              ))
          .toList();
    } on PlatformException catch (e) {
      throw CalendarBridgeException(
        'Failed to get calendar sources',
        e.code,
        e.message,
      );
    }
  }

  /// Get events from selected calendars
  ///
  /// [calendarIds]: List of calendar IDs to fetch events from
  /// [startDate]: Start date for event query
  /// [endDate]: End date for event query
  ///
  /// Returns list of calendar events in the specified date range.
  Future<List<CalendarEvent>> getEvents({
    required List<String> calendarIds,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final result = await _channel.invokeMethod<List<dynamic>>('getEvents', {
        'calendar_ids': calendarIds,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
      });

      if (result == null) return [];

      return result
          .map((item) => CalendarEvent.fromPlatform(
                id: item['id'] as String,
                calendarId: item['calendar_id'] as String,
                title: item['title'] as String,
                description: item['description'] as String?,
                location: item['location'] as String?,
                startTime: DateTime.parse(item['start_time'] as String),
                endTime: DateTime.parse(item['end_time'] as String),
                isAllDay: item['is_all_day'] as bool? ?? false,
                recurrenceRule: item['recurrence_rule'] as String?,
                timezone: item['timezone'] as String?,
                attendees: (item['attendees'] as List?)?.cast<String>(),
                organizerEmail: item['organizer_email'] as String?,
                status: item['status'] as String?,
                isOrganizer: item['is_organizer'] as bool?,
                meetingUrl: item['meeting_url'] as String?,
                metadata: item['metadata'] as Map<String, dynamic>?,
              ))
          .toList();
    } on PlatformException catch (e) {
      throw CalendarBridgeException(
        'Failed to get events',
        e.code,
        e.message,
      );
    }
  }

  /// Create a calendar event
  ///
  /// [calendarId]: ID of the calendar to create event in
  /// [title]: Event title
  /// [startTime]: Event start time
  /// [endTime]: Event end time
  /// [description]: Optional event description
  /// [location]: Optional event location
  /// [isAllDay]: Whether this is an all-day event
  ///
  /// Returns the ID of the created event.
  Future<String> createEvent({
    required String calendarId,
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    String? description,
    String? location,
    bool isAllDay = false,
  }) async {
    try {
      final result = await _channel.invokeMethod<String>('createEvent', {
        'calendar_id': calendarId,
        'title': title,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime.toIso8601String(),
        'description': description,
        'location': location,
        'is_all_day': isAllDay,
      });

      if (result == null) {
        throw CalendarBridgeException(
          'Failed to create event',
          'NULL_RESULT',
          'Platform returned null event ID',
        );
      }

      return result;
    } on PlatformException catch (e) {
      throw CalendarBridgeException(
        'Failed to create event',
        e.code,
        e.message,
      );
    }
  }

  /// Update an existing calendar event
  ///
  /// [eventId]: ID of the event to update
  /// [calendarId]: ID of the calendar containing the event
  /// [updates]: Map of fields to update
  ///
  /// Returns true if update successful.
  Future<bool> updateEvent({
    required String eventId,
    required String calendarId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      final result = await _channel.invokeMethod<bool>('updateEvent', {
        'event_id': eventId,
        'calendar_id': calendarId,
        'updates': updates,
      });

      return result ?? false;
    } on PlatformException catch (e) {
      throw CalendarBridgeException(
        'Failed to update event',
        e.code,
        e.message,
      );
    }
  }

  /// Delete a calendar event
  ///
  /// [eventId]: ID of the event to delete
  /// [calendarId]: ID of the calendar containing the event
  ///
  /// Returns true if deletion successful.
  Future<bool> deleteEvent({
    required String eventId,
    required String calendarId,
  }) async {
    try {
      final result = await _channel.invokeMethod<bool>('deleteEvent', {
        'event_id': eventId,
        'calendar_id': calendarId,
      });

      return result ?? false;
    } on PlatformException catch (e) {
      throw CalendarBridgeException(
        'Failed to delete event',
        e.code,
        e.message,
      );
    }
  }

  /// Open device settings to manage calendar permissions
  Future<void> openSettings() async {
    try {
      await _channel.invokeMethod<void>('openSettings');
    } on PlatformException catch (e) {
      throw CalendarBridgeException(
        'Failed to open settings',
        e.code,
        e.message,
      );
    }
  }
}

/// Exception thrown by calendar bridge
class CalendarBridgeException implements Exception {
  const CalendarBridgeException(this.message, this.code, this.details);

  final String message;
  final String code;
  final String? details;

  @override
  String toString() {
    if (details != null) {
      return 'CalendarBridgeException: $message (Code: $code, Details: $details)';
    }
    return 'CalendarBridgeException: $message (Code: $code)';
  }
}
