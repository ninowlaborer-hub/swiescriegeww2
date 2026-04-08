import 'package:freezed_annotation/freezed_annotation.dart';
import 'weather_condition.dart';
import 'weather_source.dart';

part 'weather_forecast.freezed.dart';
part 'weather_forecast.g.dart';

/// Weather forecast data for a specific date
///
/// Contains hourly weather conditions and metadata about the forecast.
/// Cached locally per FR-018 (3-hour minimum cache duration).
@freezed
abstract class WeatherForecast with _$WeatherForecast {
  const factory WeatherForecast({
    required String uuid,
    required WeatherSource source,
    required double latitude,
    required double longitude,
    required DateTime forecastDate,
    required List<WeatherCondition> hourlyConditions,
    required DateTime fetchedAt,
    required DateTime expiresAt,
    String? locationName,
    String? rawJson, // Full API response for debugging
  }) = _WeatherForecast;

  const WeatherForecast._();

  factory WeatherForecast.fromJson(Map<String, dynamic> json) =>
      _$WeatherForecastFromJson(json);

  /// Check if forecast is still valid (not expired)
  bool get isValid => DateTime.now().isBefore(expiresAt);

  /// Check if forecast is expired and needs refresh
  bool get isExpired => !isValid;

  /// Get weather condition for a specific time
  ///
  /// Returns the closest weather condition to the given time.
  WeatherCondition? getConditionForTime(DateTime time) {
    if (hourlyConditions.isEmpty) return null;

    // Find the closest forecast to the requested time
    WeatherCondition? closest;
    Duration? minDifference;

    for (final condition in hourlyConditions) {
      final difference = condition.forecastTime.difference(time).abs();

      if (minDifference == null || difference < minDifference) {
        minDifference = difference;
        closest = condition;
      }
    }

    return closest;
  }

  /// Get current weather condition (closest to now)
  WeatherCondition? get currentCondition {
    return getConditionForTime(DateTime.now());
  }

  /// Get weather summary for the day
  String get summary {
    if (hourlyConditions.isEmpty) return 'No weather data available';

    final temps = hourlyConditions
        .map((c) => c.temperatureCelsius)
        .toList()
      ..sort();

    final minTemp = temps.first.round();
    final maxTemp = temps.last.round();

    final current = currentCondition;
    final condition = current?.condition ?? 'Unknown';

    return '$condition, $minTemp°C - $maxTemp°C';
  }
}
