import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/weather_source.dart';
import '../weather_providers.dart';

/// Reusable widget for selecting weather data source
///
/// Displays current source and allows switching between OpenWeatherMap and Weather.gov.
/// Shows relevant information for each source (API limits, coverage, etc.).
class WeatherSourceSelector extends ConsumerWidget {
  const WeatherSourceSelector({
    super.key,
    this.onSourceChanged,
  });

  /// Callback when the weather source is changed
  final void Function(WeatherSource)? onSourceChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSource = ref.watch(weatherSourceProvider);
    final remainingCallsAsync = ref.watch(remainingApiCallsProvider);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.cloud, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weather Data Source',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentSource.displayName,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showSourceDialog(context, ref),
                  tooltip: 'Change source',
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildSourceInfo(context, ref, currentSource, remainingCallsAsync),
          ),
        ],
      ),
    );
  }

  Widget _buildSourceInfo(
    BuildContext context,
    WidgetRef ref,
    WeatherSource source,
    AsyncValue<int> remainingCallsAsync,
  ) {
    switch (source) {
      case WeatherSource.openWeatherMap:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
              context,
              Icons.public,
              'Coverage',
              'Worldwide',
              Colors.green,
            ),
            const SizedBox(height: 8),
            remainingCallsAsync.when(
              data: (remaining) => _buildInfoRow(
                context,
                Icons.api,
                'API Calls Today',
                '$remaining / 1000 remaining',
                remaining > 100 ? Colors.green : Colors.orange,
              ),
              loading: () => _buildInfoRow(
                context,
                Icons.api,
                'API Calls Today',
                'Loading...',
                Colors.grey,
              ),
              error: (_, __) => _buildInfoRow(
                context,
                Icons.api,
                'API Calls Today',
                'Error',
                Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              Icons.key,
              'API Key',
              'Required (free tier)',
              Colors.blue,
            ),
          ],
        );

      case WeatherSource.weatherGov:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
              context,
              Icons.location_on,
              'Coverage',
              'United States only',
              Colors.blue,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              Icons.api,
              'API Calls',
              'Unlimited',
              Colors.green,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              Icons.key_off,
              'API Key',
              'Not required',
              Colors.green,
            ),
          ],
        );
    }
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  void _showSourceDialog(BuildContext context, WidgetRef ref) {
    final currentSource = ref.read(weatherSourceProvider);

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Select Weather Source'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: WeatherSource.values.map((source) {
              return _WeatherSourceOption(
                source: source,
                isSelected: source == currentSource,
                onTap: () {
                  ref.read(weatherSourceProvider.notifier).state = source;
                  onSourceChanged?.call(source);
                  Navigator.of(dialogContext).pop();

                  // Show confirmation
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Switched to ${source.displayName}'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

/// Individual weather source option in the selection dialog
class _WeatherSourceOption extends StatelessWidget {
  const _WeatherSourceOption({
    required this.source,
    required this.isSelected,
    required this.onTap,
  });

  final WeatherSource source;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected
          ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
          : null,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Radio<bool>(
                    value: true,
                    groupValue: isSelected,
                    onChanged: (_) => onTap(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      source.displayName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: Theme.of(context).primaryColor,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 56.0),
                child: Text(
                  _getSourceDescription(source),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[700],
                      ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 56.0),
                child: Wrap(
                  spacing: 8,
                  children: _getSourceChips(context, source),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getSourceDescription(WeatherSource source) {
    switch (source) {
      case WeatherSource.openWeatherMap:
        return 'Global weather data from OpenWeatherMap. Requires free API key. '
            'Limited to 1000 API calls per day.';
      case WeatherSource.weatherGov:
        return 'Free weather data from the US National Weather Service. '
            'No API key required. US locations only.';
    }
  }

  List<Widget> _getSourceChips(BuildContext context, WeatherSource source) {
    final chips = <Widget>[];

    switch (source) {
      case WeatherSource.openWeatherMap:
        chips.addAll([
          Chip(
            label: const Text('Global'),
            avatar: const Icon(Icons.public, size: 16),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          Chip(
            label: const Text('API Key Required'),
            avatar: const Icon(Icons.key, size: 16),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          Chip(
            label: const Text('1000 calls/day'),
            avatar: const Icon(Icons.api, size: 16),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ]);
        break;

      case WeatherSource.weatherGov:
        chips.addAll([
          Chip(
            label: const Text('US Only'),
            avatar: const Icon(Icons.location_on, size: 16),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          Chip(
            label: const Text('No API Key'),
            avatar: const Icon(Icons.key_off, size: 16),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          Chip(
            label: const Text('Unlimited'),
            avatar: const Icon(Icons.all_inclusive, size: 16),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ]);
        break;
    }

    return chips;
  }
}
