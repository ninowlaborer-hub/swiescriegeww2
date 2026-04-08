import 'package:flutter/material.dart';
import '../../domain/weather_forecast.dart';
import '../../domain/weather_condition.dart';

/// Weather card widget
///
/// Displays current weather and forecast information.
class WeatherCard extends StatelessWidget {
  const WeatherCard({
    required this.forecast,
    this.isFromCache = false,
    this.cacheReason,
    super.key,
  });

  final WeatherForecast forecast;
  final bool isFromCache;
  final String? cacheReason;

  @override
  Widget build(BuildContext context) {
    final current = forecast.currentCondition;

    if (current == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No weather data available'),
        ),
      );
    }

    final conditionType = ConditionType.fromString(current.condition);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with location and source
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  forecast.locationName ?? 'Current Location',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (isFromCache)
                  Tooltip(
                    message: cacheReason ?? 'Using cached data',
                    child: const Icon(
                      Icons.offline_bolt,
                      color: Colors.orange,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            // Current weather
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Temperature and condition
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            conditionType.emoji,
                            style: const TextStyle(fontSize: 48),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${current.temperatureCelsius.round()}°C',
                                style: Theme.of(context).textTheme.displayMedium,
                              ),
                              Text(
                                conditionType.displayName,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Additional details
                      if (current.feelsLikeCelsius != null)
                        _DetailRow(
                          icon: Icons.thermostat,
                          label: 'Feels like',
                          value: '${current.feelsLikeCelsius!.round()}°C',
                        ),
                      if (current.humidity != null)
                        _DetailRow(
                          icon: Icons.water_drop,
                          label: 'Humidity',
                          value: '${current.humidity}%',
                        ),
                      if (current.windSpeedKmh != null)
                        _DetailRow(
                          icon: Icons.air,
                          label: 'Wind',
                          value:
                              '${current.windSpeedKmh!.round()} km/h ${current.windDirection ?? ''}',
                        ),
                      if (current.precipitationChance != null &&
                          current.precipitationChance! > 0)
                        _DetailRow(
                          icon: Icons.umbrella,
                          label: 'Rain chance',
                          value: '${current.precipitationChance}%',
                        ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Last updated
            Text(
              'Last updated: ${_formatTime(forecast.fetchedAt)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
