// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_forecast.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeatherForecast _$WeatherForecastFromJson(Map<String, dynamic> json) =>
    _WeatherForecast(
      uuid: json['uuid'] as String,
      source: $enumDecode(_$WeatherSourceEnumMap, json['source']),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      forecastDate: DateTime.parse(json['forecastDate'] as String),
      hourlyConditions: (json['hourlyConditions'] as List<dynamic>)
          .map((e) => WeatherCondition.fromJson(e as Map<String, dynamic>))
          .toList(),
      fetchedAt: DateTime.parse(json['fetchedAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      locationName: json['locationName'] as String?,
      rawJson: json['rawJson'] as String?,
    );

Map<String, dynamic> _$WeatherForecastToJson(_WeatherForecast instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'source': _$WeatherSourceEnumMap[instance.source]!,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'forecastDate': instance.forecastDate.toIso8601String(),
      'hourlyConditions': instance.hourlyConditions,
      'fetchedAt': instance.fetchedAt.toIso8601String(),
      'expiresAt': instance.expiresAt.toIso8601String(),
      'locationName': instance.locationName,
      'rawJson': instance.rawJson,
    };

const _$WeatherSourceEnumMap = {
  WeatherSource.openWeatherMap: 'openWeatherMap',
  WeatherSource.weatherGov: 'weatherGov',
};
