import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_event.freezed.dart';
part 'calendar_event.g.dart';

/// Calendar event model
///
/// Represents an event from the device's native calendar.
/// Includes support for recurring events, all-day events, and attendees.
@freezed
abstract class CalendarEvent with _$CalendarEvent {
  const factory CalendarEvent({
    required String id,
    required String calendarId,
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    required bool isAllDay,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? description,
    String? location,
    String? recurrenceRule,
    String? timezone,
    List<String>? attendees,
    String? organizerEmail,
    CalendarEventStatus? status,
    bool? isOrganizer,
    String? meetingUrl,
    Map<String, dynamic>? metadata,
  }) = _CalendarEvent;

  const CalendarEvent._();

  factory CalendarEvent.fromJson(Map<String, dynamic> json) =>
      _$CalendarEventFromJson(json);

  /// Create a calendar event from platform-specific data
  factory CalendarEvent.fromPlatform({
    required String id,
    required String calendarId,
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    bool isAllDay = false,
    String? description,
    String? location,
    String? recurrenceRule,
    String? timezone,
    List<String>? attendees,
    String? organizerEmail,
    String? status,
    bool? isOrganizer,
    String? meetingUrl,
    Map<String, dynamic>? metadata,
  }) =>
      CalendarEvent(
        id: id,
        calendarId: calendarId,
        title: title,
        description: description,
        location: location,
        startTime: startTime,
        endTime: endTime,
        isAllDay: isAllDay,
        recurrenceRule: recurrenceRule,
        timezone: timezone,
        attendees: attendees,
        organizerEmail: organizerEmail,
        status: _parseStatus(status),
        isOrganizer: isOrganizer,
        meetingUrl: meetingUrl,
        metadata: metadata,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  static CalendarEventStatus? _parseStatus(String? status) {
    if (status == null) return null;
    switch (status.toLowerCase()) {
      case 'confirmed':
        return CalendarEventStatus.confirmed;
      case 'tentative':
        return CalendarEventStatus.tentative;
      case 'cancelled':
        return CalendarEventStatus.cancelled;
      default:
        return CalendarEventStatus.confirmed;
    }
  }
}

/// Calendar event status
enum CalendarEventStatus {
  confirmed,
  tentative,
  cancelled,
}

/// Extension methods for CalendarEvent
extension CalendarEventX on CalendarEvent {
  /// Get duration in minutes
  int get durationMinutes => endTime.difference(startTime).inMinutes;

  /// Get formatted duration string
  String get formattedDuration {
    final duration = endTime.difference(startTime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}m';
    }
  }

  /// Get time range string (e.g., "9:00 AM - 10:30 AM")
  String get timeRange {
    if (isAllDay) {
      return 'All day';
    }

    final startHour =
        startTime.hour > 12 ? startTime.hour - 12 : startTime.hour;
    final startMinute = startTime.minute.toString().padLeft(2, '0');
    final startPeriod = startTime.hour >= 12 ? 'PM' : 'AM';
    final displayStartHour = startHour == 0 ? 12 : startHour;

    final endHour = endTime.hour > 12 ? endTime.hour - 12 : endTime.hour;
    final endMinute = endTime.minute.toString().padLeft(2, '0');
    final endPeriod = endTime.hour >= 12 ? 'PM' : 'AM';
    final displayEndHour = endHour == 0 ? 12 : endHour;

    return '$displayStartHour:$startMinute $startPeriod - '
        '$displayEndHour:$endMinute $endPeriod';
  }

  /// Check if event is currently active
  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(startTime) && now.isBefore(endTime);
  }

  /// Check if event is in the past
  bool get isPast => endTime.isBefore(DateTime.now());

  /// Check if event is in the future
  bool get isFuture => startTime.isAfter(DateTime.now());

  /// Check if event is today
  bool get isToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eventDate = DateTime(startTime.year, startTime.month, startTime.day);
    return eventDate == today;
  }

  /// Check if event is recurring
  bool get isRecurring =>
      recurrenceRule != null && recurrenceRule!.isNotEmpty;

  /// Check if event has attendees
  bool get hasAttendees => attendees != null && attendees!.isNotEmpty;

  /// Check if event is a meeting (has attendees or meeting URL)
  bool get isMeeting =>
      hasAttendees || (meetingUrl != null && meetingUrl!.isNotEmpty);

  /// Get short description for display
  String get shortDescription {
    if (description == null || description!.isEmpty) {
      return location ?? 'No description';
    }

    if (description!.length <= 100) {
      return description!;
    }

    return '${description!.substring(0, 97)}...';
  }

  /// Check if event conflicts with a time range
  bool conflictsWith(DateTime start, DateTime end) {
    // Event starts during the time range
    if (startTime.isAfter(start) && startTime.isBefore(end)) {
      return true;
    }

    // Event ends during the time range
    if (endTime.isAfter(start) && endTime.isBefore(end)) {
      return true;
    }

    // Event completely encompasses the time range
    if (startTime.isBefore(start) && endTime.isAfter(end)) {
      return true;
    }

    return false;
  }

  /// Convert to time block for routine integration
  Map<String, dynamic> toTimeBlockData() => {
        'title': title,
        'description': description,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime.toIso8601String(),
        'activity_type': _inferActivityType(),
        'location': location,
        'is_calendar_event': true,
        'calendar_event_id': id,
      };

  /// Infer activity type from event title and description
  String _inferActivityType() {
    final searchText =
        '${title.toLowerCase()} ${description?.toLowerCase() ?? ''}';

    if (searchText.contains('meeting') ||
        searchText.contains('call') ||
        searchText.contains('zoom') ||
        searchText.contains('teams') ||
        isMeeting) {
      return 'meeting';
    }

    if (searchText.contains('lunch') ||
        searchText.contains('dinner') ||
        searchText.contains('breakfast') ||
        searchText.contains('meal')) {
      return 'meal';
    }

    if (searchText.contains('exercise') ||
        searchText.contains('gym') ||
        searchText.contains('workout') ||
        searchText.contains('run') ||
        searchText.contains('yoga')) {
      return 'exercise';
    }

    if (searchText.contains('commute') ||
        searchText.contains('travel') ||
        searchText.contains('drive')) {
      return 'commute';
    }

    if (searchText.contains('focus') ||
        searchText.contains('deep work') ||
        searchText.contains('coding')) {
      return 'focus';
    }

    // Default to work for calendar events
    return 'work';
  }
}
