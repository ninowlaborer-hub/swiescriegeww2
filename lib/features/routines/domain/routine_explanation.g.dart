// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine_explanation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoutineExplanation _$RoutineExplanationFromJson(Map<String, dynamic> json) =>
    _RoutineExplanation(
      summary: json['summary'] as String,
      factors: (json['factors'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      dataSourcesUsed: json['dataSourcesUsed'] as Map<String, dynamic>?,
      recommendations: (json['recommendations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      generatedAt: json['generatedAt'] == null
          ? null
          : DateTime.parse(json['generatedAt'] as String),
    );

Map<String, dynamic> _$RoutineExplanationToJson(_RoutineExplanation instance) =>
    <String, dynamic>{
      'summary': instance.summary,
      'factors': instance.factors,
      'dataSourcesUsed': instance.dataSourcesUsed,
      'recommendations': instance.recommendations,
      'generatedAt': instance.generatedAt?.toIso8601String(),
    };
