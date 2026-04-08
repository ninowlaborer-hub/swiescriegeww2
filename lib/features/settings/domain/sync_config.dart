import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_config.freezed.dart';
part 'sync_config.g.dart';

/// Sync configuration model
///
/// Defines user preferences for cloud backup and sync:
/// - Cloud provider (iCloud Drive for iOS, Google Drive for Android)
/// - Sync frequency
/// - Auto-sync enabled/disabled
/// - Last sync timestamp
@freezed
abstract class SyncConfig with _$SyncConfig {
  const factory SyncConfig({
    /// Whether automatic sync is enabled
    @Default(false) bool autoSyncEnabled,

    /// Cloud provider (icloud, google_drive, or manual_only)
    @Default(CloudProvider.manualOnly) CloudProvider cloudProvider,

    /// Sync frequency in hours (only applies if auto-sync is enabled)
    @Default(24) int syncFrequencyHours,

    /// Last successful sync timestamp
    DateTime? lastSyncTime,

    /// Last sync error (if any)
    String? lastSyncError,

    /// Whether to include cache data in sync
    @Default(false) bool includeCacheInSync,

    /// Cloud storage file path (provider-specific)
    String? cloudFilePath,
  }) = _SyncConfig;

  const SyncConfig._();

  factory SyncConfig.fromJson(Map<String, dynamic> json) =>
      _$SyncConfigFromJson(json);

  /// Whether sync is overdue (based on frequency)
  bool get isSyncOverdue {
    if (!autoSyncEnabled || lastSyncTime == null) {
      return false;
    }

    final nextSyncTime =
        lastSyncTime!.add(Duration(hours: syncFrequencyHours));
    return DateTime.now().isAfter(nextSyncTime);
  }

  /// Time until next sync (if auto-sync enabled)
  Duration? get timeUntilNextSync {
    if (!autoSyncEnabled || lastSyncTime == null) {
      return null;
    }

    final nextSyncTime =
        lastSyncTime!.add(Duration(hours: syncFrequencyHours));
    final now = DateTime.now();

    if (now.isAfter(nextSyncTime)) {
      return Duration.zero;
    }

    return nextSyncTime.difference(now);
  }

  /// Human-readable sync status
  String get syncStatusText {
    if (!autoSyncEnabled) {
      return 'Manual sync only';
    }

    if (lastSyncTime == null) {
      return 'Never synced';
    }

    if (lastSyncError != null) {
      return 'Last sync failed';
    }

    final now = DateTime.now();
    final difference = now.difference(lastSyncTime!);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  /// Copy with successful sync
  SyncConfig withSuccessfulSync({String? cloudFilePath}) {
    return copyWith(
      lastSyncTime: DateTime.now(),
      lastSyncError: null,
      cloudFilePath: cloudFilePath ?? this.cloudFilePath,
    );
  }

  /// Copy with failed sync
  SyncConfig withFailedSync(String error) {
    return copyWith(
      lastSyncError: error,
    );
  }
}

/// Cloud provider enum
enum CloudProvider {
  /// iCloud Drive (iOS only)
  icloud,

  /// Google Drive (Android and iOS)
  googleDrive,

  /// Manual export/import only (no automatic cloud sync)
  manualOnly,
}

extension CloudProviderExtension on CloudProvider {
  String get displayName {
    switch (this) {
      case CloudProvider.icloud:
        return 'iCloud Drive';
      case CloudProvider.googleDrive:
        return 'Google Drive';
      case CloudProvider.manualOnly:
        return 'Manual Only';
    }
  }

  String get description {
    switch (this) {
      case CloudProvider.icloud:
        return 'Sync your data using iCloud Drive (iOS only)';
      case CloudProvider.googleDrive:
        return 'Sync your data using Google Drive';
      case CloudProvider.manualOnly:
        return 'Export and import data manually';
    }
  }

  bool get isCloudBacked {
    return this != CloudProvider.manualOnly;
  }
}
