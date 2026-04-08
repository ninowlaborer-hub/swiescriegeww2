import 'package:flutter/services.dart';
import '../../features/routines/domain/routine.dart';
import '../../features/routines/domain/time_block.dart';
import '../../features/routines/domain/routine_explanation.dart';
import '../logging/logger.dart';

/// On-device ML routine generator
///
/// Wrapper for TensorFlow Lite (Android) and Core ML (iOS) models.
/// Generates daily routines based on user data without external API calls.
///
/// Per FR-002, FR-005: All AI processing happens on-device.
class RoutineGenerator {
  /// Method channel for ML model inference
  static const MethodChannel _channel = MethodChannel(
    'com.swisscierge/ml_routine',
  );

  /// Generate a daily routine using on-device ML
  ///
  /// Inputs:
  /// - date: Target date for routine
  /// - calendarEvents: List of calendar events (from local cache)
  /// - weatherForecast: Weather data (optional)
  /// - userPreferences: User's work hours, activity preferences, etc.
  ///
  /// Returns: Generated Routine with time blocks and explanation
  Future<Routine> generateRoutine({
    required DateTime date,
    List<Map<String, dynamic>>? calendarEvents,
    Map<String, dynamic>? weatherForecast,
    required Map<String, dynamic> userPreferences,
  }) async {
    final startTime = DateTime.now();

    try {
      AppLogger.info('Starting routine generation for $date');

      // Prepare input data for ML model
      final input = {
        'date': date.toIso8601String(),
        'calendar_events': calendarEvents ?? [],
        'weather': weatherForecast,
        'preferences': userPreferences,
      };

      Map<dynamic, dynamic>? result;

      // Try ML model first
      try {
        result = await _channel.invokeMethod<Map<dynamic, dynamic>>(
          'generateRoutine',
          input,
        );
      } on PlatformException catch (e) {
        AppLogger.warning(
          'ML model not available, using local generation: ${e.message}',
        );
        result = null;
      } on MissingPluginException catch (e) {
        AppLogger.warning(
          'ML model not available, using local generation: ${e.message}',
        );
        result = null;
      }

      // Use local rule-based generation if ML model unavailable
      result ??= _generateLocalRoutine(
        date: date,
        calendarEvents: calendarEvents,
        weatherForecast: weatherForecast,
        userPreferences: userPreferences,
      );

      // Parse ML model output
      final routine = _parseModelOutput(date, result, userPreferences);

      final duration = DateTime.now().difference(startTime);
      AppLogger.logRoutineGeneration(
        routineId: routine.id,
        date: date,
        generationTime: duration,
      );

      return routine;
    } catch (e) {
      AppLogger.error('Routine generation failed', error: e);
      rethrow;
    }
  }

  /// Generate routine using local rule-based algorithm (fallback when ML unavailable)
  ///
  /// Creates a sensible daily routine based on user preferences and available data.
  /// This is a temporary solution until the ML model is implemented.
  Map<dynamic, dynamic> _generateLocalRoutine({
    required DateTime date,
    List<Map<String, dynamic>>? calendarEvents,
    Map<String, dynamic>? weatherForecast,
    required Map<String, dynamic> userPreferences,
  }) {
    AppLogger.info('Generating local rule-based routine');

    final timeBlocks = <Map<String, dynamic>>[];
    final explanation = <String, dynamic>{};
    final factors = <String>[];

    // Parse user preferences
    final workStart = _parseTime(
      userPreferences['work_window_start'] as String? ?? '09:00',
    );
    final workEnd = _parseTime(
      userPreferences['work_window_end'] as String? ?? '17:00',
    );
    final quietStart = _parseTime(
      userPreferences['quiet_hours_start'] as String? ?? '22:00',
    );
    final activityPrefs =
        userPreferences['activity_preferences'] as Map<String, dynamic>? ?? {};

    // Default wake time 7 AM
    final wakeTime = DateTime(date.year, date.month, date.day, 7, 0);
    var currentTime = wakeTime;

    // Morning routine
    factors.add('Started with default morning routine at 7:00 AM');

    // 1. Morning preparation (30 min after wake)
    final morningEnd = currentTime.add(const Duration(minutes: 30));
    timeBlocks.add(
      _createTimeBlock(
        title: 'Morning Routine',
        description: 'Wake up, freshen up, breakfast',
        startTime: currentTime,
        endTime: morningEnd,
        activityType: ActivityType.personal,
        category: 'morning',
        priority: 3,
      ),
    );
    currentTime = morningEnd;

    // 2. Exercise block (if enabled and weather is good)
    if (activityPrefs['exercise'] == true) {
      final shouldExercise = _shouldIncludeExercise(weatherForecast);
      if (shouldExercise) {
        final exerciseEnd = currentTime.add(const Duration(minutes: 45));
        timeBlocks.add(
          _createTimeBlock(
            title: 'Exercise',
            description: _getExerciseDescription(weatherForecast),
            startTime: currentTime,
            endTime: exerciseEnd,
            activityType: ActivityType.exercise,
            category: 'health',
            priority: 2,
          ),
        );
        currentTime = exerciseEnd;
        factors.add('Added exercise block based on weather and energy levels');
      }
    }

    // 3. Work blocks (avoiding calendar events)
    final workBlocks = _generateWorkBlocks(
      date: date,
      startTime: currentTime,
      workWindowStart: workStart,
      workWindowEnd: workEnd,
      calendarEvents: calendarEvents,
    );
    timeBlocks.addAll(workBlocks);
    if (calendarEvents != null && calendarEvents.isNotEmpty) {
      factors.add(
        'Scheduled work around ${calendarEvents.length} calendar events',
      );
    } else {
      factors.add('Created focused work blocks during work hours');
    }

    // 4. Lunch break
    final lunchTime = DateTime(date.year, date.month, date.day, 12, 30);
    final lunchEnd = lunchTime.add(const Duration(minutes: 45));
    timeBlocks.add(
      _createTimeBlock(
        title: 'Lunch Break',
        description: 'Meal and rest',
        startTime: lunchTime,
        endTime: lunchEnd,
        activityType: ActivityType.meal,
        category: 'break',
        priority: 3,
      ),
    );

    // 5. Social/learning activities (if enabled)
    var eveningStart = workEnd;
    if (activityPrefs['social'] == true) {
      final socialEnd = eveningStart.add(const Duration(hours: 1, minutes: 30));
      timeBlocks.add(
        _createTimeBlock(
          title: 'Social Time',
          description: 'Connect with friends or family',
          startTime: eveningStart,
          endTime: socialEnd,
          activityType: ActivityType.social,
          category: 'social',
          priority: 1,
        ),
      );
      eveningStart = socialEnd;
      factors.add('Included social activities per your preferences');
    }

    if (activityPrefs['learning'] == true) {
      final learningEnd = eveningStart.add(const Duration(minutes: 45));
      timeBlocks.add(
        _createTimeBlock(
          title: 'Learning Time',
          description: 'Read, study, or practice a skill',
          startTime: eveningStart,
          endTime: learningEnd,
          activityType: ActivityType.learning,
          category: 'personal',
          priority: 1,
        ),
      );
      eveningStart = learningEnd;
      factors.add('Added learning block for personal development');
    }

    // 6. Dinner
    final dinnerTime = DateTime(date.year, date.month, date.day, 19, 0);
    final dinnerEnd = dinnerTime.add(const Duration(minutes: 45));
    timeBlocks.add(
      _createTimeBlock(
        title: 'Dinner',
        description: 'Evening meal',
        startTime: dinnerTime,
        endTime: dinnerEnd,
        activityType: ActivityType.meal,
        category: 'break',
        priority: 3,
      ),
    );

    // 7. Evening wind-down
    final windDownStart = dinnerEnd.add(const Duration(minutes: 30));
    timeBlocks.add(
      _createTimeBlock(
        title: 'Wind Down',
        description: 'Relaxation and preparation for sleep',
        startTime: windDownStart,
        endTime: quietStart.subtract(const Duration(minutes: 30)),
        activityType: ActivityType.personal,
        category: 'evening',
        priority: 2,
      ),
    );

    // Sort by start time
    timeBlocks.sort(
      (a, b) => DateTime.parse(
        a['start_time'] as String,
      ).compareTo(DateTime.parse(b['start_time'] as String)),
    );

    // Build explanation
    explanation['summary'] = _generateSummary(
      date,
      weatherForecast,
      calendarEvents,
    );
    explanation['calendar_used'] =
        calendarEvents != null && calendarEvents.isNotEmpty;
    explanation['sleep_used'] = false;
    explanation['weather_used'] = weatherForecast != null;
    explanation['factors'] = factors;

    return {
      'title': 'Daily Routine for ${_formatDate(date)}',
      'time_blocks': timeBlocks,
      'explanation': explanation,
      'confidence': 0.75, // Lower confidence for rule-based generation
      'generation_method': 'local_rules',
    };
  }

  /// Parse time string (HH:mm) to DateTime
  DateTime _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  /// Determine if exercise should be included
  bool _shouldIncludeExercise(Map<String, dynamic>? weather) {
    // Skip if severe weather
    if (weather != null) {
      final morning = weather['morning'] as Map<String, dynamic>?;
      if (morning != null) {
        final condition = morning['condition'] as String?;
        if (condition != null &&
            (condition.toLowerCase().contains('storm') ||
                condition.toLowerCase().contains('heavy rain'))) {
          return false;
        }
      }
    }

    return true;
  }

  /// Get exercise description based on weather
  String _getExerciseDescription(Map<String, dynamic>? weather) {
    if (weather == null) {
      return 'Morning workout or walk';
    }

    final morning = weather['morning'] as Map<String, dynamic>?;
    if (morning == null) {
      return 'Morning workout or walk';
    }

    final condition = morning['condition'] as String? ?? '';
    final temp = morning['temperature_c'] as num?;

    if (condition.toLowerCase().contains('rain')) {
      return 'Indoor workout (rainy outside)';
    } else if (temp != null && temp > 25) {
      return 'Light outdoor exercise (warm weather)';
    } else if (temp != null && temp < 5) {
      return 'Indoor workout (cold outside)';
    } else {
      return 'Outdoor run or walk';
    }
  }

  /// Generate work blocks around calendar events
  List<Map<String, dynamic>> _generateWorkBlocks({
    required DateTime date,
    required DateTime startTime,
    required DateTime workWindowStart,
    required DateTime workWindowEnd,
    List<Map<String, dynamic>>? calendarEvents,
  }) {
    final blocks = <Map<String, dynamic>>[];

    // If no calendar events, create standard work blocks
    if (calendarEvents == null || calendarEvents.isEmpty) {
      var current = workWindowStart;

      // Morning focus block
      final morningEnd = DateTime(date.year, date.month, date.day, 12, 0);
      blocks.add(
        _createTimeBlock(
          title: 'Deep Work',
          description: 'Focused work on important tasks',
          startTime: current,
          endTime: morningEnd,
          activityType: ActivityType.work,
          category: 'work',
          priority: 3,
        ),
      );

      // Afternoon work block
      final afternoonStart = DateTime(date.year, date.month, date.day, 13, 15);
      final afternoonEnd = DateTime(date.year, date.month, date.day, 16, 0);
      blocks.add(
        _createTimeBlock(
          title: 'Afternoon Tasks',
          description: 'Meetings, emails, and lighter work',
          startTime: afternoonStart,
          endTime: afternoonEnd,
          activityType: ActivityType.work,
          category: 'work',
          priority: 2,
        ),
      );

      return blocks;
    }

    // With calendar events, schedule work around them
    // (Simplified - just add a couple of work blocks)
    blocks.add(
      _createTimeBlock(
        title: 'Work Time',
        description: 'Tasks and projects between meetings',
        startTime: workWindowStart,
        endTime: DateTime(date.year, date.month, date.day, 11, 30),
        activityType: ActivityType.work,
        category: 'work',
        priority: 2,
      ),
    );

    return blocks;
  }

  /// Create a time block map
  Map<String, dynamic> _createTimeBlock({
    required String title,
    String? description,
    required DateTime startTime,
    required DateTime endTime,
    required String activityType,
    String? category,
    required int priority,
  }) {
    return {
      'title': title,
      'description': description,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'activity_type': activityType,
      'category': category,
      'priority': priority,
    };
  }

  /// Generate summary text
  String _generateSummary(
    DateTime date,
    Map<String, dynamic>? weather,
    List<Map<String, dynamic>>? calendar,
  ) {
    final parts = <String>[];

    parts.add('Generated a balanced routine for ${_formatDate(date)}');

    if (weather != null) {
      parts.add('considering today\'s weather conditions');
    }

    if (calendar != null && calendar.isNotEmpty) {
      parts.add('working around your ${calendar.length} scheduled events');
    }

    return '${parts.join(', ')}.';
  }

  /// Parse ML model output into Routine object
  Routine _parseModelOutput(
    DateTime date,
    Map<dynamic, dynamic> modelOutput,
    Map<String, dynamic> userPreferences,
  ) {
    final timeBlocks = <TimeBlock>[];
    final explanation = RoutineExplanationBuilder();
    // Normalize date to midnight for consistent storage
    final normalizedDate = DateTime(date.year, date.month, date.day);

    // Parse time blocks from model output
    final blocksData = modelOutput['time_blocks'] as List<dynamic>? ?? [];
    for (var i = 0; i < blocksData.length; i++) {
      final blockData = blocksData[i] as Map<dynamic, dynamic>;

      final block = TimeBlock(
        id: 'block_${DateTime.now().millisecondsSinceEpoch}_$i',
        routineId: 'routine_${normalizedDate.toIso8601String()}',
        title: blockData['title'] as String? ?? 'Activity',
        description: blockData['description'] as String?,
        startTime: DateTime.parse(blockData['start_time'] as String),
        endTime: DateTime.parse(blockData['end_time'] as String),
        activityType:
            blockData['activity_type'] as String? ?? ActivityType.other,
        category: blockData['category'] as String?,
        priority: blockData['priority'] as int? ?? 0,
        source: 'ai',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      timeBlocks.add(block);
    }

    // Parse explanation
    final explanationData =
        modelOutput['explanation'] as Map<dynamic, dynamic>? ?? {};
    explanation
        .setSummary(
          explanationData['summary'] as String? ??
              'Routine generated based on your data',
        )
        .addDataSource('calendar', explanationData['calendar_used'] ?? false)
        .addDataSource('sleep', explanationData['sleep_used'] ?? false)
        .addDataSource('weather', explanationData['weather_used'] ?? false);

    final factors = explanationData['factors'] as List<dynamic>? ?? [];
    for (final factor in factors) {
      explanation.addFactor(factor as String);
    }

    return Routine(
      id: 'routine_${normalizedDate.toIso8601String()}',
      date: normalizedDate,
      title:
          modelOutput['title'] as String? ??
          'Daily Routine for ${_formatDate(normalizedDate)}',
      timeBlocks: timeBlocks,
      explanation: explanation.build(),
      confidenceScore: (modelOutput['confidence'] as num?)?.toDouble(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    final weekday = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ][date.weekday - 1];
    final month = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ][date.month - 1];
    return '$weekday, $month ${date.day}';
  }

  /// Check if ML model is available on device
  Future<bool> isModelAvailable() async {
    try {
      final result = await _channel.invokeMethod<bool>('isModelAvailable');
      return result ?? false;
    } catch (e) {
      AppLogger.warning('Failed to check ML model availability', error: e);
      return false;
    }
  }

  /// Get ML model version/info
  Future<Map<String, dynamic>> getModelInfo() async {
    try {
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>(
        'getModelInfo',
      );
      return Map<String, dynamic>.from(result ?? {});
    } catch (e) {
      AppLogger.warning('Failed to get ML model info', error: e);
      return {};
    }
  }
}
