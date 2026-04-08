import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/weather_source.dart';
import 'weather_providers.dart';

/// Weather configuration screen
///
/// Allows users to:
/// - Select weather data source (OpenWeatherMap vs weather.gov)
/// - Configure API key for OpenWeatherMap
/// - View cache statistics and remaining API calls
class WeatherConfigScreen extends ConsumerWidget {
  const WeatherConfigScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSource = ref.watch(weatherSourceProvider);
    final remainingCallsAsync = ref.watch(remainingApiCallsProvider);
    final cacheStatsAsync = ref.watch(cacheStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Settings'),
      ),
      body: ListView(
        children: [
          // Weather source selection
          ListTile(
            title: const Text('Weather Data Source'),
            subtitle: Text(currentSource.displayName),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showSourcePicker(context, ref),
          ),

          const Divider(),

          // API key configuration (OpenWeatherMap only)
          if (currentSource == WeatherSource.openWeatherMap)
            ListTile(
              title: const Text('API Key'),
              subtitle: const Text('Configure OpenWeatherMap API key'),
              trailing: const Icon(Icons.key),
              onTap: () => _showApiKeyDialog(context, ref),
            ),

          // Rate limit status (OpenWeatherMap only)
          if (currentSource == WeatherSource.openWeatherMap)
            remainingCallsAsync.when(
              data: (remaining) => ListTile(
                title: const Text('API Calls Remaining'),
                subtitle: Text('$remaining / 1000 calls today'),
                trailing: Icon(
                  remaining > 100 ? Icons.check_circle : Icons.warning,
                  color: remaining > 100 ? Colors.green : Colors.orange,
                ),
              ),
              loading: () => const ListTile(
                title: Text('API Calls Remaining'),
                subtitle: Text('Loading...'),
              ),
              error: (_, __) => const SizedBox.shrink(),
            ),

          const Divider(),

          // Cache statistics
          ListTile(
            title: const Text('Cache Statistics'),
            subtitle: cacheStatsAsync.when(
              data: (stats) => Text('${stats.entryCount} cached entries'),
              loading: () => const Text('Loading...'),
              error: (_, __) => const Text('Error loading stats'),
            ),
          ),

          // Clear cache button
          ListTile(
            title: const Text('Clear Weather Cache'),
            subtitle: const Text('Remove all cached weather data'),
            trailing: const Icon(Icons.delete_outline),
            onTap: () => _confirmClearCache(context, ref),
          ),

          const Divider(),

          // Information section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About Weather Data Sources',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                const Text(
                  'OpenWeatherMap: Global coverage, requires API key (free tier: 1000 calls/day)\n\n'
                  'Weather.gov: US locations only, unlimited calls, no API key required\n\n'
                  'Weather data is cached locally for 3 hours to minimize API usage.',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSourcePicker(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Weather Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: WeatherSource.values.map((source) {
            return RadioListTile<WeatherSource>(
              title: Text(source.displayName),
              value: source,
              groupValue: ref.read(weatherSourceProvider),
              onChanged: (value) {
                if (value != null) {
                  ref.read(weatherSourceProvider.notifier).state = value;
                  Navigator.of(context).pop();
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showApiKeyDialog(BuildContext context, WidgetRef ref) async {
    // Load current API key
    final currentApiKey = await ref.read(weatherApiKeyProvider.future);
    final controller = TextEditingController(text: currentApiKey);

    if (!context.mounted) return;

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('OpenWeatherMap API Key'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'API Key',
                hintText: 'Enter your API key',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            const Text(
              'Get a free API key at openweathermap.org\n\n'
              'Free tier: 1,000 calls/day\n'
              'Your key is stored securely on device.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final apiKey = controller.text.trim();
              if (apiKey.isNotEmpty) {
                await saveWeatherApiKeyAction(ref, apiKey);
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('API key saved successfully')),
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmClearCache(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Weather Cache?'),
        content: const Text(
          'This will remove all cached weather data. Fresh data will be fetched from the API.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final service = ref.read(weatherServiceProvider);
              await service.clearAllCache();
              if (context.mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cache cleared')),
                );
              }
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
