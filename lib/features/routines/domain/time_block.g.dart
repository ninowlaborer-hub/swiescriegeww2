// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TimeBlock _$TimeBlockFromJson(Map<String, dynamic> json) => _TimeBlock(
  id: json['id'] as String,
  routineId: json['routineId'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  startTime: DateTime.parse(json['startTime'] as String),
  endTime: DateTime.parse(json['endTime'] as String),
  activityType: json['activityType'] as String,
  category: json['category'] as String?,
  priority: (json['priority'] as num?)?.toInt() ?? 0,
  isSnoozed: json['isSnoozed'] as bool? ?? false,
  snoozedUntil: json['snoozedUntil'] == null
      ? null
      : DateTime.parse(json['snoozedUntil'] as String),
  source: json['source'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$TimeBlockToJson(_TimeBlock instance) =>
    <String, dynamic>{
      'id': instance.id,
      'routineId': instance.routineId,
      'title': instance.title,
      'description': instance.description,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'activityType': instance.activityType,
      'category': instance.category,
      'priority': instance.priority,
      'isSnoozed': instance.isSnoozed,
      'snoozedUntil': instance.snoozedUntil?.toIso8601String(),
      'source': instance.source,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
