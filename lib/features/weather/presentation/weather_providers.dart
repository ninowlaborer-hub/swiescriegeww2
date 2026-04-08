import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/database/database.dart';
import '../../../core/providers.dart';
import '../../../shared/services/location_service.dart';
import '../data/weather_local_datasource.dart';
import '../data/openweathermap_client.dart';
import '../data/weathergov_client.dart';
import '../data/weather_repository.dart';
import '../domain/weather_service.dart';
import '../domain/weather_source.dart';

/// Dio provider for HTTP requests
final _dioProvider = Provider<Dio>((ref) => Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  ));

/// Weather local datasource provider
final _weatherLocalDataSourceProvider = Provider<WeatherLocalDataSource>((ref) {
  final database = ref.watch(databaseProvider);
  return WeatherLocalDataSource(database);
});

/// OpenWeatherMap client provider
final _openWeatherMapClientProvider = Provider<OpenWeatherMapClient>((ref) {
  final dio = ref.watch(_dioProvider);
  // API key will be retrieved from user preferences
  // For now, returning client without key (will throw error if used)
  return OpenWeatherMapClient(dio);
});

/// Weather.gov client provider
final _weatherGovClientProvider = Provider<WeatherGovClient>((ref) {
  final dio = ref.watch(_dioProvider);
  return WeatherGovClient(dio);
});

/// Weather repository provider
final _weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return WeatherRepository(
    localDataSource: ref.watch(_weatherLocalDataSourceProvider),
    openWeatherMapClient: ref.watch(_openWeatherMapClientProvider),
    weatherGovClient: ref.watch(_weatherGovClientProvider),
  );
});

/// Weather service provider
final weatherServiceProvider = Provider<WeatherService>((ref) {
  return WeatherService(ref.watch(_weatherRepositoryProvider));
});

/// Weather API key provider
final weatherApiKeyProvider = FutureProvider<String?>((ref) async {
  final database = ref.watch(databaseProvider);
  final result = await (database.select(database.userPreferences)
        ..where((tbl) => tbl.key.equals('weather_api_key')))
      .getSingleOrNull();
  return result?.value;
});

/// Current weather source provider (from user preferences)
final weatherSourceProvider = StateProvider<WeatherSource>((ref) {
  // Default to OpenWeatherMap
  // In production, this should be loaded from user preferences
  return WeatherSource.openWeatherMap;
});

/// Location service provider
final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

/// Current location provider (latitude, longitude)
///
/// Automatically fetches location when app starts if permission granted.
final currentLocationProvider =
    FutureProvider.autoDispose<(double, double)?>((ref) async {
  final locationService = ref.watch(locationServiceProvider);

  try {
    // Try to get last known location first (faster)
    final lastKnown = await locationService.getLastKnownLocation();
    if (lastKnown != null) return lastKnown;

    // If no last known location, get current location
    return await locationService.getCurrentLocation();
  } catch (e) {
    // Permission denied or error - return null
    return null;
  }
});

/// Weather forecast provider
///
/// Fetches weather forecast for current location using selected source.
/// Automatically refetches when location or source changes.
final weatherForecastProvider =
    FutureProvider.autoDispose<WeatherForecastResult?>((ref) async {
  final service = ref.watch(weatherServiceProvider);
  final source = ref.watch(weatherSourceProvider);
  final locationAsync = ref.watch(currentLocationProvider);

  // Wait for location to load - use when to handle AsyncValue
  return locationAsync.when(
    data: (location) async {
      if (location == null) {
        // No location available
        return null;
      }

      final (latitude, longitude) = location;

      return await service.getForecast(
        latitude: latitude,
        longitude: longitude,
        source: source,
      );
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Remaining API calls provider
final remainingApiCallsProvider = FutureProvider.autoDispose<int>((ref) async {
  final service = ref.watch(weatherServiceProvider);
  return await service.getRemainingApiCalls();
});

/// Cache stats provider
final cacheStatsProvider = FutureProvider.autoDispose<CacheStats>((ref) async {
  final service = ref.watch(weatherServiceProvider);
  return await service.getCacheStats();
});

/// Actions

/// Save weather API key action
Future<void> saveWeatherApiKeyAction(WidgetRef ref, String apiKey) async {
  final database = ref.read(databaseProvider);

  // Check if key already exists
  final existing = await (database.select(database.userPreferences)
        ..where((tbl) => tbl.key.equals('weather_api_key')))
      .getSingleOrNull();

  final now = DateTime.now();

  if (existing != null) {
    // Update existing
    await (database.update(database.userPreferences)
          ..where((tbl) => tbl.key.equals('weather_api_key')))
        .write(UserPreferencesCompanion(
      value: Value(apiKey),
      updatedAt: Value(now),
    ));
  } else {
    // Insert new
    await database.into(database.userPreferences).insert(
      UserPreferencesCompanion(
        key: Value('weather_api_key'),
        value: Value(apiKey),
        type: Value('string'),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }

  // Refresh the provider
  ref.invalidate(weatherApiKeyProvider);
}
