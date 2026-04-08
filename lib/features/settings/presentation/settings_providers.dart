import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers.dart';
import '../../../core/platform/cloud_storage_bridge.dart';
import '../data/cloud_backup_repository.dart';
import '../domain/export_service.dart';
import '../domain/export_bundle.dart';
import '../domain/sync_config.dart';

/// Export service provider
final exportServiceProvider = Provider<ExportService>((ref) {
  final database = ref.watch(databaseProvider);
  final encryptionService = ref.watch(encryptionServiceProvider);

  return ExportService(
    database: database,
    encryptionService: encryptionService,
  );
});

/// Export data provider (trigger export)
final exportDataProvider = FutureProvider.autoDispose<ExportResult>((
  ref,
) async {
  final service = ref.watch(exportServiceProvider);
  return await service.exportToFile(includeCache: false);
});

/// User preferences provider
final userPreferencesProvider = StreamProvider.autoDispose<List<dynamic>>((
  ref,
) {
  final database = ref.watch(databaseProvider);
  return database.select(database.userPreferences).watch();
});

/// Get specific preference provider
final preferenceProvider = FutureProvider.autoDispose.family<String?, String>((
  ref,
  key,
) async {
  final database = ref.watch(databaseProvider);
  final result = await (database.select(
    database.userPreferences,
  )..where((tbl) => tbl.key.equals(key))).getSingleOrNull();

  return result?.value;
});

/// Provider for CloudStorageBridge
final cloudStorageBridgeProvider = Provider<CloudStorageBridge>((ref) {
  return CloudStorageBridge();
});

/// Provider for CloudBackupRepository
final cloudBackupRepositoryProvider = Provider<CloudBackupRepository>((ref) {
  final cloudStorageBridge = ref.watch(cloudStorageBridgeProvider);
  final exportService = ref.watch(exportServiceProvider);
  return CloudBackupRepository(
    cloudStorageBridge: cloudStorageBridge,
    exportService: exportService,
  );
});

/// Provider to check if cloud storage is available
final isCloudStorageAvailableProvider = FutureProvider<bool>((ref) async {
  final repository = ref.watch(cloudBackupRepositoryProvider);
  return await repository.isCloudStorageAvailable();
});

/// Provider for sync configuration
/// TODO: Load from database/preferences
final syncConfigProvider = FutureProvider<SyncConfig>((ref) async {
  // For now, return default config
  // In production, load from SharedPreferences or database
  return const SyncConfig(
    autoSyncEnabled: false,
    cloudProvider: CloudProvider.manualOnly,
    syncFrequencyHours: 24,
    includeCacheInSync: false,
  );
});

/// Provider for list of cloud backups
final cloudBackupsProvider = FutureProvider((ref) async {
  final repository = ref.watch(cloudBackupRepositoryProvider);
  return await repository.listBackups();
});

/// Provider to check if cloud backups exist (for onboarding restore)
final hasCloudBackupsProvider = FutureProvider<bool>((ref) async {
  final repository = ref.watch(cloudBackupRepositoryProvider);
  return await repository.hasCloudBackups();
});

/// Provider for storage quota
final storageQuotaProvider = FutureProvider((ref) async {
  final repository = ref.watch(cloudBackupRepositoryProvider);
  return await repository.getStorageQuota();
});
