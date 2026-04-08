import '../data/weather_repository.dart';
import '../domain/weather_forecast.dart';
import '../domain/weather_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Weather service
///
/// High-level service for weather operations with rate limiting.
/// Implements FR-018: 1000 calls/day limit for OpenWeatherMap, graceful degradation.
class WeatherService {
  WeatherService(this._repository);

  final WeatherRepository _repository;

  static const _maxDailyCalls = 1000; // OpenWeatherMap free tier limit
  static const _callCountKey = 'weather_api_calls';
  static const _callDateKey = 'weather_api_call_date';

  /// Get weather forecast for location
  ///
  /// Implements rate limiting for OpenWeatherMap (1000 calls/day).
  /// Falls back to cached data if rate limit exceeded per FR-016.
  Future<WeatherForecastResult> getForecast({
    required double latitude,
    required double longitude,
    required WeatherSource source,
    bool forceRefresh = false,
  }) async {
    // Check rate limit for OpenWeatherMap
    if (source == WeatherSource.openWeatherMap && !forceRefresh) {
      final canMakeApiCall = await _checkRateLimit();
      if (!canMakeApiCall) {
        // Rate limit exceeded - try to return cached data
        final cachedForecast = await _repository.getCachedForecast(
          latitude: latitude,
          longitude: longitude,
        );

        if (cachedForecast != null) {
          return WeatherForecastResult.fromCache(
            cachedForecast,
            reason: 'API rate limit reached (1000 calls/day). Using cached data.',
          );
        }

        return WeatherForecastResult.error(
          'Weather API rate limit exceeded and no cached data available. Try again tomorrow.',
        );
      }
    }

    try {
      final forecast = await _repository.getForecast(
        latitude: latitude,
        longitude: longitude,
        source: source,
        forceRefresh: forceRefresh,
      );

      // Increment API call counter for OpenWeatherMap
      if (source == WeatherSource.openWeatherMap && !forecast.isExpired) {
        await _incrementApiCallCount();
      }

      return WeatherForecastResult.success(forecast);
    } catch (e) {
      // API error - try to return cached data per FR-016
      final cachedForecast = await _repository.getCachedForecast(
        latitude: latitude,
        longitude: longitude,
      );

      if (cachedForecast != null) {
        return WeatherForecastResult.fromCache(
          cachedForecast,
          reason: 'Weather API error: $e. Using cached data.',
        );
      }

      return WeatherForecastResult.error(
        'Failed to fetch weather: $e',
      );
    }
  }

  /// Check if we can make an API call (rate limit check)
  Future<bool> _checkRateLimit() async {
    final prefs = await SharedPreferences.getInstance();

    final today = DateTime.now().toIso8601String().split('T').first;
    final lastCallDate = prefs.getString(_callDateKey);
    final callCount = prefs.getInt(_callCountKey) ?? 0;

    // Reset counter if it's a new day
    if (lastCallDate != today) {
      await prefs.setString(_callDateKey, today);
      await prefs.setInt(_callCountKey, 0);
      return true;
    }

    // Check if we've exceeded daily limit
    return callCount < _maxDailyCalls;
  }

  /// Increment API call counter
  Future<void> _incrementApiCallCount() async {
    final prefs = await SharedPreferences.getInstance();
    final callCount = prefs.getInt(_callCountKey) ?? 0;
    await prefs.setInt(_callCountKey, callCount + 1);
  }

  /// Get remaining API calls for today
  Future<int> getRemainingApiCalls() async {
    final prefs = await SharedPreferences.getInstance();

    final today = DateTime.now().toIso8601String().split('T').first;
    final lastCallDate = prefs.getString(_callDateKey);

    // If different day, all calls available
    if (lastCallDate != today) {
      return _maxDailyCalls;
    }

    final callCount = prefs.getInt(_callCountKey) ?? 0;
    return (_maxDailyCalls - callCount).clamp(0, _maxDailyCalls);
  }

  /// Clear expired cache
  Future<int> clearExpiredCache() async {
    return await _repository.clearExpiredCache();
  }

  /// Clear all weather cache
  Future<int> clearAllCache() async {
    return await _repository.clearAllCache();
  }

  /// Get cache statistics
  Future<CacheStats> getCacheStats() async {
    return await _repository.getCacheStats();
  }
}

/// Weather forecast result
///
/// Encapsulates forecast data with metadata about source (API vs cache).
class WeatherForecastResult {
  const WeatherForecastResult._({
    this.forecast,
    this.error,
    this.isFromCache = false,
    this.cacheReason,
  });

  final WeatherForecast? forecast;
  final String? error;
  final bool isFromCache;
  final String? cacheReason;

  bool get isSuccess => forecast != null && error == null;
  bool get isError => error != null;

  factory WeatherForecastResult.success(WeatherForecast forecast) {
    return WeatherForecastResult._(forecast: forecast);
  }

  factory WeatherForecastResult.fromCache(
    WeatherForecast forecast, {
    String? reason,
  }) {
    return WeatherForecastResult._(
      forecast: forecast,
      isFromCache: true,
      cacheReason: reason,
    );
  }

  factory WeatherForecastResult.error(String error) {
    return WeatherForecastResult._(error: error);
  }
}
