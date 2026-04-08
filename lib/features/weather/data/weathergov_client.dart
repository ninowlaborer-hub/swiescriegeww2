import 'package:dio/dio.dart';
import '../domain/weather_condition.dart';
import '../domain/weather_forecast.dart';
import '../domain/weather_source.dart';
import 'package:uuid/uuid.dart';
import 'openweathermap_client.dart'; // For WeatherApiException

/// Weather.gov API client (US only)
///
/// Free, unlimited calls per FR-018
/// API docs: https://www.weather.gov/documentation/services-web-api
///
/// Note: Only works for US locations. Returns error for non-US coordinates.
class WeatherGovClient {
  WeatherGovClient(this._dio);

  final Dio _dio;
  final _uuid = const Uuid();

  static const _baseUrl = 'https://api.weather.gov';
  static const _cacheDurationHours = 3; // FR-018: 3-hour minimum cache

  /// Fetch weather forecast for US coordinates
  ///
  /// Returns hourly forecast for the next 48 hours.
  /// Throws [WeatherApiException] if coordinates are outside US or on API errors.
  Future<WeatherForecast> getForecast({
    required double latitude,
    required double longitude,
  }) async {
    try {
      // Step 1: Get grid point data for coordinates
      final pointResponse = await _dio.get<Map<String, dynamic>>(
        '$_baseUrl/points/$latitude,$longitude',
        options: Options(
          headers: {
            'User-Agent': '(Swisscierge, contact@swisscierge.app)',
          },
        ),
      );

      if (pointResponse.data == null) {
        throw WeatherApiException(
          'Empty response from weather.gov. Coordinates may be outside US.',
        );
      }

      final properties = pointResponse.data!['properties'] as Map<String,
          dynamic>? ??
          {};
      final forecastHourlyUrl = properties['forecastHourly'] as String?;

      if (forecastHourlyUrl == null) {
        throw WeatherApiException(
          'Weather.gov does not support this location. Service is US-only.',
        );
      }

      // Step 2: Get hourly forecast data
      final forecastResponse = await _dio.get<Map<String, dynamic>>(
        forecastHourlyUrl,
        options: Options(
          headers: {
            'User-Agent': '(Swisscierge, contact@swisscierge.app)',
          },
        ),
      );

      if (forecastResponse.data == null) {
        throw WeatherApiException('Empty forecast response from weather.gov');
      }

      return _parseForecastResponse(
        forecastResponse.data!,
        latitude,
        longitude,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw WeatherApiException(
          'Location not found. Weather.gov only supports US locations.',
        );
      } else if (e.response?.statusCode == 500) {
        throw WeatherApiException(
          'Weather.gov service temporarily unavailable. Try again later.',
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

  /// Parse weather.gov API response into WeatherForecast
  WeatherForecast _parseForecastResponse(
    Map<String, dynamic> json,
    double latitude,
    double longitude,
  ) {
    final properties = json['properties'] as Map<String, dynamic>? ?? {};
    final periods = properties['periods'] as List<dynamic>? ?? [];

    final hourlyConditions = periods.map<WeatherCondition>((period) {
      final startTime = DateTime.parse(period['startTime'] as String);
      final temp = (period['temperature'] as num?)?.toDouble() ?? 0.0;
      final tempUnit = period['temperatureUnit'] as String? ?? 'F';

      // Convert Fahrenheit to Celsius
      final tempCelsius = tempUnit == 'F' ? (temp - 32) * 5 / 9 : temp;

      final condition = period['shortForecast'] as String? ?? 'Unknown';
      final windSpeed = period['windSpeed'] as String? ?? '';
      final windDirection = period['windDirection'] as String?;

      // Parse wind speed (e.g., "10 mph" or "5 to 10 mph")
      final windSpeedKmh = _parseWindSpeed(windSpeed);

      // Weather.gov doesn't provide all fields, set available ones
      return WeatherCondition(
        uuid: _uuid.v4(),
        forecastTime: startTime,
        condition: condition,
        temperatureCelsius: tempCelsius,
        feelsLikeCelsius: null, // Not provided by weather.gov
        humidity: period['relativeHumidity']?['value'] as int?,
        windSpeedKmh: windSpeedKmh,
        windDirection: windDirection,
        precipitationChance:
            period['probabilityOfPrecipitation']?['value'] as int?,
        precipitationMm: null, // Not directly provided
        uvIndex: null, // Not provided by weather.gov
      );
    }).toList();

    final now = DateTime.now();
    final expiresAt = now.add(const Duration(hours: _cacheDurationHours));

    return WeatherForecast(
      uuid: _uuid.v4(),
      source: WeatherSource.weatherGov,
      latitude: latitude,
      longitude: longitude,
      forecastDate: now,
      hourlyConditions: hourlyConditions,
      fetchedAt: now,
      expiresAt: expiresAt,
      locationName: null, // weather.gov doesn't provide city name
      rawJson: json.toString(),
    );
  }

  /// Parse wind speed string (e.g., "10 mph" or "5 to 10 mph") to km/h
  double? _parseWindSpeed(String windSpeed) {
    // Extract numbers from strings like "10 mph" or "5 to 10 mph"
    final numbers = RegExp(r'\d+').allMatches(windSpeed);
    if (numbers.isEmpty) return null;

    // Take the first number (or average if range)
    final speeds = numbers.map((m) => int.parse(m.group(0)!)).toList();
    final avgMph = speeds.reduce((a, b) => a + b) / speeds.length;

    // Convert mph to km/h
    return avgMph * 1.60934;
  }
}
