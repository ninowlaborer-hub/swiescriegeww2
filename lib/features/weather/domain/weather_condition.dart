import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_condition.freezed.dart';
part 'weather_condition.g.dart';

/// Weather condition data
///
/// Represents a single weather forecast data point with temperature,
/// precipitation, wind, and other meteorological information.
@freezed
abstract class WeatherCondition with _$WeatherCondition {
  const factory WeatherCondition({
    required String uuid,
    required DateTime forecastTime,
    required String condition, // sunny, cloudy, rainy, snowy, etc.
    required double temperatureCelsius,
    double? feelsLikeCelsius,
    int? humidity, // 0-100%
    double? windSpeedKmh,
    String? windDirection, // N, NE, E, SE, S, SW, W, NW
    int? precipitationChance, // 0-100%
    double? precipitationMm,
    int? uvIndex, // 0-11+
  }) = _WeatherCondition;

  factory WeatherCondition.fromJson(Map<String, dynamic> json) =>
      _$WeatherConditionFromJson(json);
}

/// Weather condition types
enum ConditionType {
  clear('Clear', '☀️'),
  partlyCloudy('Partly Cloudy', '⛅'),
  cloudy('Cloudy', '☁️'),
  overcast('Overcast', '☁️'),
  rain('Rain', '🌧️'),
  lightRain('Light Rain', '🌦️'),
  heavyRain('Heavy Rain', '⛈️'),
  thunderstorm('Thunderstorm', '⛈️'),
  snow('Snow', '❄️'),
  lightSnow('Light Snow', '🌨️'),
  heavySnow('Heavy Snow', '❄️'),
  sleet('Sleet', '🌨️'),
  fog('Fog', '🌫️'),
  windy('Windy', '💨'),
  unknown('Unknown', '?');

  const ConditionType(this.displayName, this.emoji);

  final String displayName;
  final String emoji;

  static ConditionType fromString(String condition) {
    final normalized = condition.toLowerCase().trim();

    if (normalized.contains('clear') || normalized.contains('sunny')) {
      return ConditionType.clear;
    } else if (normalized.contains('partly cloudy') ||
        normalized.contains('partly-cloudy')) {
      return ConditionType.partlyCloudy;
    } else if (normalized.contains('overcast')) {
      return ConditionType.overcast;
    } else if (normalized.contains('cloudy')) {
      return ConditionType.cloudy;
    } else if (normalized.contains('thunderstorm') ||
        normalized.contains('storm')) {
      return ConditionType.thunderstorm;
    } else if (normalized.contains('heavy rain')) {
      return ConditionType.heavyRain;
    } else if (normalized.contains('light rain') ||
        normalized.contains('drizzle')) {
      return ConditionType.lightRain;
    } else if (normalized.contains('rain')) {
      return ConditionType.rain;
    } else if (normalized.contains('heavy snow') ||
        normalized.contains('blizzard')) {
      return ConditionType.heavySnow;
    } else if (normalized.contains('light snow') ||
        normalized.contains('flurries')) {
      return ConditionType.lightSnow;
    } else if (normalized.contains('snow')) {
      return ConditionType.snow;
    } else if (normalized.contains('sleet') || normalized.contains('freezing')) {
      return ConditionType.sleet;
    } else if (normalized.contains('fog') || normalized.contains('mist')) {
      return ConditionType.fog;
    } else if (normalized.contains('wind')) {
      return ConditionType.windy;
    }

    return ConditionType.unknown;
  }
}
