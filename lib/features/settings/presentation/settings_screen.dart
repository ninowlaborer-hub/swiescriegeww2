import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'settings_providers.dart';
import '../../../core/config/app_config.dart';
import '../../../core/providers.dart';

/// Main settings screen
///
/// Provides access to all app settings and data management.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // App information
          _buildSection(context, 'About', [
            ListTile(
              title: const Text('App Version'),
              subtitle: Text(
                '${AppConfig.appVersion} (${AppConfig.buildNumber})',
              ),
              trailing: const Icon(Icons.info_outline),
            ),
            ListTile(
              title: const Text('Privacy-First Architecture'),
              subtitle: const Text(
                'All data stored locally on device with encryption',
              ),
              trailing: const Icon(Icons.security),
            ),
          ]),

          const Divider(),

          // Data management
          _buildSection(context, 'Data Management', [
            ListTile(
              leading: const Icon(Icons.upload_file),
              title: const Text('Export Data'),
              subtitle: const Text('Backup all your data'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _exportData(context, ref),
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Import Data'),
              subtitle: const Text('Restore from backup'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showImportDialog(context, ref),
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever),
              title: const Text('Clear All Data'),
              subtitle: const Text('Permanently delete all app data'),
              trailing: const Icon(Icons.warning, color: Colors.red),
              onTap: () => _confirmClearAllData(context, ref),
            ),
          ]),

          const Divider(),

          // Storage
          _buildSection(context, 'Storage', [
            FutureBuilder<int>(
              future: ref.read(databaseProvider).getDatabaseSizeBytes(),
              builder: (context, snapshot) {
                final sizeBytes = snapshot.data ?? 0;
                final sizeMB = (sizeBytes / (1024 * 1024)).toStringAsFixed(2);
                final maxMB = AppConfig.maxDatabaseSizeBytes / (1024 * 1024);

                return ListTile(
                  leading: const Icon(Icons.storage),
                  title: const Text('Database Size'),
                  subtitle: Text('$sizeMB MB / $maxMB MB'),
                  trailing: CircularProgressIndicator(
                    value: sizeBytes / AppConfig.maxDatabaseSizeBytes,
                    backgroundColor: Colors.grey[300],
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.cleaning_services),
              title: const Text('Clean Up Old Data'),
              subtitle: const Text('Remove routines older than 90 days'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _cleanupOldData(context, ref),
            ),
          ]),

          const Divider(),

          // Privacy
          _buildSection(context, 'Privacy & Security', [
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Encryption'),
              subtitle: const Text('AES-256 encryption enabled'),
              trailing: const Icon(Icons.check_circle, color: Colors.green),
            ),
            ListTile(
              leading: const Icon(Icons.cloud_off),
              title: const Text('Offline-First'),
              subtitle: const Text('No backend servers, all data local'),
              trailing: const Icon(Icons.check_circle, color: Colors.green),
            ),
          ]),

          const Divider(),

          // Advanced
          _buildSection(context, 'Advanced', [
            ListTile(
              leading: const Icon(Icons.bug_report),
              title: const Text('Debug Mode'),
              subtitle: Text(AppConfig.isDebugMode ? 'Enabled' : 'Disabled'),
              trailing: Icon(
                AppConfig.isDebugMode ? Icons.check : Icons.close,
                color: AppConfig.isDebugMode ? Colors.green : Colors.grey,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('View Logs'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Navigate to logs viewer
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Future<void> _exportData(BuildContext context, WidgetRef ref) async {
    try {
      // Show loading dialog
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final service = ref.read(exportServiceProvider);
      final result = await service.exportToFile(includeCache: false);

      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog

        if (result.isSuccess && result.filePath != null) {
          // Offer to share the file
          final share = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Export Successful'),
              content: Text('Data exported to:\n${result.filePath}'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('OK'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Share'),
                ),
              ],
            ),
          );

          if (share == true && result.filePath != null) {
            await Share.shareXFiles([XFile(result.filePath!)]);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result.error ?? 'Export failed')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Export error: $e')));
      }
    }
  }

  void _showImportDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Data'),
        content: const Text(
          'Import functionality requires file picker. '
          'Select an encrypted export file to restore your data.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement file picker and import
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('File picker not yet implemented'),
                ),
              );
            },
            child: const Text('Select File'),
          ),
        ],
      ),
    );
  }

  void _confirmClearAllData(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
          'This will permanently delete all your data including routines, '
          'calendar cache, and preferences. This action cannot be undone.\n\n'
          'Consider exporting your data first.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              // TODO: Implement clear all data
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Clear all data not yet implemented'),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete Everything'),
          ),
        ],
      ),
    );
  }

  Future<void> _cleanupOldData(BuildContext context, WidgetRef ref) async {
    try {
      final database = ref.read(databaseProvider);
      final count = await database.cleanupOldRoutines();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cleaned up $count old routines')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Cleanup error: $e')));
      }
    }
  }
}
