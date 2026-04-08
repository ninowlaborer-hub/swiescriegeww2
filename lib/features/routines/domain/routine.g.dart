// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Routine _$RoutineFromJson(Map<String, dynamic> json) => _Routine(
  id: json['id'] as String,
  date: DateTime.parse(json['date'] as String),
  title: json['title'] as String,
  timeBlocks: (json['timeBlocks'] as List<dynamic>)
      .map((e) => TimeBlock.fromJson(e as Map<String, dynamic>))
      .toList(),
  explanation: json['explanation'] == null
      ? null
      : RoutineExplanation.fromJson(
          json['explanation'] as Map<String, dynamic>,
        ),
  confidenceScore: (json['confidenceScore'] as num?)?.toDouble(),
  isAccepted: json['isAccepted'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$RoutineToJson(_Routine instance) => <String, dynamic>{
  'id': instance.id,
  'date': instance.date.toIso8601String(),
  'title': instance.title,
  'timeBlocks': instance.timeBlocks,
  'explanation': instance.explanation,
  'confidenceScore': instance.confidenceScore,
  'isAccepted': instance.isAccepted,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
