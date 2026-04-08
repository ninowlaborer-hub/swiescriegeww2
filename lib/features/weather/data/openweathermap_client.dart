import 'package:dio/dio.dart';
import '../domain/weather_condition.dart';
import '../domain/weather_forecast.dart';
import '../domain/weather_source.dart';
import 'package:uuid/uuid.dart';

/// OpenWeatherMap API client
///
/// Free tier: 1000 calls/day limit per FR-018
/// API docs: https://openweathermap.org/api/one-call-3
class OpenWeatherMapClient {
  OpenWeatherMapClient(this._dio, {this.apiKey});

  final Dio _dio;
  final String? apiKey;
  final _uuid = const Uuid();

  static const _baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const _cacheDurationHours = 3; // FR-018: 3-hour minimum cache

  /// Fetch weather forecast for coordinates
  ///
  /// Returns hourly forecast for the next 48 hours.
  /// Throws [WeatherApiException] on API errors.
  Future<WeatherForecast> getForecast({
    required double latitude,
    required double longitude,
  }) async {
    if (apiKey == null || apiKey!.isEmpty) {
      throw WeatherApiException(
        'OpenWeatherMap API key not configured. Please add your API key in settings.',
      );
    }

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '$_baseUrl/forecast',
        queryParameters: {
          'lat': latitude,
          'lon': longitude,
          'appid': apiKey,
          'units': 'metric', // Celsius
          'cnt': 40, // 40 x 3-hour intervals = 5 days
        },
      );

      if (response.data == null) {
        throw WeatherApiException('Empty response from OpenWeatherMap API');
      }

      return _parseForecastResponse(
        response.data!,
        latitude,
        longitude,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw WeatherApiException(
          'Invalid OpenWeatherMap API key. Please check your settings.',
        );
      } else if (e.response?.statusCode == 429) {
        throw WeatherApiException(
          'OpenWeatherMap API rate limit exceeded (1000 calls/day). Try again later.',
        );
      }

      throw WeatherApiException(
        'Failed to fetch weather data: ${e.message}',
      );
    } catch (e) {
      throw WeatherApiException(
        'Unexpected error fetching weather: $e',
      );
    }
  }

  /// Parse OpenWeatherMap API response into WeatherForecast
  WeatherForecast _parseForecastResponse(
    Map<String, dynamic> json,
    double latitude,
    double longitude,
  ) {
    final forecastList = json['list'] as List<dynamic>? ?? [];
    final city = json['city'] as Map<String, dynamic>? ?? {};
    final locationName = city['name'] as String?;

    final hourlyConditions = forecastList.map<WeatherCondition>((item) {
      final main = item['main'] as Map<String, dynamic>? ?? {};
      final weather =
          (item['weather'] as List<dynamic>?)?.first as Map<String, dynamic>? ??
              {};
      final wind = item['wind'] as Map<String, dynamic>? ?? {};
      final rain = item['rain'] as Map<String, dynamic>? ?? {};
      final snow = item['snow'] as Map<String, dynamic>? ?? {};

      final timestamp = item['dt'] as int? ?? 0;
      final forecastTime =
          DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

      final temp = (main['temp'] as num?)?.toDouble() ?? 0.0;
      final feelsLike = (main['feels_like'] as num?)?.toDouble();
      final humidity = (main['humidity'] as num?)?.toInt();

      final condition = weather['main'] as String? ?? 'Unknown';
      final windSpeed = (wind['speed'] as num?)?.toDouble();
      final windDegrees = (wind['deg'] as num?)?.toInt();

      final precipitation3h =
          ((rain['3h'] as num?) ?? (snow['3h'] as num?))?.toDouble();
      final pop = (item['pop'] as num?)?.toDouble(); // Probability of precipitation

      return WeatherCondition(
        uuid: _uuid.v4(),
        forecastTime: forecastTime,
        condition: condition,
        temperatureCelsius: temp,
        feelsLikeCelsius: feelsLike,
        humidity: humidity,
        windSpeedKmh: windSpeed != null ? windSpeed * 3.6 : null, // m/s to km/h
        windDirection: _getWindDirection(windDegrees),
        precipitationChance: pop != null ? (pop * 100).toInt() : null,
        precipitationMm: precipitation3h,
        uvIndex: null, // Not available in free tier
      );
    }).toList();

    final now = DateTime.now();
    final expiresAt = now.add(const Duration(hours: _cacheDurationHours));

    return WeatherForecast(
      uuid: _uuid.v4(),
      source: WeatherSource.openWeatherMap,
      latitude: latitude,
      longitude: longitude,
      forecastDate: now,
      hourlyConditions: hourlyConditions,
      fetchedAt: now,
      expiresAt: expiresAt,
      locationName: locationName,
      rawJson: json.toString(),
    );
  }

  /// Convert wind degrees to cardinal direction
  String? _getWindDirection(int? degrees) {
    if (degrees == null) return null;

    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    final index = ((degrees + 22.5) / 45).floor() % 8;
    return directions[index];
  }
}

/// Exception thrown when weather API requests fail
class WeatherApiException implements Exception {
  WeatherApiException(this.message);

  final String message;

  @override
  String toString() => 'WeatherApiException: $message';
}
