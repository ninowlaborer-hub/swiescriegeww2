import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_block.freezed.dart';
part 'time_block.g.dart';

/// Time block within a daily routine
///
/// Represents a scheduled activity or task with start/end times.
/// Can be from calendar, AI-generated, or manually added.
@freezed
abstract class TimeBlock with _$TimeBlock {
  const factory TimeBlock({
    required String id,
    required String routineId,
    required String title,
    String? description,
    required DateTime startTime,
    required DateTime endTime,
    required String activityType,
    String? category,
    @Default(0) int priority,
    @Default(false) bool isSnoozed,
    DateTime? snoozedUntil,
    String? source, // calendar, ai, manual
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TimeBlock;

  factory TimeBlock.fromJson(Map<String, dynamic> json) =>
      _$TimeBlockFromJson(json);
}

/// Activity types for time blocks
class ActivityType {
  static const String work = 'work';
  static const String meeting = 'meeting';
  static const String exercise = 'exercise';
  static const String meal = 'meal';
  static const String sleep = 'sleep';
  static const String personal = 'personal';
  static const String commute = 'commute';
  static const String break_ = 'break';
  static const String focus = 'focus';
  static const String social = 'social';
  static const String learning = 'learning';
  static const String entertainment = 'entertainment';
  static const String chores = 'chores';
  static const String other = 'other';

  /// All activity types
  static const List<String> all = [
    work,
    meeting,
    exercise,
    meal,
    sleep,
    personal,
    commute,
    break_,
    focus,
    social,
    learning,
    entertainment,
    chores,
    other,
  ];

  /// Get display name for activity type
  static String getDisplayName(String type) {
    switch (type) {
      case work:
        return 'Work';
      case meeting:
        return 'Meeting';
      case exercise:
        return 'Exercise';
      case meal:
        return 'Meal';
      case sleep:
        return 'Sleep';
      case personal:
        return 'Personal Time';
      case commute:
        return 'Commute';
      case break_:
        return 'Break';
      case focus:
        return 'Focus Time';
      case social:
        return 'Social';
      case learning:
        return 'Learning';
      case entertainment:
        return 'Entertainment';
      case chores:
        return 'Chores';
      default:
        return 'Other';
    }
  }
}

/// Extension methods for TimeBlock
extension TimeBlockX on TimeBlock {
  /// Get duration in minutes
  int get durationMinutes {
    return endTime.difference(startTime).inMinutes;
  }

  /// Check if block is currently active
  bool get isActive {
    final now = DateTime.now();
    return startTime.isBefore(now) && endTime.isAfter(now);
  }

  /// Check if block is in the past
  bool get isPast {
    return endTime.isBefore(DateTime.now());
  }

  /// Check if block is in the future
  bool get isFuture {
    return startTime.isAfter(DateTime.now());
  }

  /// Get formatted time range (e.g., "9:00 AM - 10:30 AM")
  String get timeRange {
    final startHour = startTime.hour;
    final startMinute = startTime.minute;
    final endHour = endTime.hour;
    final endMinute = endTime.minute;

    final startPeriod = startHour >= 12 ? 'PM' : 'AM';
    final endPeriod = endHour >= 12 ? 'PM' : 'AM';

    final startHour12 = startHour > 12
        ? startHour - 12
        : (startHour == 0 ? 12 : startHour);
    final endHour12 = endHour > 12
        ? endHour - 12
        : (endHour == 0 ? 12 : endHour);

    final startMinuteStr = startMinute.toString().padLeft(2, '0');
    final endMinuteStr = endMinute.toString().padLeft(2, '0');

    return '$startHour12:$startMinuteStr $startPeriod - $endHour12:$endMinuteStr $endPeriod';
  }

  /// Get formatted duration (e.g., "1h 30m", "45m")
  String get formattedDuration {
    final duration = durationMinutes;
    final hours = duration ~/ 60;
    final minutes = duration % 60;

    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}m';
    }
  }

  /// Check if block conflicts with another block
  bool conflictsWith(TimeBlock other) {
    return (startTime.isBefore(other.endTime) &&
            endTime.isAfter(other.startTime)) ||
        (other.startTime.isBefore(endTime) && other.endTime.isAfter(startTime));
  }
}
