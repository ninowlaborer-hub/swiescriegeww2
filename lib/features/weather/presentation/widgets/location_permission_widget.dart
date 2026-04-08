import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:shared_preferences/shared_preferences.dart';

/// Widget for managing location permission flow
///
/// Displays the current permission status and provides UI for requesting
/// or managing location permissions. Handles all permission states gracefully.
/// Respects user's explicit choice to decline location access.
class LocationPermissionWidget extends StatefulWidget {
  const LocationPermissionWidget({
    super.key,
    this.onPermissionGranted,
    this.onPermissionDenied,
    this.allowDismiss = true,
  });

  /// Callback when location permission is granted
  final VoidCallback? onPermissionGranted;

  /// Callback when location permission is denied
  final VoidCallback? onPermissionDenied;

  /// Whether user can dismiss/decline the permission request
  final bool allowDismiss;

  @override
  State<LocationPermissionWidget> createState() =>
      _LocationPermissionWidgetState();
}

class _LocationPermissionWidgetState extends State<LocationPermissionWidget> {
  LocationPermission? _permissionStatus;
  bool _isLoading = false;
  bool _userDeclinedExplicitly = false;

  static const _declinedPreferenceKey = 'weather_location_declined';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _checkPermission();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userDeclinedExplicitly = prefs.getBool(_declinedPreferenceKey) ?? false;
    });
  }

  Future<void> _saveDeclinedPreference(bool declined) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_declinedPreferenceKey, declined);
    setState(() {
      _userDeclinedExplicitly = declined;
    });
  }

  Future<void> _checkPermission() async {
    setState(() => _isLoading = true);
    try {
      final permission = await Geolocator.checkPermission();
      setState(() {
        _permissionStatus = permission;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _requestPermission() async {
    setState(() => _isLoading = true);

    try {
      // Check if location services are enabled first
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          _showLocationServicesDialog();
        }
        setState(() => _isLoading = false);
        return;
      }

      // Request permission
      final permission = await Geolocator.requestPermission();
      setState(() {
        _permissionStatus = permission;
        _isLoading = false;
      });

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        widget.onPermissionGranted?.call();
      } else if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        widget.onPermissionDenied?.call();
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error requesting permission: $e')),
        );
      }
    }
  }

  Future<void> _openSettings() async {
    await ph.openAppSettings();
    // Recheck permission when user comes back
    await Future.delayed(const Duration(milliseconds: 500));
    await _checkPermission();
  }

  void _showLocationServicesDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Services Disabled'),
        content: const Text(
          'Location services are turned off on your device. '
          'Please enable location services in your device settings to use weather features.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _openSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    // If user explicitly declined, show minimal "disabled" UI
    if (_userDeclinedExplicitly) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_off, color: Colors.grey, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location Disabled',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'You chose not to use location for weather',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Weather features are disabled. You can enable location access at any time.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await _saveDeclinedPreference(false);
                    await _checkPermission();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Enable Location'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  _getPermissionIcon(),
                  color: _getPermissionColor(),
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Location Permission',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getPermissionStatusText(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _getPermissionDescription(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  IconData _getPermissionIcon() {
    switch (_permissionStatus) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        return Icons.check_circle;
      case LocationPermission.denied:
        return Icons.location_off;
      case LocationPermission.deniedForever:
        return Icons.block;
      case LocationPermission.unableToDetermine:
      default:
        return Icons.help_outline;
    }
  }

  Color _getPermissionColor() {
    switch (_permissionStatus) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        return Colors.green;
      case LocationPermission.denied:
        return Colors.orange;
      case LocationPermission.deniedForever:
        return Colors.red;
      case LocationPermission.unableToDetermine:
      default:
        return Colors.grey;
    }
  }

  String _getPermissionStatusText() {
    switch (_permissionStatus) {
      case LocationPermission.always:
        return 'Always allowed';
      case LocationPermission.whileInUse:
        return 'Allowed while using app';
      case LocationPermission.denied:
        return 'Not allowed';
      case LocationPermission.deniedForever:
        return 'Permanently denied';
      case LocationPermission.unableToDetermine:
      default:
        return 'Unknown';
    }
  }

  String _getPermissionDescription() {
    switch (_permissionStatus) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        return 'Swisscierge can access your location to provide accurate weather forecasts for your area.';
      case LocationPermission.denied:
        return 'Swisscierge needs location access to provide weather forecasts. '
            'Location data is never sent to external servers - it\'s only used to fetch weather from public APIs.';
      case LocationPermission.deniedForever:
        return 'Location permission was permanently denied. '
            'To enable weather features, please grant location permission in your device settings.';
      case LocationPermission.unableToDetermine:
      default:
        return 'Location permission status is unknown. '
            'Please try requesting permission or check your device settings.';
    }
  }

  Widget _buildActionButton() {
    switch (_permissionStatus) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        return Row(
          children: [
            const Icon(Icons.check, color: Colors.green, size: 20),
            const SizedBox(width: 8),
            Text(
              'Location permission granted',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        );

      case LocationPermission.denied:
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _requestPermission,
                icon: const Icon(Icons.location_on),
                label: const Text('Grant Location Permission'),
              ),
            ),
            if (widget.allowDismiss) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () async {
                    await _saveDeclinedPreference(true);
                    widget.onPermissionDenied?.call();
                  },
                  icon: const Icon(Icons.close),
                  label: const Text('Don\'t Use Location'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey,
                  ),
                ),
              ),
            ],
          ],
        );

      case LocationPermission.deniedForever:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _openSettings,
            icon: const Icon(Icons.settings),
            label: const Text('Open Settings'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
          ),
        );

      case LocationPermission.unableToDetermine:
      default:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _checkPermission,
            icon: const Icon(Icons.refresh),
            label: const Text('Check Permission'),
          ),
        );
    }
  }
}
