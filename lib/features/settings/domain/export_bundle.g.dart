// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_bundle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DataExportBundle _$DataExportBundleFromJson(Map<String, dynamic> json) =>
    _DataExportBundle(
      version: json['version'] as String,
      exportedAt: DateTime.parse(json['exportedAt'] as String),
      deviceId: json['deviceId'] as String,
      data: ExportData.fromJson(json['data'] as Map<String, dynamic>),
      encryptionKeyHash: json['encryptionKeyHash'] as String?,
    );

Map<String, dynamic> _$DataExportBundleToJson(_DataExportBundle instance) =>
    <String, dynamic>{
      'version': instance.version,
      'exportedAt': instance.exportedAt.toIso8601String(),
      'deviceId': instance.deviceId,
      'data': instance.data,
      'encryptionKeyHash': instance.encryptionKeyHash,
    };

_ExportData _$ExportDataFromJson(Map<String, dynamic> json) => _ExportData(
  routines: (json['routines'] as List<dynamic>)
      .map((e) => e as Map<String, dynamic>)
      .toList(),
  timeBlocks: (json['timeBlocks'] as List<dynamic>)
      .map((e) => e as Map<String, dynamic>)
      .toList(),
  calendarCache: (json['calendarCache'] as List<dynamic>)
      .map((e) => e as Map<String, dynamic>)
      .toList(),
  weatherCache: (json['weatherCache'] as List<dynamic>)
      .map((e) => e as Map<String, dynamic>)
      .toList(),
  preferences: json['preferences'] as Map<String, dynamic>,
);

Map<String, dynamic> _$ExportDataToJson(_ExportData instance) =>
    <String, dynamic>{
      'routines': instance.routines,
      'timeBlocks': instance.timeBlocks,
      'calendarCache': instance.calendarCache,
      'weatherCache': instance.weatherCache,
      'preferences': instance.preferences,
    };
