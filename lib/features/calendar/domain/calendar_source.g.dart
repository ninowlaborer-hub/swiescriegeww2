// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_source.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CalendarSource _$CalendarSourceFromJson(Map<String, dynamic> json) =>
    _CalendarSource(
      id: json['id'] as String,
      name: json['name'] as String,
      color: (json['color'] as num).toInt(),
      isSelected: json['isSelected'] as bool,
      isPrimary: json['isPrimary'] as bool,
      isReadOnly: json['isReadOnly'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      accountName: json['accountName'] as String?,
      accountType: json['accountType'] as String?,
      sourceType: $enumDecodeNullable(
        _$CalendarSourceTypeEnumMap,
        json['sourceType'],
      ),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$CalendarSourceToJson(_CalendarSource instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'color': instance.color,
      'isSelected': instance.isSelected,
      'isPrimary': instance.isPrimary,
      'isReadOnly': instance.isReadOnly,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'accountName': instance.accountName,
      'accountType': instance.accountType,
      'sourceType': _$CalendarSourceTypeEnumMap[instance.sourceType],
      'metadata': instance.metadata,
    };

const _$CalendarSourceTypeEnumMap = {
  CalendarSourceType.local: 'local',
  CalendarSourceType.google: 'google',
  CalendarSourceType.icloud: 'icloud',
  CalendarSourceType.exchange: 'exchange',
  CalendarSourceType.outlook: 'outlook',
  CalendarSourceType.other: 'other',
};
