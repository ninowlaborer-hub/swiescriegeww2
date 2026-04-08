import 'package:drift/drift.dart';
import '../../../core/database/database.dart';
import '../domain/weather_forecast.dart';
import '../domain/weather_condition.dart';
import '../domain/weather_source.dart';

/// Local datasource for weather data
///
/// Manages cached weather forecasts in encrypted local database.
/// Per FR-018: Minimum 3-hour cache duration to reduce API calls.
class WeatherLocalDataSource {
  WeatherLocalDataSource(this._database);

  final AppDatabase _database;

  /// Save weather forecast to cache
  Future<void> saveForecast(WeatherForecast forecast) async {
    await _database.transaction(() async {
      // Delete old forecasts for same location
      await (_database.delete(_database.weatherCache)
            ..where(
              (tbl) =>
                  tbl.latitude.equals(forecast.latitude) &
                  tbl.longitude.equals(forecast.longitude),
            ))
          .go();

      // Insert new forecast data (one row per hourly condition)
      for (final condition in forecast.hourlyConditions) {
        await _database.into(_database.weatherCache).insert(
              WeatherCacheCompanion.insert(
                uuid: condition.uuid,
                source: forecast.source.id,
                latitude: forecast.latitude,
                longitude: forecast.longitude,
                forecastDate: forecast.forecastDate,
                forecastTime: condition.forecastTime,
                condition: condition.condition,
                temperatureCelsius: condition.temperatureCelsius,
                feelsLikeCelsius: Value(condition.feelsLikeCelsius),
                humidity: Value(condition.humidity),
                windSpeedKmh: Value(condition.windSpeedKmh),
                windDirection: Value(condition.windDirection),
                precipitationChance: Value(condition.precipitationChance),
                precipitationMm: Value(condition.precipitationMm),
                uvIndex: Value(condition.uvIndex),
                rawJson: forecast.rawJson ?? '',
                fetchedAt: forecast.fetchedAt,
                expiresAt: forecast.expiresAt,
                createdAt: DateTime.now(),
              ),
            );
      }
    });
  }

  /// Get cached forecast for location
  ///
  /// Returns null if no valid cache exists or cache is expired.
  Future<WeatherForecast?> getCachedForecast({
    required double latitude,
    required double longitude,
  }) async {
    final now = DateTime.now();

    // Query all non-expired weather data for this location
    final cacheRows = await (_database.select(_database.weatherCache)
          ..where(
            (tbl) =>
                tbl.latitude.equals(latitude) &
                tbl.longitude.equals(longitude) &
                tbl.expiresAt.isBiggerThanValue(now),
          )
          ..orderBy([
            (tbl) => OrderingTerm(
                  expression: tbl.forecastTime,
                  mode: OrderingMode.asc,
                ),
          ]))
        .get();

    if (cacheRows.isEmpty) return null;

    // Convert cache rows to WeatherForecast
    final firstRow = cacheRows.first;

    final hourlyConditions = cacheRows
        .map(
          (row) => WeatherCondition(
            uuid: row.uuid,
            forecastTime: row.forecastTime,
            condition: row.condition,
            temperatureCelsius: row.temperatureCelsius,
            feelsLikeCelsius: row.feelsLikeCelsius,
            humidity: row.humidity,
            windSpeedKmh: row.windSpeedKmh,
            windDirection: row.windDirection,
            precipitationChance: row.precipitationChance,
            precipitationMm: row.precipitationMm,
            uvIndex: row.uvIndex,
          ),
        )
        .toList();

    return WeatherForecast(
      uuid: firstRow.uuid,
      source: WeatherSource.fromId(firstRow.source),
      latitude: firstRow.latitude,
      longitude: firstRow.longitude,
      forecastDate: firstRow.forecastDate,
      hourlyConditions: hourlyConditions,
      fetchedAt: firstRow.fetchedAt,
      expiresAt: firstRow.expiresAt,
      locationName: null, // Not stored in cache
      rawJson: firstRow.rawJson,
    );
  }

  /// Clear expired weather cache entries
  ///
  /// Per FR-018: Clean up old cached data to save space.
  Future<int> clearExpiredCache() async {
    final now = DateTime.now();
    return await (_database.delete(_database.weatherCache)
          ..where((tbl) => tbl.expiresAt.isSmallerThanValue(now)))
        .go();
  }

  /// Clear all weather cache
  Future<int> clearAllCache() async {
    return await _database.delete(_database.weatherCache).go();
  }

  /// Get cache size (number of cached forecast entries)
  Future<int> getCacheSize() async {
    final result = await (_database.selectOnly(_database.weatherCache)
          ..addColumns([_database.weatherCache.id.count()]))
        .getSingle();

    return result.read(_database.weatherCache.id.count()) ?? 0;
  }
}
