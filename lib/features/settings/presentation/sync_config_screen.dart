// features/settings/presentation/sync_config_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../domain/sync_config.dart';
import 'settings_providers.dart';

/// Screen for configuring cloud backup sync settings
/// iOS: iCloud Drive, Android: Google Drive
class SyncConfigScreen extends ConsumerStatefulWidget {
  const SyncConfigScreen({super.key});

  @override
  ConsumerState<SyncConfigScreen> createState() => _SyncConfigScreenState();
}

class _SyncConfigScreenState extends ConsumerState<SyncConfigScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final syncConfig = ref.watch(syncConfigProvider);
    final cloudAvailable = ref.watch(isCloudStorageAvailableProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cloud Backup Settings')),
      body: syncConfig.when(
        data: (config) =>
            _buildConfigView(context, theme, config, cloudAvailable),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorView(context, error),
      ),
    );
  }

  Widget _buildConfigView(
    BuildContext context,
    ThemeData theme,
    SyncConfig config,
    AsyncValue<bool> cloudAvailable,
  ) {
    final isAvailable = cloudAvailable.value ?? false;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Cloud provider info
        _buildProviderCard(theme, isAvailable),
        const SizedBox(height: 16),

        // Enable/disable backup
        Card(
          child: SwitchListTile(
            title: const Text('Enable Cloud Backup'),
            subtitle: Text(
              isAvailable
                  ? 'Automatically backup your data to the cloud'
                  : 'Cloud storage not available',
            ),
            value: config.autoSyncEnabled && isAvailable,
            onChanged: isAvailable ? (value) => _toggleAutoBackup(value) : null,
          ),
        ),
        const SizedBox(height: 16),

        if (config.autoSyncEnabled && isAvailable) ...[
          // Sync frequency
          _buildFrequencyCard(theme, config),
          const SizedBox(height: 16),

          // WiFi only option (for Google Drive)
          if (config.cloudProvider == CloudProvider.googleDrive)
            _buildWifiOnlyCard(theme, config),
          const SizedBox(height: 16),

          // Include cache option
          _buildCacheInclusionCard(theme, config),
          const SizedBox(height: 16),

          // Last sync status
          _buildLastSyncCard(theme, config),
          const SizedBox(height: 16),

          // Manual backup button
          _buildManualBackupButton(theme),
        ],

        if (!isAvailable) ...[
          const SizedBox(height: 16),
          _buildNotAvailableCard(theme),
        ],
      ],
    );
  }

  Widget _buildProviderCard(ThemeData theme, bool isAvailable) {
    final provider = Platform.isIOS
        ? CloudProvider.icloud
        : CloudProvider.googleDrive;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Platform.isIOS ? Icons.cloud : Icons.folder,
                  size: 32,
                  color: isAvailable ? theme.colorScheme.primary : Colors.grey,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.displayName,
                        style: theme.textTheme.titleMedium,
                      ),
                      Text(
                        provider.description,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (isAvailable)
                  const Icon(Icons.check_circle, color: Colors.green)
                else
                  const Icon(Icons.error_outline, color: Colors.orange),
              ],
            ),
            if (!isAvailable) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        Platform.isIOS
                            ? 'Sign in to iCloud in Settings to enable backup'
                            : 'Install Google Play Services to enable backup',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFrequencyCard(ThemeData theme, SyncConfig config) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Backup Frequency', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'How often to automatically backup your data',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 1, label: Text('Hourly')),
                ButtonSegment(value: 24, label: Text('Daily')),
                ButtonSegment(value: 168, label: Text('Weekly')),
              ],
              selected: {config.syncFrequencyHours},
              onSelectionChanged: (Set<int> selection) {
                _updateSyncFrequency(selection.first);
              },
            ),
            const SizedBox(height: 8),
            if (config.timeUntilNextSync != null)
              Text(
                'Next backup in ${_formatDuration(config.timeUntilNextSync!)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWifiOnlyCard(ThemeData theme, SyncConfig config) {
    return Card(
      child: SwitchListTile(
        title: const Text('WiFi Only'),
        subtitle: const Text('Only backup when connected to WiFi'),
        value: true, // Default for Google Drive
        onChanged: null, // Always enabled for Google Drive
      ),
    );
  }

  Widget _buildCacheInclusionCard(ThemeData theme, SyncConfig config) {
    return Card(
      child: SwitchListTile(
        title: const Text('Include Cache Data'),
        subtitle: const Text(
          'Include calendar and weather cache (increases backup size)',
        ),
        value: config.includeCacheInSync,
        onChanged: (value) => _toggleCacheInclusion(value),
      ),
    );
  }

  Widget _buildLastSyncCard(ThemeData theme, SyncConfig config) {
    return Card(
      child: ListTile(
        leading: Icon(
          config.lastSyncError != null ? Icons.error_outline : Icons.cloud_done,
          color: config.lastSyncError != null ? Colors.red : Colors.green,
        ),
        title: const Text('Last Backup'),
        subtitle: Text(
          config.lastSyncError != null
              ? 'Error: ${config.lastSyncError}'
              : config.syncStatusText,
        ),
        trailing: config.isSyncOverdue
            ? const Icon(Icons.warning_amber, color: Colors.orange)
            : null,
      ),
    );
  }

  Widget _buildManualBackupButton(ThemeData theme) {
    return FilledButton.icon(
      onPressed: () => _performManualBackup(),
      icon: const Icon(Icons.backup),
      label: const Text('Backup Now'),
    );
  }

  Widget _buildNotAvailableCard(ThemeData theme) {
    return Card(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              Icons.cloud_off,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              Platform.isIOS
                  ? 'iCloud Drive Not Available'
                  : 'Google Drive Not Available',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              Platform.isIOS
                  ? 'Sign in to iCloud in Settings to enable automatic backups'
                  : 'Install Google Play Services to enable automatic backups',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            const Text(
              'You can still export and import data manually',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Failed to Load Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(error.toString()),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                ref.invalidate(syncConfigProvider);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleAutoBackup(bool enabled) async {
    try {
      final exportService = ref.read(exportServiceProvider);
      // TODO: Update sync config in database
      ref.invalidate(syncConfigProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              enabled ? 'Cloud backup enabled' : 'Cloud backup disabled',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _updateSyncFrequency(int hours) async {
    try {
      // TODO: Update sync frequency in database
      ref.invalidate(syncConfigProvider);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Sync frequency updated')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _toggleCacheInclusion(bool include) async {
    try {
      // TODO: Update cache inclusion setting
      ref.invalidate(syncConfigProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              include
                  ? 'Cache data will be included in backups'
                  : 'Cache data excluded from backups',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _performManualBackup() async {
    try {
      // Show loading indicator
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Creating backup...')));

      final backupRepo = ref.read(cloudBackupRepositoryProvider);
      final config = await ref.read(syncConfigProvider.future);

      final result = await backupRepo.createBackup(
        includeCache: config.includeCacheInSync,
      );

      if (!mounted) return;

      if (result.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Backup created successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Refresh sync config to show updated last sync time
        ref.invalidate(syncConfigProvider);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Backup failed: ${result.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours < 1) {
      return '${duration.inMinutes} minutes';
    } else if (duration.inDays < 1) {
      return '${duration.inHours} hours';
    } else {
      return '${duration.inDays} days';
    }
  }
}
