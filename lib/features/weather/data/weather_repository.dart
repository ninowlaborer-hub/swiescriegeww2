import '../domain/weather_forecast.dart';
import '../domain/weather_source.dart';
import 'weather_local_datasource.dart';
import 'openweathermap_client.dart';
import 'weathergov_client.dart';

/// Weather repository
///
/// Manages weather data fetching from APIs and local caching.
/// Implements FR-018: 3-hour minimum cache, 1000 calls/day limit for OpenWeatherMap.
class WeatherRepository {
  WeatherRepository({
    required WeatherLocalDataSource localDataSource,
    required OpenWeatherMapClient openWeatherMapClient,
    required WeatherGovClient weatherGovClient,
  })  : _localDataSource = localDataSource,
        _openWeatherMapClient = openWeatherMapClient,
        _weatherGovClient = weatherGovClient;

  final WeatherLocalDataSource _localDataSource;
  final OpenWeatherMapClient _openWeatherMapClient;
  final WeatherGovClient _weatherGovClient;

  /// Get weather forecast for location
  ///
  /// Strategy:
  /// 1. Check local cache first
  /// 2. If cache is valid (not expired), return cached data
  /// 3. If cache is expired or missing, fetch from API
  /// 4. Save fetched data to cache
  /// 5. Return fresh data
  Future<WeatherForecast> getForecast({
    required double latitude,
    required double longitude,
    required WeatherSource source,
    bool forceRefresh = false,
  }) async {
    // Check cache first (unless force refresh)
    if (!forceRefresh) {
      final cachedForecast = await _localDataSource.getCachedForecast(
        latitude: latitude,
        longitude: longitude,
      );

      if (cachedForecast != null && cachedForecast.isValid) {
        return cachedForecast;
      }
    }

    // Cache miss or expired - fetch from API
    final forecast = await _fetchFromApi(
      latitude: latitude,
      longitude: longitude,
      source: source,
    );

    // Save to cache
    await _localDataSource.saveForecast(forecast);

    return forecast;
  }

  /// Fetch forecast from API based on source
  Future<WeatherForecast> _fetchFromApi({
    required double latitude,
    required double longitude,
    required WeatherSource source,
  }) async {
    switch (source) {
      case WeatherSource.openWeatherMap:
        return await _openWeatherMapClient.getForecast(
          latitude: latitude,
          longitude: longitude,
        );

      case WeatherSource.weatherGov:
        return await _weatherGovClient.getForecast(
          latitude: latitude,
          longitude: longitude,
        );
    }
  }

  /// Get cached forecast (offline mode)
  ///
  /// Returns cached data even if expired, for offline fallback per FR-016.
  Future<WeatherForecast?> getCachedForecast({
    required double latitude,
    required double longitude,
  }) async {
    return await _localDataSource.getCachedForecast(
      latitude: latitude,
      longitude: longitude,
    );
  }

  /// Clear expired cache entries
  Future<int> clearExpiredCache() async {
    return await _localDataSource.clearExpiredCache();
  }

  /// Clear all weather cache
  Future<int> clearAllCache() async {
    return await _localDataSource.clearAllCache();
  }

  /// Get cache statistics
  Future<CacheStats> getCacheStats() async {
    final size = await _localDataSource.getCacheSize();
    return CacheStats(entryCount: size);
  }
}

/// Cache statistics
class CacheStats {
  const CacheStats({required this.entryCount});

  final int entryCount;
}
