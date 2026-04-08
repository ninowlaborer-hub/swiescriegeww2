/// Application configuration for Swisscierge
///
/// Defines environment-specific settings and constants for the app.
/// This is a local-only app, so no backend URLs are needed.
class AppConfig {
  const AppConfig._();

  /// App name
  static const String appName = 'Swisscierge';

  /// App version (matches pubspec.yaml)
  static const String appVersion = '1.0.0';

  /// Build number
  static const int buildNumber = 1;

  /// OpenWeatherMap API configuration (optional, user-provided)
  /// Free tier: 1000 calls/day
  static const String openWeatherMapBaseUrl =
      'https://api.openweathermap.org/data/2.5';

  /// Weather.gov API configuration (US only, no key required)
  static const String weatherGovBaseUrl = 'https://api.weather.gov';

  /// Weather cache duration (minimum 3 hours per FR-018)
  static const Duration weatherCacheMinDuration = Duration(hours: 3);

  /// Maximum weather API calls per day (OpenWeatherMap free tier limit)
  static const int maxWeatherApiCallsPerDay = 1000;

  /// Local database configuration
  static const String databaseName = 'swisscierge.db';

  /// Maximum database size in bytes (100MB per FR-036)
  static const int maxDatabaseSizeBytes = 100 * 1024 * 1024; // 100MB

  /// Routine history retention period (90 days per plan.md)
  static const Duration routineHistoryRetention = Duration(days: 90);

  /// Performance thresholds
  /// Routine generation should complete in <5 seconds (FR-035)
  static const Duration routineGenerationTimeout = Duration(seconds: 5);

  /// App launch should complete in <2 seconds (FR-038)
  static const Duration appLaunchTimeout = Duration(seconds: 2);

  /// Sleep data analysis should complete in <3 seconds
  static const Duration sleepAnalysisTimeout = Duration(seconds: 3);

  /// Debug mode flag (set by Flutter framework)
  static bool get isDebugMode {
    var inDebugMode = false;
    assert(
      inDebugMode = true,
      'This should only execute in debug mode',
    );
    return inDebugMode;
  }

  /// Privacy-first: No backend servers, no external data transmission
  static const bool offlineFirst = true;

  /// Encryption configuration
  static const String encryptionKeyAlias = 'swisscierge_master_key';

  /// Analytics opt-in flag key (stored in preferences)
  static const String analyticsOptInKey = 'analytics_opt_in';

  /// Cloud backup opt-in flag key (stored in preferences)
  static const String cloudBackupOptInKey = 'cloud_backup_opt_in';
}
