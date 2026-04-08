import 'package:geolocator/geolocator.dart';

/// Location service
///
/// Provides location detection using platform location services.
/// Used for weather forecasts per FR-018.
class LocationService {
  /// Get current location
  ///
  /// Returns (latitude, longitude) or null if permission denied.
  /// Requests permission if not already granted.
  Future<(double, double)?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw LocationException(
          'Location services are disabled. Please enable location in settings.',
        );
      }

      // Check and request permission
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null; // Permission denied
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw LocationException(
          'Location permissions are permanently denied. Please enable in settings.',
        );
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low, // Low accuracy is fine for weather
          timeLimit: Duration(seconds: 10),
        ),
      );

      return (position.latitude, position.longitude);
    } on LocationException {
      rethrow;
    } catch (e) {
      throw LocationException('Failed to get location: $e');
    }
  }

  /// Check if location permission is granted
  Future<bool> hasLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  /// Open app settings for location permissions
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  /// Get last known location (faster, may be stale)
  Future<(double, double)?> getLastKnownLocation() async {
    try {
      final position = await Geolocator.getLastKnownPosition();
      if (position == null) return null;

      return (position.latitude, position.longitude);
    } catch (e) {
      return null;
    }
  }
}

/// Exception thrown when location operations fail
class LocationException implements Exception {
  LocationException(this.message);

  final String message;

  @override
  String toString() => 'LocationException: $message';
}
