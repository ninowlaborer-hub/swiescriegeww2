import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../../../core/platform/cloud_storage_bridge.dart';
import '../data/cloud_backup_repository.dart';
import 'settings_providers.dart';

/// Data export/import UI
///
/// Provides comprehensive data management:
/// - Manual export/import with file sharing
/// - Cloud backup/restore (iCloud/Google Drive)
/// - Backup history and management
/// - Storage quota monitoring
class DataManagementScreen extends ConsumerStatefulWidget {
  const DataManagementScreen({super.key});

  @override
  ConsumerState<DataManagementScreen> createState() =>
      _DataManagementScreenState();
}

class _DataManagementScreenState extends ConsumerState<DataManagementScreen> {
  bool _isLoading = false;
  List<CloudBackupInfo>? _cloudBackups;
  StorageQuota? _storageQuota;

  @override
  void initState() {
    super.initState();
    _loadCloudBackups();
  }

  Future<void> _loadCloudBackups() async {
    try {
      final cloudBridge = CloudStorageBridge();
      final exportService = ref.read(exportServiceProvider);
      final repository = CloudBackupRepository(
        cloudStorageBridge: cloudBridge,
        exportService: exportService,
      );

      final isAvailable = await repository.isCloudStorageAvailable();
      if (!isAvailable) {
        return;
      }

      final backups = await repository.listBackups();
      final quota = await repository.getStorageQuota();

      if (mounted) {
        setState(() {
          _cloudBackups = backups;
          _storageQuota = quota;
        });
      }
    } catch (e) {
      // Silently fail - cloud storage might not be available
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Management'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                // Manual Export/Import Section
                _buildSection(
                  context,
                  'Manual Backup',
                  [
                    ListTile(
                      leading: const Icon(Icons.upload_file),
                      title: const Text('Export Data'),
                      subtitle: const Text('Save encrypted backup to device'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _manualExport,
                    ),
                    ListTile(
                      leading: const Icon(Icons.download),
                      title: const Text('Import Data'),
                      subtitle: const Text('Restore from encrypted backup'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _manualImport,
                    ),
                  ],
                ),

                const Divider(),

                // Cloud Backup Section
                if (_cloudBackups != null) ...[
                  _buildSection(
                    context,
                    Platform.isIOS ? 'iCloud Backup' : 'Cloud Backup',
                    [
                      if (_storageQuota != null)
                        _buildStorageQuotaCard(_storageQuota!),
                      ListTile(
                        leading: const Icon(Icons.cloud_upload),
                        title: const Text('Create Backup'),
                        subtitle: const Text('Upload to cloud storage'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: _createCloudBackup,
                      ),
                    ],
                  ),

                  const Divider(),

                  // Backup History
                  if (_cloudBackups!.isNotEmpty) ...[
                    _buildSection(
                      context,
                      'Backup History',
                      _cloudBackups!
                          .map((backup) => _buildBackupTile(backup))
                          .toList(),
                    ),
                  ] else ...[
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.cloud_off,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No cloud backups yet',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Create your first backup to protect your data',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.cloud_off,
                              size: 48,
                              color: Colors.orange,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              Platform.isIOS
                                  ? 'iCloud Not Available'
                                  : 'Cloud Storage Not Available',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              Platform.isIOS
                                  ? 'Sign in to iCloud in Settings to enable cloud backups'
                                  : 'Sign in to Google Drive to enable cloud backups',
                              style: TextStyle(color: Colors.grey[700]),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
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

  Widget _buildStorageQuotaCard(StorageQuota quota) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Storage Used',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  '${quota.usedFormatted} / ${quota.totalFormatted}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: quota.usagePercentage,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                quota.usagePercentage > 0.9 ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${quota.availableFormatted} available',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackupTile(CloudBackupInfo backup) {
    return ListTile(
      leading: const Icon(Icons.cloud_done),
      title: Text(backup.timestampFormatted),
      subtitle: Text(backup.sizeFormatted),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'restore') {
            _restoreFromCloud(backup);
          } else if (value == 'delete') {
            _deleteCloudBackup(backup);
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'restore',
            child: Row(
              children: [
                Icon(Icons.restore),
                SizedBox(width: 8),
                Text('Restore'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete, color: Colors.red),
                SizedBox(width: 8),
                Text('Delete', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _manualExport() async {
    // Use existing export logic from settings_screen.dart
    try {
      setState(() => _isLoading = true);

      final service = ref.read(exportServiceProvider);
      final result = await service.exportToFile(includeCache: false);

      setState(() => _isLoading = false);

      if (mounted && result.isSuccess && result.filePath != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Exported to: ${result.filePath}'),
            action: SnackBarAction(
              label: 'Share',
              onPressed: () {
                // TODO: Implement share
              },
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    }
  }

  Future<void> _manualImport() async {
    // TODO: Implement file picker for import
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('File picker not yet implemented')),
    );
  }

  Future<void> _createCloudBackup() async {
    try {
      setState(() => _isLoading = true);

      final cloudBridge = CloudStorageBridge();
      final exportService = ref.read(exportServiceProvider);
      final repository = CloudBackupRepository(
        cloudStorageBridge: cloudBridge,
        exportService: exportService,
      );

      final result = await repository.createBackup(includeCache: false);

      setState(() => _isLoading = false);

      if (mounted) {
        if (result.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Backup created successfully')),
          );
          await _loadCloudBackups(); // Refresh list
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result.error ?? 'Backup failed')),
          );
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Backup failed: $e')),
        );
      }
    }
  }

  Future<void> _restoreFromCloud(CloudBackupInfo backup) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore Backup?'),
        content: Text(
          'This will restore data from ${backup.timestampFormatted}. '
          'Existing data may be overwritten.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.green),
            child: const Text('Restore'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      setState(() => _isLoading = true);

      final cloudBridge = CloudStorageBridge();
      final exportService = ref.read(exportServiceProvider);
      final repository = CloudBackupRepository(
        cloudStorageBridge: cloudBridge,
        exportService: exportService,
      );

      final result = await repository.restoreBackup(
        cloudFileId: backup.cloudFileId,
        overwriteExisting: true,
      );

      setState(() => _isLoading = false);

      if (mounted) {
        if (result.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                result.hasConflicts
                    ? 'Restored with ${result.conflicts!.length} conflicts'
                    : 'Restored successfully',
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result.error ?? 'Restore failed')),
          );
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Restore failed: $e')),
        );
      }
    }
  }

  Future<void> _deleteCloudBackup(CloudBackupInfo backup) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Backup?'),
        content: Text(
          'Delete backup from ${backup.timestampFormatted}? '
          'This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final cloudBridge = CloudStorageBridge();
      final exportService = ref.read(exportServiceProvider);
      final repository = CloudBackupRepository(
        cloudStorageBridge: cloudBridge,
        exportService: exportService,
      );

      final deleted = await repository.deleteBackup(backup.cloudFileId);

      if (mounted) {
        if (deleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Backup deleted')),
          );
          await _loadCloudBackups(); // Refresh list
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete backup')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Delete failed: $e')),
        );
      }
    }
  }
}
