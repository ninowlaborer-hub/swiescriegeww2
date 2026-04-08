// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_condition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeatherCondition _$WeatherConditionFromJson(Map<String, dynamic> json) =>
    _WeatherCondition(
      uuid: json['uuid'] as String,
      forecastTime: DateTime.parse(json['forecastTime'] as String),
      condition: json['condition'] as String,
      temperatureCelsius: (json['temperatureCelsius'] as num).toDouble(),
      feelsLikeCelsius: (json['feelsLikeCelsius'] as num?)?.toDouble(),
      humidity: (json['humidity'] as num?)?.toInt(),
      windSpeedKmh: (json['windSpeedKmh'] as num?)?.toDouble(),
      windDirection: json['windDirection'] as String?,
      precipitationChance: (json['precipitationChance'] as num?)?.toInt(),
      precipitationMm: (json['precipitationMm'] as num?)?.toDouble(),
      uvIndex: (json['uvIndex'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WeatherConditionToJson(_WeatherCondition instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'forecastTime': instance.forecastTime.toIso8601String(),
      'condition': instance.condition,
      'temperatureCelsius': instance.temperatureCelsius,
      'feelsLikeCelsius': instance.feelsLikeCelsius,
      'humidity': instance.humidity,
      'windSpeedKmh': instance.windSpeedKmh,
      'windDirection': instance.windDirection,
      'precipitationChance': instance.precipitationChance,
      'precipitationMm': instance.precipitationMm,
      'uvIndex': instance.uvIndex,
    };
