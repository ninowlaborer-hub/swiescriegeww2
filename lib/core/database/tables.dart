import 'package:drift/drift.dart';

/// Database tables for Swisscierge local storage
///
/// All tables use SQLCipher encryption for data at rest (FR-029).
/// Tables support offline-first architecture with local caching.

/// Routines table - stores generated daily routines
class Routines extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  DateTimeColumn get date => dateTime()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get explanation => text().nullable()();
  RealColumn get confidenceScore => real().nullable()();
  BoolColumn get isAccepted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

/// Time blocks table - individual blocks within a routine
class TimeBlocks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  IntColumn get routineId => integer().references(Routines, #id)();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  TextColumn get activityType => text()(); // work, exercise, meal, sleep, etc.
  TextColumn get category => text().nullable()();
  IntColumn get priority => integer().withDefault(const Constant(0))();
  BoolColumn get isSnoozed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get snoozedUntil => dateTime().nullable()();
  TextColumn get source => text().nullable()(); // calendar, ai, manual, etc.
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

/// Calendar cache table - locally cached calendar sources and events
class CalendarCache extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get eventId => text().unique()(); // Platform calendar event ID
  TextColumn get calendarId => text()(); // Source calendar ID
  TextColumn get calendarName => text()();
  TextColumn get title => text().withLength(min: 1, max: 500)();
  TextColumn get description => text().nullable()();
  TextColumn get location => text().nullable()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  BoolColumn get isAllDay => boolean().withDefault(const Constant(false))();
  TextColumn get recurrenceRule => text().nullable()();
  BoolColumn get isRecurring => boolean().withDefault(const Constant(false))();

  // Calendar source properties
  BoolColumn get isSelected => boolean().withDefault(const Constant(false))();
  BoolColumn get isPrimary => boolean().withDefault(const Constant(false))();
  BoolColumn get isReadOnly => boolean().withDefault(const Constant(false))();
  TextColumn get sourceType => text().nullable()(); // CalendarSourceType enum
  TextColumn get accountName => text().nullable()();
  TextColumn get accountType => text().nullable()();
  IntColumn get color => integer().withDefault(const Constant(0xFF2196F3))();
  TextColumn get metadata => text().nullable()(); // JSON metadata

  DateTimeColumn get lastSyncedAt => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

/// Weather cache table - cached weather forecasts from free public APIs
class WeatherCache extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  TextColumn get source => text()(); // openweathermap, weather.gov
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  DateTimeColumn get forecastDate => dateTime()();
  DateTimeColumn get forecastTime => dateTime()();
  TextColumn get condition => text()(); // sunny, cloudy, rainy, etc.
  RealColumn get temperatureCelsius => real()();
  RealColumn get feelsLikeCelsius => real().nullable()();
  IntColumn get humidity => integer().nullable()();
  RealColumn get windSpeedKmh => real().nullable()();
  TextColumn get windDirection => text().nullable()();
  IntColumn get precipitationChance => integer().nullable()();
  RealColumn get precipitationMm => real().nullable()();
  IntColumn get uvIndex => integer().nullable()();
  TextColumn get rawJson => text()(); // Full API response for future use
  DateTimeColumn get fetchedAt => dateTime()();
  DateTimeColumn get expiresAt => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
}

/// User preferences table - app configuration and settings
class UserPreferences extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text().unique()();
  TextColumn get value => text()();
  TextColumn get type => text()(); // string, int, bool, json
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

/// Preference keys (constants for type safety)
class PreferenceKeys {
  static const String workWindowStart = 'work_window_start'; // HH:mm format
  static const String workWindowEnd = 'work_window_end'; // HH:mm format
  static const String quietHoursStart = 'quiet_hours_start'; // HH:mm format
  static const String quietHoursEnd = 'quiet_hours_end'; // HH:mm format
  static const String selectedCalendarIds =
      'selected_calendar_ids'; // JSON array
  static const String weatherSource =
      'weather_source'; // openweathermap | weather.gov
  static const String weatherApiKey = 'weather_api_key'; // OpenWeatherMap key
  static const String locationLatitude = 'location_latitude';
  static const String locationLongitude = 'location_longitude';
  static const String locationName = 'location_name';
  static const String analyticsEnabled = 'analytics_enabled'; // bool
  static const String cloudBackupEnabled = 'cloud_backup_enabled'; // bool
  static const String lastBackupAt = 'last_backup_at'; // ISO 8601 datetime
  static const String onboardingCompleted = 'onboarding_completed'; // bool
  static const String activityPreferences =
      'activity_preferences'; // JSON object
  static const String themeMode = 'theme_mode'; // light | dark | system
}
