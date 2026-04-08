// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather_condition.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WeatherCondition {

 String get uuid; DateTime get forecastTime; String get condition;// sunny, cloudy, rainy, snowy, etc.
 double get temperatureCelsius; double? get feelsLikeCelsius; int? get humidity;// 0-100%
 double? get windSpeedKmh; String? get windDirection;// N, NE, E, SE, S, SW, W, NW
 int? get precipitationChance;// 0-100%
 double? get precipitationMm; int? get uvIndex;
/// Create a copy of WeatherCondition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeatherConditionCopyWith<WeatherCondition> get copyWith => _$WeatherConditionCopyWithImpl<WeatherCondition>(this as WeatherCondition, _$identity);

  /// Serializes this WeatherCondition to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeatherCondition&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.forecastTime, forecastTime) || other.forecastTime == forecastTime)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.temperatureCelsius, temperatureCelsius) || other.temperatureCelsius == temperatureCelsius)&&(identical(other.feelsLikeCelsius, feelsLikeCelsius) || other.feelsLikeCelsius == feelsLikeCelsius)&&(identical(other.humidity, humidity) || other.humidity == humidity)&&(identical(other.windSpeedKmh, windSpeedKmh) || other.windSpeedKmh == windSpeedKmh)&&(identical(other.windDirection, windDirection) || other.windDirection == windDirection)&&(identical(other.precipitationChance, precipitationChance) || other.precipitationChance == precipitationChance)&&(identical(other.precipitationMm, precipitationMm) || other.precipitationMm == precipitationMm)&&(identical(other.uvIndex, uvIndex) || other.uvIndex == uvIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,forecastTime,condition,temperatureCelsius,feelsLikeCelsius,humidity,windSpeedKmh,windDirection,precipitationChance,precipitationMm,uvIndex);

@override
String toString() {
  return 'WeatherCondition(uuid: $uuid, forecastTime: $forecastTime, condition: $condition, temperatureCelsius: $temperatureCelsius, feelsLikeCelsius: $feelsLikeCelsius, humidity: $humidity, windSpeedKmh: $windSpeedKmh, windDirection: $windDirection, precipitationChance: $precipitationChance, precipitationMm: $precipitationMm, uvIndex: $uvIndex)';
}


}

/// @nodoc
abstract mixin class $WeatherConditionCopyWith<$Res>  {
  factory $WeatherConditionCopyWith(WeatherCondition value, $Res Function(WeatherCondition) _then) = _$WeatherConditionCopyWithImpl;
@useResult
$Res call({
 String uuid, DateTime forecastTime, String condition, double temperatureCelsius, double? feelsLikeCelsius, int? humidity, double? windSpeedKmh, String? windDirection, int? precipitationChance, double? precipitationMm, int? uvIndex
});




}
/// @nodoc
class _$WeatherConditionCopyWithImpl<$Res>
    implements $WeatherConditionCopyWith<$Res> {
  _$WeatherConditionCopyWithImpl(this._self, this._then);

  final WeatherCondition _self;
  final $Res Function(WeatherCondition) _then;

/// Create a copy of WeatherCondition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uuid = null,Object? forecastTime = null,Object? condition = null,Object? temperatureCelsius = null,Object? feelsLikeCelsius = freezed,Object? humidity = freezed,Object? windSpeedKmh = freezed,Object? windDirection = freezed,Object? precipitationChance = freezed,Object? precipitationMm = freezed,Object? uvIndex = freezed,}) {
  return _then(_self.copyWith(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,forecastTime: null == forecastTime ? _self.forecastTime : forecastTime // ignore: cast_nullable_to_non_nullable
as DateTime,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String,temperatureCelsius: null == temperatureCelsius ? _self.temperatureCelsius : temperatureCelsius // ignore: cast_nullable_to_non_nullable
as double,feelsLikeCelsius: freezed == feelsLikeCelsius ? _self.feelsLikeCelsius : feelsLikeCelsius // ignore: cast_nullable_to_non_nullable
as double?,humidity: freezed == humidity ? _self.humidity : humidity // ignore: cast_nullable_to_non_nullable
as int?,windSpeedKmh: freezed == windSpeedKmh ? _self.windSpeedKmh : windSpeedKmh // ignore: cast_nullable_to_non_nullable
as double?,windDirection: freezed == windDirection ? _self.windDirection : windDirection // ignore: cast_nullable_to_non_nullable
as String?,precipitationChance: freezed == precipitationChance ? _self.precipitationChance : precipitationChance // ignore: cast_nullable_to_non_nullable
as int?,precipitationMm: freezed == precipitationMm ? _self.precipitationMm : precipitationMm // ignore: cast_nullable_to_non_nullable
as double?,uvIndex: freezed == uvIndex ? _self.uvIndex : uvIndex // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [WeatherCondition].
extension WeatherConditionPatterns on WeatherCondition {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeatherCondition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeatherCondition() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeatherCondition value)  $default,){
final _that = this;
switch (_that) {
case _WeatherCondition():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeatherCondition value)?  $default,){
final _that = this;
switch (_that) {
case _WeatherCondition() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uuid,  DateTime forecastTime,  String condition,  double temperatureCelsius,  double? feelsLikeCelsius,  int? humidity,  double? windSpeedKmh,  String? windDirection,  int? precipitationChance,  double? precipitationMm,  int? uvIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeatherCondition() when $default != null:
return $default(_that.uuid,_that.forecastTime,_that.condition,_that.temperatureCelsius,_that.feelsLikeCelsius,_that.humidity,_that.windSpeedKmh,_that.windDirection,_that.precipitationChance,_that.precipitationMm,_that.uvIndex);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uuid,  DateTime forecastTime,  String condition,  double temperatureCelsius,  double? feelsLikeCelsius,  int? humidity,  double? windSpeedKmh,  String? windDirection,  int? precipitationChance,  double? precipitationMm,  int? uvIndex)  $default,) {final _that = this;
switch (_that) {
case _WeatherCondition():
return $default(_that.uuid,_that.forecastTime,_that.condition,_that.temperatureCelsius,_that.feelsLikeCelsius,_that.humidity,_that.windSpeedKmh,_that.windDirection,_that.precipitationChance,_that.precipitationMm,_that.uvIndex);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uuid,  DateTime forecastTime,  String condition,  double temperatureCelsius,  double? feelsLikeCelsius,  int? humidity,  double? windSpeedKmh,  String? windDirection,  int? precipitationChance,  double? precipitationMm,  int? uvIndex)?  $default,) {final _that = this;
switch (_that) {
case _WeatherCondition() when $default != null:
return $default(_that.uuid,_that.forecastTime,_that.condition,_that.temperatureCelsius,_that.feelsLikeCelsius,_that.humidity,_that.windSpeedKmh,_that.windDirection,_that.precipitationChance,_that.precipitationMm,_that.uvIndex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeatherCondition implements WeatherCondition {
  const _WeatherCondition({required this.uuid, required this.forecastTime, required this.condition, required this.temperatureCelsius, this.feelsLikeCelsius, this.humidity, this.windSpeedKmh, this.windDirection, this.precipitationChance, this.precipitationMm, this.uvIndex});
  factory _WeatherCondition.fromJson(Map<String, dynamic> json) => _$WeatherConditionFromJson(json);

@override final  String uuid;
@override final  DateTime forecastTime;
@override final  String condition;
// sunny, cloudy, rainy, snowy, etc.
@override final  double temperatureCelsius;
@override final  double? feelsLikeCelsius;
@override final  int? humidity;
// 0-100%
@override final  double? windSpeedKmh;
@override final  String? windDirection;
// N, NE, E, SE, S, SW, W, NW
@override final  int? precipitationChance;
// 0-100%
@override final  double? precipitationMm;
@override final  int? uvIndex;

/// Create a copy of WeatherCondition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeatherConditionCopyWith<_WeatherCondition> get copyWith => __$WeatherConditionCopyWithImpl<_WeatherCondition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeatherConditionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeatherCondition&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.forecastTime, forecastTime) || other.forecastTime == forecastTime)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.temperatureCelsius, temperatureCelsius) || other.temperatureCelsius == temperatureCelsius)&&(identical(other.feelsLikeCelsius, feelsLikeCelsius) || other.feelsLikeCelsius == feelsLikeCelsius)&&(identical(other.humidity, humidity) || other.humidity == humidity)&&(identical(other.windSpeedKmh, windSpeedKmh) || other.windSpeedKmh == windSpeedKmh)&&(identical(other.windDirection, windDirection) || other.windDirection == windDirection)&&(identical(other.precipitationChance, precipitationChance) || other.precipitationChance == precipitationChance)&&(identical(other.precipitationMm, precipitationMm) || other.precipitationMm == precipitationMm)&&(identical(other.uvIndex, uvIndex) || other.uvIndex == uvIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,forecastTime,condition,temperatureCelsius,feelsLikeCelsius,humidity,windSpeedKmh,windDirection,precipitationChance,precipitationMm,uvIndex);

@override
String toString() {
  return 'WeatherCondition(uuid: $uuid, forecastTime: $forecastTime, condition: $condition, temperatureCelsius: $temperatureCelsius, feelsLikeCelsius: $feelsLikeCelsius, humidity: $humidity, windSpeedKmh: $windSpeedKmh, windDirection: $windDirection, precipitationChance: $precipitationChance, precipitationMm: $precipitationMm, uvIndex: $uvIndex)';
}


}

/// @nodoc
abstract mixin class _$WeatherConditionCopyWith<$Res> implements $WeatherConditionCopyWith<$Res> {
  factory _$WeatherConditionCopyWith(_WeatherCondition value, $Res Function(_WeatherCondition) _then) = __$WeatherConditionCopyWithImpl;
@override @useResult
$Res call({
 String uuid, DateTime forecastTime, String condition, double temperatureCelsius, double? feelsLikeCelsius, int? humidity, double? windSpeedKmh, String? windDirection, int? precipitationChance, double? precipitationMm, int? uvIndex
});




}
/// @nodoc
class __$WeatherConditionCopyWithImpl<$Res>
    implements _$WeatherConditionCopyWith<$Res> {
  __$WeatherConditionCopyWithImpl(this._self, this._then);

  final _WeatherCondition _self;
  final $Res Function(_WeatherCondition) _then;

/// Create a copy of WeatherCondition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uuid = null,Object? forecastTime = null,Object? condition = null,Object? temperatureCelsius = null,Object? feelsLikeCelsius = freezed,Object? humidity = freezed,Object? windSpeedKmh = freezed,Object? windDirection = freezed,Object? precipitationChance = freezed,Object? precipitationMm = freezed,Object? uvIndex = freezed,}) {
  return _then(_WeatherCondition(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,forecastTime: null == forecastTime ? _self.forecastTime : forecastTime // ignore: cast_nullable_to_non_nullable
as DateTime,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String,temperatureCelsius: null == temperatureCelsius ? _self.temperatureCelsius : temperatureCelsius // ignore: cast_nullable_to_non_nullable
as double,feelsLikeCelsius: freezed == feelsLikeCelsius ? _self.feelsLikeCelsius : feelsLikeCelsius // ignore: cast_nullable_to_non_nullable
as double?,humidity: freezed == humidity ? _self.humidity : humidity // ignore: cast_nullable_to_non_nullable
as int?,windSpeedKmh: freezed == windSpeedKmh ? _self.windSpeedKmh : windSpeedKmh // ignore: cast_nullable_to_non_nullable
as double?,windDirection: freezed == windDirection ? _self.windDirection : windDirection // ignore: cast_nullable_to_non_nullable
as String?,precipitationChance: freezed == precipitationChance ? _self.precipitationChance : precipitationChance // ignore: cast_nullable_to_non_nullable
as int?,precipitationMm: freezed == precipitationMm ? _self.precipitationMm : precipitationMm // ignore: cast_nullable_to_non_nullable
as double?,uvIndex: freezed == uvIndex ? _self.uvIndex : uvIndex // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
