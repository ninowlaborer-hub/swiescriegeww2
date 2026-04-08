import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../../core/platform/cloud_storage_bridge.dart';
import '../domain/export_service.dart';

/// Cloud backup repository
///
/// Handles backup and restore operations with cloud storage:
/// - Upload encrypted export bundles to iCloud/Google Drive
/// - Download and restore from cloud backups
/// - Detect and list available backups
/// - Manage backup lifecycle
class CloudBackupRepository {
  CloudBackupRepository({
    required CloudStorageBridge cloudStorageBridge,
    required ExportService exportService,
  })  : _cloudStorageBridge = cloudStorageBridge,
        _exportService = exportService;

  final CloudStorageBridge _cloudStorageBridge;
  final ExportService _exportService;

  static const _backupFilePrefix = 'swisscierge_backup_';
  static const _backupFileExtension = '.encrypted.json';

  /// Check if cloud storage is available
  Future<bool> isCloudStorageAvailable() async {
    try {
      return await _cloudStorageBridge.isCloudStorageAvailable();
    } catch (e) {
      return false;
    }
  }

  /// Create and upload backup to cloud storage
  ///
  /// Returns BackupResult with cloud file ID on success
  Future<BackupResult> createBackup({
    bool includeCache = false,
  }) async {
    try {
      // Check if cloud storage is available
      final isAvailable = await isCloudStorageAvailable();
      if (!isAvailable) {
        return BackupResult.error(
          'Cloud storage not available. Please sign in to iCloud/Google Drive.',
        );
      }

      // Export data to temporary file
      final exportResult = await _exportService.exportToFile(
        includeCache: includeCache,
      );

      if (!exportResult.isSuccess || exportResult.filePath == null) {
        return BackupResult.error(
          exportResult.error ?? 'Failed to create export file',
        );
      }

      // Generate cloud filename with timestamp
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final cloudFileName =
          '$_backupFilePrefix$timestamp$_backupFileExtension';

      // Upload to cloud
      final cloudFileId = await _cloudStorageBridge.uploadFile(
        localFilePath: exportResult.filePath!,
        cloudFileName: cloudFileName,
      );

      // Clean up temporary export file
      try {
        await File(exportResult.filePath!).delete();
      } catch (_) {
        // Ignore cleanup errors
      }

      return BackupResult.success(
        cloudFileId: cloudFileId,
        timestamp: DateTime.now(),
      );
    } on CloudStorageException catch (e) {
      return BackupResult.error(e.message);
    } catch (e) {
      return BackupResult.error('Backup failed: $e');
    }
  }

  /// Restore from cloud backup
  ///
  /// [cloudFileId]: ID of backup file in cloud storage
  /// [overwriteExisting]: Whether to overwrite existing data
  Future<RestoreResult> restoreBackup({
    required String cloudFileId,
    bool overwriteExisting = false,
  }) async {
    try {
      // Get temporary directory for download
      final tempDir = await getTemporaryDirectory();
      final localFilePath = '${tempDir.path}/$cloudFileId';

      // Download from cloud
      final downloaded = await _cloudStorageBridge.downloadFile(
        cloudFileId: cloudFileId,
        localFilePath: localFilePath,
      );

      if (!downloaded) {
        return RestoreResult.error('Failed to download backup from cloud');
      }

      // Import data
      final importResult = await _exportService.importFromFile(
        localFilePath,
        overwriteExisting: overwriteExisting,
      );

      // Clean up downloaded file
      try {
        await File(localFilePath).delete();
      } catch (_) {
        // Ignore cleanup errors
      }

      if (!importResult.isSuccess) {
        return RestoreResult.error(
          importResult.error ?? 'Failed to import data',
        );
      }

      return RestoreResult.success(
        conflicts: importResult.conflicts,
      );
    } on CloudStorageException catch (e) {
      return RestoreResult.error(e.message);
    } catch (e) {
      return RestoreResult.error('Restore failed: $e');
    }
  }

  /// List available backups in cloud storage
  Future<List<CloudBackupInfo>> listBackups() async {
    try {
      final files = await _cloudStorageBridge.listFiles();

      // Filter for backup files
      final backupFiles = files.where((file) =>
          file.startsWith(_backupFilePrefix) &&
          file.endsWith(_backupFileExtension));

      // Get metadata for each backup
      final backups = <CloudBackupInfo>[];
      for (final file in backupFiles) {
        try {
          final metadata = await _cloudStorageBridge.getFileMetadata(file);
          if (metadata != null) {
            backups.add(CloudBackupInfo(
              cloudFileId: file,
              fileName: metadata['name'] as String? ?? file,
              sizeBytes: metadata['size'] as int? ?? 0,
              modifiedAt: metadata['modified'] != null
                  ? DateTime.parse(metadata['modified'] as String)
                  : DateTime.now(),
            ));
          }
        } catch (_) {
          // Skip files with invalid metadata
          continue;
        }
      }

      // Sort by modification time (newest first)
      backups.sort((a, b) => b.modifiedAt.compareTo(a.modifiedAt));

      return backups;
    } on CloudStorageException catch (e) {
      throw Exception('Failed to list backups: ${e.message}');
    } catch (e) {
      throw Exception('Failed to list backups: $e');
    }
  }

  /// Delete backup from cloud storage
  Future<bool> deleteBackup(String cloudFileId) async {
    try {
      return await _cloudStorageBridge.deleteFile(cloudFileId);
    } on CloudStorageException {
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Get storage quota information
  Future<StorageQuota?> getStorageQuota() async {
    try {
      final quota = await _cloudStorageBridge.getStorageQuota();
      if (quota == null) {
        return null;
      }

      return StorageQuota(
        totalBytes: quota['total'] ?? 0,
        usedBytes: quota['used'] ?? 0,
        availableBytes: quota['available'] ?? 0,
      );
    } catch (_) {
      return null;
    }
  }

  /// Detect if there are any cloud backups available
  ///
  /// Used during onboarding to offer restoration
  Future<bool> hasCloudBackups() async {
    try {
      final backups = await listBackups();
      return backups.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}

/// Cloud backup info
class CloudBackupInfo {
  const CloudBackupInfo({
    required this.cloudFileId,
    required this.fileName,
    required this.sizeBytes,
    required this.modifiedAt,
  });

  final String cloudFileId;
  final String fileName;
  final int sizeBytes;
  final DateTime modifiedAt;

  /// Human-readable file size
  String get sizeFormatted {
    if (sizeBytes < 1024) {
      return '$sizeBytes B';
    } else if (sizeBytes < 1024 * 1024) {
      return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  /// Human-readable timestamp
  String get timestampFormatted {
    final now = DateTime.now();
    final difference = now.difference(modifiedAt);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hr ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${modifiedAt.year}-${modifiedAt.month.toString().padLeft(2, '0')}-${modifiedAt.day.toString().padLeft(2, '0')}';
    }
  }
}

/// Storage quota information
class StorageQuota {
  const StorageQuota({
    required this.totalBytes,
    required this.usedBytes,
    required this.availableBytes,
  });

  final int totalBytes;
  final int usedBytes;
  final int availableBytes;

  double get usagePercentage {
    if (totalBytes == 0) return 0.0;
    return usedBytes / totalBytes;
  }

  String get totalFormatted => _formatBytes(totalBytes);
  String get usedFormatted => _formatBytes(usedBytes);
  String get availableFormatted => _formatBytes(availableBytes);

  String _formatBytes(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }
}

/// Backup operation result
class BackupResult {
  const BackupResult._({
    this.cloudFileId,
    this.timestamp,
    this.error,
  });

  final String? cloudFileId;
  final DateTime? timestamp;
  final String? error;

  bool get isSuccess => cloudFileId != null && error == null;
  bool get isError => error != null;

  factory BackupResult.success({
    required String cloudFileId,
    required DateTime timestamp,
  }) {
    return BackupResult._(
      cloudFileId: cloudFileId,
      timestamp: timestamp,
    );
  }

  factory BackupResult.error(String error) {
    return BackupResult._(error: error);
  }
}

/// Restore operation result
class RestoreResult {
  const RestoreResult._({
    this.conflicts,
    this.error,
  });

  final List<String>? conflicts;
  final String? error;

  bool get isSuccess => error == null;
  bool get isError => error != null;
  bool get hasConflicts => (conflicts?.isNotEmpty ?? false);

  factory RestoreResult.success({List<String>? conflicts}) {
    return RestoreResult._(conflicts: conflicts ?? []);
  }

  factory RestoreResult.error(String error) {
    return RestoreResult._(error: error);
  }
}
