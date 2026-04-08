// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SyncConfig _$SyncConfigFromJson(Map<String, dynamic> json) => _SyncConfig(
  autoSyncEnabled: json['autoSyncEnabled'] as bool? ?? false,
  cloudProvider:
      $enumDecodeNullable(_$CloudProviderEnumMap, json['cloudProvider']) ??
      CloudProvider.manualOnly,
  syncFrequencyHours: (json['syncFrequencyHours'] as num?)?.toInt() ?? 24,
  lastSyncTime: json['lastSyncTime'] == null
      ? null
      : DateTime.parse(json['lastSyncTime'] as String),
  lastSyncError: json['lastSyncError'] as String?,
  includeCacheInSync: json['includeCacheInSync'] as bool? ?? false,
  cloudFilePath: json['cloudFilePath'] as String?,
);

Map<String, dynamic> _$SyncConfigToJson(_SyncConfig instance) =>
    <String, dynamic>{
      'autoSyncEnabled': instance.autoSyncEnabled,
      'cloudProvider': _$CloudProviderEnumMap[instance.cloudProvider]!,
      'syncFrequencyHours': instance.syncFrequencyHours,
      'lastSyncTime': instance.lastSyncTime?.toIso8601String(),
      'lastSyncError': instance.lastSyncError,
      'includeCacheInSync': instance.includeCacheInSync,
      'cloudFilePath': instance.cloudFilePath,
    };

const _$CloudProviderEnumMap = {
  CloudProvider.icloud: 'icloud',
  CloudProvider.googleDrive: 'googleDrive',
  CloudProvider.manualOnly: 'manualOnly',
};
