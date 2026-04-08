import 'package:uuid/uuid.dart';
import '../../../core/ml/routine_generator.dart';
import '../../../core/logging/logger.dart';
import '../../../core/error/app_error.dart';
import '../../../core/ai/claude_ai_service.dart';
import '../../../shared/services/connectivity_service.dart';
import '../../../shared/services/location_service.dart';
import '../../weather/domain/weather_service.dart';
import '../../weather/domain/weather_source.dart';
import '../data/routine_repository.dart';
import 'routine.dart';
import 'routine_explanation.dart';
import 'time_block.dart';

/// Service for routine generation and management
///
/// Orchestrates routine generation using Claude AI (if enabled), on-device ML,
/// calendar data, sleep patterns, and weather information. Handles offline-first logic.
class RoutineService {
  RoutineService({
    required this.repository,
    required this.mlGenerator,
    required this.connectivityService,
    this.claudeAiService,
    this.calendarService,
    this.weatherService,
    this.locationService,
  });

  final RoutineRepository repository;
  final RoutineGenerator mlGenerator;
  final ConnectivityService connectivityService;
  final ClaudeAIService?
  claudeAiService; // Optional: Claude AI for enhanced generation
  final dynamic
  calendarService; // Optional: CalendarService from calendar feature
  final WeatherService?
  weatherService; // Optional: WeatherService for weather integration
  final LocationService?
  locationService; // Optional: LocationService for weather

  /// Generate a new routine for specified date
  ///
  /// Uses on-device ML with available data sources:
  /// - Calendar events (from local cache)
  /// - Sleep data (from HealthKit/Health Connect)
  /// - Weather forecast (from cache if offline)
  /// - User preferences
  Future<Routine> generateRoutine({
    required DateTime date,
    Map<String, dynamic>? userPreferences,
    bool forceRegenerate = false,
  }) async {
    try {
      AppLogger.info('Generating routine for $date');

      // Check if routine already exists
      if (!forceRegenerate) {
        final existing = await repository.getRoutineForDate(date);
        if (existing != null) {
          AppLogger.info('Using existing routine for $date');
          return existing;
        }
      } else {
        // If force regenerating, delete the existing routine first
        final existing = await repository.getRoutineForDate(date);
        if (existing != null) {
          AppLogger.info(
            'Deleting existing routine for regeneration: ${existing.id}',
          );
          await repository.deleteRoutine(existing.id);
        }
      }

      // Check ML model availability
      final modelAvailable = await mlGenerator.isModelAvailable();
      if (!modelAvailable) {
        AppLogger.warning('ML model not available, using fallback');
      }

      // Prepare user preferences with defaults
      final prefs = _preparePreferences(userPreferences);

      // Gather calendar events from calendar cache (Phase 4)
      List<Map<String, dynamic>>? calendarEvents;
      if (calendarService != null) {
        try {
          final calendarData = await calendarService.getCalendarDataForRoutine(
            date: date,
          );
          calendarEvents = List<Map<String, dynamic>>.from(
            calendarData['events'] as List? ?? [],
          );
          AppLogger.info(
            'Loaded ${calendarEvents.length} calendar events for routine',
          );
        } catch (e) {
          AppLogger.warning(
            'Failed to load calendar events, continuing without: $e',
          );
          calendarEvents = null;
        }
      }

      // Sleep data removed (health integration removed per App Store requirements)

      // Gather weather forecast for the routine date
      Map<String, dynamic>? weatherForecast;
      if (weatherService != null && locationService != null) {
        try {
          weatherForecast = await _getWeatherForRoutine(
            date: date,
            weatherSource:
                prefs['weather_source'] as WeatherSource? ??
                WeatherSource.openWeatherMap,
          );
          if (weatherForecast != null) {
            AppLogger.info('Loaded weather forecast for routine generation');
          }
        } catch (e) {
          AppLogger.warning(
            'Failed to load weather forecast, continuing without: $e',
          );
          weatherForecast = null;
        }
      }

      // Try Claude AI first (if available and enabled)
      if (claudeAiService != null) {
        try {
          AppLogger.info('Attempting to generate routine with Claude AI');

          // Get existing routine for regeneration context
          Routine? existingRoutine;
          if (forceRegenerate) {
            existingRoutine = await repository.getRoutineForDate(date);
          }

          final claudeResponse = await claudeAiService!.generateRoutine(
            calendarEvents: calendarEvents ?? [],
            weatherData: _formatWeatherDataForClaude(weatherForecast),
            userPreferences: _formatPreferencesForClaude(prefs),
            historicalPatterns:
                null, // TODO: Implement historical pattern extraction
            userFeedback: userPreferences?['regeneration_feedback'] as String?,
            currentTimeBlocks: existingRoutine != null
                ? _formatTimeBlocksForClaude(existingRoutine.timeBlocks)
                : null,
            blocksToChange:
                userPreferences?['blocks_to_change']
                    as List<Map<String, dynamic>>?,
          );

          // Convert Claude response to Routine object
          final routine = _convertClaudeResponseToRoutine(claudeResponse, date);

          // Delete existing routine if regenerating (to avoid UNIQUE constraint)
          if (forceRegenerate && existingRoutine != null) {
            AppLogger.info(
              'Deleting existing routine before saving regenerated one',
            );
            await repository.deleteRoutine(existingRoutine.id);
          }

          // Save to local storage
          await repository.saveRoutine(routine);

          AppLogger.info(
            'Routine generated with Claude AI and saved for $date',
          );
          return routine;
        } on ClaudeAIException catch (e) {
          AppLogger.warning(
            'Claude AI failed, falling back to on-device ML: ${e.message}',
          );
          // Fall through to on-device ML
        } catch (e) {
          AppLogger.warning(
            'Claude AI error, falling back to on-device ML: $e',
          );
          // Fall through to on-device ML
        }
      }

      // Fallback: Generate routine using on-device ML model
      AppLogger.info('Generating routine with on-device ML');
      final routine = await mlGenerator.generateRoutine(
        date: date,
        calendarEvents: calendarEvents?.isEmpty ?? true ? null : calendarEvents,
        weatherForecast: weatherForecast,
        userPreferences: prefs,
      );

      // Delete existing routine if regenerating (to avoid UNIQUE constraint)
      if (forceRegenerate) {
        final existingRoutine = await repository.getRoutineForDate(date);
        if (existingRoutine != null) {
          AppLogger.info(
            'Deleting existing routine before saving ML-generated one',
          );
          await repository.deleteRoutine(existingRoutine.id);
        }
      }

      // Save to local storage
      await repository.saveRoutine(routine);

      AppLogger.info('Routine generated and saved for $date');
      return routine;
    } on MLModelError catch (e) {
      AppLogger.error('ML model error during routine generation', error: e);
      rethrow;
    } catch (e) {
      AppLogger.error('Failed to generate routine', error: e);
      throw UnknownError('Failed to generate routine', e);
    }
  }

  /// Generate routine for today
  Future<Routine> generateTodaysRoutine({
    Map<String, dynamic>? userPreferences,
    bool forceRegenerate = false,
  }) async {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    return generateRoutine(
      date: todayDate,
      userPreferences: userPreferences,
      forceRegenerate: forceRegenerate,
    );
  }

  /// Get today's routine (or generate if missing)
  Future<Routine> getTodaysRoutine({
    Map<String, dynamic>? userPreferences,
  }) async {
    final existing = await repository.getTodaysRoutine();

    if (existing != null) {
      return existing;
    }

    // Generate if doesn't exist
    return generateTodaysRoutine(userPreferences: userPreferences);
  }

  /// Get routine for specific date (returns null if not found)
  Future<Routine?> getRoutineForDate(DateTime date) async {
    try {
      return await repository.getRoutineForDate(date);
    } catch (e) {
      AppLogger.warning('Failed to get routine for $date: $e');
      return null;
    }
  }

  /// Edit time block
  Future<void> editTimeBlock({
    required String routineId,
    required TimeBlock updatedBlock,
  }) async {
    try {
      await repository.updateTimeBlock(updatedBlock);
      AppLogger.info('Time block edited: ${updatedBlock.id}');
    } catch (e) {
      AppLogger.error('Failed to edit time block', error: e);
      rethrow;
    }
  }

  /// Snooze time block
  Future<void> snoozeTimeBlock({
    required String routineId,
    required TimeBlock block,
    required Duration snoozeDuration,
  }) async {
    try {
      final snoozedBlock = block.copyWith(
        isSnoozed: true,
        snoozedUntil: DateTime.now().add(snoozeDuration),
        startTime: block.startTime.add(snoozeDuration),
        endTime: block.endTime.add(snoozeDuration),
        updatedAt: DateTime.now(),
      );

      await repository.updateTimeBlock(snoozedBlock);
      AppLogger.info('Time block snoozed: ${block.id} for $snoozeDuration');
    } catch (e) {
      AppLogger.error('Failed to snooze time block', error: e);
      rethrow;
    }
  }

  /// Accept routine
  Future<void> acceptRoutine(String routineId) async {
    try {
      await repository.acceptRoutine(routineId);
      AppLogger.info('Routine accepted: $routineId');
    } catch (e) {
      AppLogger.error('Failed to accept routine', error: e);
      rethrow;
    }
  }

  /// Get routine history
  Future<List<Routine>> getRoutineHistory({
    int limit = 30,
    int offset = 0,
  }) async {
    try {
      return await repository.getAllRoutines(limit: limit, offset: offset);
    } catch (e) {
      AppLogger.error('Failed to get routine history', error: e);
      rethrow;
    }
  }

  /// Delete routine
  Future<void> deleteRoutine(String routineId) async {
    try {
      await repository.deleteRoutine(routineId);
      AppLogger.info('Routine deleted: $routineId');
    } catch (e) {
      AppLogger.error('Failed to delete routine', error: e);
      rethrow;
    }
  }

  /// Check if app is offline
  bool get isOffline {
    return connectivityService.currentStatus == ConnectivityStatus.offline;
  }

  /// Check if we're in offline mode (for UI indicators)
  bool get isInOfflineMode {
    return isOffline;
  }

  /// Prepare user preferences with defaults
  Map<String, dynamic> _preparePreferences(Map<String, dynamic>? prefs) {
    return {
      'work_window_start': prefs?['work_window_start'] ?? '09:00',
      'work_window_end': prefs?['work_window_end'] ?? '17:00',
      'quiet_hours_start': prefs?['quiet_hours_start'] ?? '22:00',
      'quiet_hours_end': prefs?['quiet_hours_end'] ?? '07:00',
      'activity_preferences':
          prefs?['activity_preferences'] ??
          {'exercise': true, 'social': true, 'learning': false},
    };
  }

  /// Get routine statistics
  Future<Map<String, dynamic>> getStatistics() async {
    return repository.getStatistics();
  }

  /// Cleanup old routines (90+ days)
  Future<int> cleanupOldRoutines() async {
    return repository.cleanupOldRoutines();
  }

  /// Get weather forecast for routine generation
  ///
  /// Returns weather data formatted for ML model input, or null if unavailable.
  /// Handles location permission denial, API errors, and offline scenarios gracefully.
  Future<Map<String, dynamic>?> _getWeatherForRoutine({
    required DateTime date,
    required WeatherSource weatherSource,
  }) async {
    if (weatherService == null || locationService == null) {
      return null;
    }

    try {
      // Get user's location (use last known to avoid slow GPS)
      var location = await locationService!.getLastKnownLocation();
      location ??= await locationService!.getCurrentLocation();

      if (location == null) {
        AppLogger.info(
          'Location permission denied, skipping weather integration',
        );
        return null;
      }

      final (latitude, longitude) = location;

      // Fetch weather forecast
      final result = await weatherService!.getForecast(
        latitude: latitude,
        longitude: longitude,
        source: weatherSource,
        forceRefresh: false,
      );

      if (!result.isSuccess || result.forecast == null) {
        AppLogger.warning('Weather fetch failed: ${result.error}');
        return null;
      }

      final forecast = result.forecast!;

      // Find weather conditions for the routine date
      // Get morning, afternoon, and evening forecasts
      final morningTime = DateTime(date.year, date.month, date.day, 9);
      final afternoonTime = DateTime(date.year, date.month, date.day, 14);
      final eveningTime = DateTime(date.year, date.month, date.day, 19);

      final morningCondition = forecast.getConditionForTime(morningTime);
      final afternoonCondition = forecast.getConditionForTime(afternoonTime);
      final eveningCondition = forecast.getConditionForTime(eveningTime);

      // Format for ML model consumption
      return {
        'source': weatherSource.name,
        'location': {
          'latitude': latitude,
          'longitude': longitude,
          'name': forecast.locationName,
        },
        'date': date.toIso8601String(),
        'is_from_cache': result.isFromCache,
        'morning': morningCondition != null
            ? {
                'time': morningCondition.forecastTime.toIso8601String(),
                'temperature_c': morningCondition.temperatureCelsius,
                'temperature_f':
                    (morningCondition.temperatureCelsius * 9 / 5) + 32,
                'condition': morningCondition.condition,
                'precipitation_chance': morningCondition.precipitationChance,
                'wind_speed_kmh': morningCondition.windSpeedKmh,
                'humidity_percent': morningCondition.humidity,
              }
            : null,
        'afternoon': afternoonCondition != null
            ? {
                'time': afternoonCondition.forecastTime.toIso8601String(),
                'temperature_c': afternoonCondition.temperatureCelsius,
                'temperature_f':
                    (afternoonCondition.temperatureCelsius * 9 / 5) + 32,
                'condition': afternoonCondition.condition,
                'precipitation_chance': afternoonCondition.precipitationChance,
                'wind_speed_kmh': afternoonCondition.windSpeedKmh,
                'humidity_percent': afternoonCondition.humidity,
              }
            : null,
        'evening': eveningCondition != null
            ? {
                'time': eveningCondition.forecastTime.toIso8601String(),
                'temperature_c': eveningCondition.temperatureCelsius,
                'temperature_f':
                    (eveningCondition.temperatureCelsius * 9 / 5) + 32,
                'condition': eveningCondition.condition,
                'precipitation_chance': eveningCondition.precipitationChance,
                'wind_speed_kmh': eveningCondition.windSpeedKmh,
                'humidity_percent': eveningCondition.humidity,
              }
            : null,
        'summary': _generateWeatherSummary(
          morningCondition,
          afternoonCondition,
          eveningCondition,
        ),
      };
    } on LocationException catch (e) {
      AppLogger.info('Location unavailable for weather: ${e.message}');
      return null;
    } catch (e) {
      AppLogger.warning('Error fetching weather for routine: $e');
      return null;
    }
  }

  /// Generate human-readable weather summary for ML context
  String _generateWeatherSummary(
    dynamic morningCondition,
    dynamic afternoonCondition,
    dynamic eveningCondition,
  ) {
    final parts = <String>[];

    if (morningCondition != null) {
      parts.add(
        'Morning: ${morningCondition.condition} '
        '(${morningCondition.temperatureCelsius.toStringAsFixed(0)}°C)',
      );
    }

    if (afternoonCondition != null) {
      parts.add(
        'Afternoon: ${afternoonCondition.condition} '
        '(${afternoonCondition.temperatureCelsius.toStringAsFixed(0)}°C)',
      );
    }

    if (eveningCondition != null) {
      parts.add(
        'Evening: ${eveningCondition.condition} '
        '(${eveningCondition.temperatureCelsius.toStringAsFixed(0)}°C)',
      );
    }

    if (parts.isEmpty) {
      return 'No weather data available';
    }

    return parts.join('. ');
  }

  /// Format weather data for Claude AI API
  Map<String, dynamic> _formatWeatherDataForClaude(
    Map<String, dynamic>? weatherForecast,
  ) {
    if (weatherForecast == null) {
      return {
        'temperature': 20, // Default
        'conditions': 'Partly cloudy',
        'precipitation': 0,
      };
    }

    // Use afternoon weather as representative for the day
    final afternoon = weatherForecast['afternoon'] as Map<String, dynamic>?;
    final morning = weatherForecast['morning'] as Map<String, dynamic>?;

    final representative = afternoon ?? morning;

    return {
      'temperature': representative?['temperature_c']?.round() ?? 20,
      'conditions': representative?['condition'] ?? 'Partly cloudy',
      'precipitation': representative?['precipitation_chance'] ?? 0,
      'summary': weatherForecast['summary'] ?? 'No weather data',
    };
  }

  /// Format user preferences for Claude AI API
  Map<String, dynamic> _formatPreferencesForClaude(Map<String, dynamic> prefs) {
    return {
      'workHours': '${prefs['work_window_start']}-${prefs['work_window_end']}',
      'quietHours': '${prefs['quiet_hours_start']}-${prefs['quiet_hours_end']}',
      'preferredActivities': _formatActivityPreferences(
        prefs['activity_preferences'] as Map<String, dynamic>? ?? {},
      ),
    };
  }

  /// Format activity preferences into a list
  List<String> _formatActivityPreferences(Map<String, dynamic> activityPrefs) {
    final activities = <String>[];

    activityPrefs.forEach((key, value) {
      if (value == true) {
        activities.add(key);
      }
    });

    return activities.isEmpty ? ['work', 'exercise', 'meals'] : activities;
  }

  /// Convert Claude response to Routine object
  Routine _convertClaudeResponseToRoutine(
    ClaudeRoutineResponse claudeResponse,
    DateTime date,
  ) {
    final uuid = Uuid();
    final now = DateTime.now();
    // Normalize date to midnight for consistent storage
    final normalizedDate = DateTime(date.year, date.month, date.day);

    // Convert Claude time blocks to app TimeBlock objects
    final timeBlocks = claudeResponse.timeBlocks.map((claudeBlock) {
      final startTime = _parseTimeString(claudeBlock.startTime, normalizedDate);
      final endTime = _parseTimeString(claudeBlock.endTime, normalizedDate);

      return TimeBlock(
        id: uuid.v4(),
        routineId: '', // Will be set when routine is saved
        title: claudeBlock.title,
        description: claudeBlock.description,
        startTime: startTime,
        endTime: endTime,
        activityType: _mapActivityType(claudeBlock.activityType),
        isSnoozed: false,
        snoozedUntil: null,
        createdAt: now,
        updatedAt: now,
      );
    }).toList();

    // Create routine with Claude's explanation and confidence score
    return Routine(
      id: uuid.v4(),
      date: normalizedDate,
      title: claudeResponse.title,
      timeBlocks: timeBlocks,
      explanation: RoutineExplanation(
        summary: claudeResponse.explanation,
        factors: [
          'Enhanced by Claude AI',
          'Calendar events',
          'Sleep patterns',
          'Weather forecast',
        ],
        dataSourcesUsed: {
          'claude_ai': true,
          'calendar': true,
          'sleep': true,
          'weather': true,
        },
        generatedAt: now,
      ),
      confidenceScore:
          claudeResponse.confidenceScore / 100.0, // Convert 0-100 to 0.0-1.0
      isAccepted: false,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Parse time string (HH:mm) and combine with date
  DateTime _parseTimeString(String timeString, DateTime date) {
    final parts = timeString.split(':');
    if (parts.length != 2) {
      // Invalid format, return noon as fallback
      return DateTime(date.year, date.month, date.day, 12, 0);
    }

    try {
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      return DateTime(date.year, date.month, date.day, hour, minute);
    } catch (e) {
      // Parse error, return noon as fallback
      return DateTime(date.year, date.month, date.day, 12, 0);
    }
  }

  /// Format time blocks for Claude AI regeneration context
  List<Map<String, dynamic>> _formatTimeBlocksForClaude(
    List<TimeBlock> blocks,
  ) {
    return blocks.map((block) {
      return {
        'title': block.title,
        'startTime':
            '${block.startTime.hour.toString().padLeft(2, '0')}:${block.startTime.minute.toString().padLeft(2, '0')}',
        'endTime':
            '${block.endTime.hour.toString().padLeft(2, '0')}:${block.endTime.minute.toString().padLeft(2, '0')}',
        'activityType': block.activityType,
        'description': block.description ?? '',
        'duration': '${block.durationMinutes} minutes',
      };
    }).toList();
  }

  /// Map Claude's activity type to valid ActivityType constant
  ///
  /// Claude AI may return activity types that don't match our ActivityType constants.
  /// This method maps them to the closest valid type.
  String _mapActivityType(String claudeActivityType) {
    final normalized = claudeActivityType.toLowerCase().trim();

    // Direct matches
    if (ActivityType.all.contains(normalized)) {
      return normalized;
    }

    // Map common variations to valid types
    switch (normalized) {
      case 'nutrition':
      case 'breakfast':
      case 'lunch':
      case 'dinner':
      case 'snack':
      case 'food':
      case 'eating':
        return ActivityType.meal;

      case 'workout':
      case 'gym':
      case 'training':
      case 'sport':
      case 'fitness':
        return ActivityType.exercise;

      case 'nap':
      case 'bedtime':
      case 'sleeping':
        return ActivityType.sleep;

      case 'study':
      case 'reading':
      case 'course':
      case 'education':
        return ActivityType.learning;

      case 'call':
      case 'conference':
      case 'appointment':
        return ActivityType.meeting;

      case 'task':
      case 'project':
      case 'job':
        return ActivityType.work;

      case 'meditation':
      case 'relaxation':
      case 'self-care':
      case 'personal':
        return ActivityType.personal;

      case 'travel':
      case 'transport':
      case 'driving':
        return ActivityType.commute;

      case 'pause':
      case 'rest':
      case 'coffee':
      case 'tea':
        return ActivityType.break_;

      case 'deepwork':
      case 'concentration':
      case 'focused':
        return ActivityType.focus;

      case 'friends':
      case 'family':
      case 'hangout':
        return ActivityType.social;

      case 'tv':
      case 'movie':
      case 'gaming':
      case 'games':
      case 'hobby':
        return ActivityType.entertainment;

      case 'cleaning':
      case 'laundry':
      case 'cooking':
      case 'housework':
        return ActivityType.chores;

      case 'doctor':
      case 'medical':
      case 'therapy':
      case 'wellness':
        return ActivityType.other;

      default:
        // Log unmapped types for debugging
        AppLogger.warning(
          '⚠️ Unmapped activity type from Claude: "$claudeActivityType" -> defaulting to "other"',
        );
        return ActivityType.other;
    }
  }
}
