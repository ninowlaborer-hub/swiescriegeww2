// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather_forecast.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WeatherForecast {

 String get uuid; WeatherSource get source; double get latitude; double get longitude; DateTime get forecastDate; List<WeatherCondition> get hourlyConditions; DateTime get fetchedAt; DateTime get expiresAt; String? get locationName; String? get rawJson;
/// Create a copy of WeatherForecast
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeatherForecastCopyWith<WeatherForecast> get copyWith => _$WeatherForecastCopyWithImpl<WeatherForecast>(this as WeatherForecast, _$identity);

  /// Serializes this WeatherForecast to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeatherForecast&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.source, source) || other.source == source)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.forecastDate, forecastDate) || other.forecastDate == forecastDate)&&const DeepCollectionEquality().equals(other.hourlyConditions, hourlyConditions)&&(identical(other.fetchedAt, fetchedAt) || other.fetchedAt == fetchedAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.locationName, locationName) || other.locationName == locationName)&&(identical(other.rawJson, rawJson) || other.rawJson == rawJson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,source,latitude,longitude,forecastDate,const DeepCollectionEquality().hash(hourlyConditions),fetchedAt,expiresAt,locationName,rawJson);

@override
String toString() {
  return 'WeatherForecast(uuid: $uuid, source: $source, latitude: $latitude, longitude: $longitude, forecastDate: $forecastDate, hourlyConditions: $hourlyConditions, fetchedAt: $fetchedAt, expiresAt: $expiresAt, locationName: $locationName, rawJson: $rawJson)';
}


}

/// @nodoc
abstract mixin class $WeatherForecastCopyWith<$Res>  {
  factory $WeatherForecastCopyWith(WeatherForecast value, $Res Function(WeatherForecast) _then) = _$WeatherForecastCopyWithImpl;
@useResult
$Res call({
 String uuid, WeatherSource source, double latitude, double longitude, DateTime forecastDate, List<WeatherCondition> hourlyConditions, DateTime fetchedAt, DateTime expiresAt, String? locationName, String? rawJson
});




}
/// @nodoc
class _$WeatherForecastCopyWithImpl<$Res>
    implements $WeatherForecastCopyWith<$Res> {
  _$WeatherForecastCopyWithImpl(this._self, this._then);

  final WeatherForecast _self;
  final $Res Function(WeatherForecast) _then;

/// Create a copy of WeatherForecast
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uuid = null,Object? source = null,Object? latitude = null,Object? longitude = null,Object? forecastDate = null,Object? hourlyConditions = null,Object? fetchedAt = null,Object? expiresAt = null,Object? locationName = freezed,Object? rawJson = freezed,}) {
  return _then(_self.copyWith(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as WeatherSource,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,forecastDate: null == forecastDate ? _self.forecastDate : forecastDate // ignore: cast_nullable_to_non_nullable
as DateTime,hourlyConditions: null == hourlyConditions ? _self.hourlyConditions : hourlyConditions // ignore: cast_nullable_to_non_nullable
as List<WeatherCondition>,fetchedAt: null == fetchedAt ? _self.fetchedAt : fetchedAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,locationName: freezed == locationName ? _self.locationName : locationName // ignore: cast_nullable_to_non_nullable
as String?,rawJson: freezed == rawJson ? _self.rawJson : rawJson // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WeatherForecast].
extension WeatherForecastPatterns on WeatherForecast {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeatherForecast value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeatherForecast() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeatherForecast value)  $default,){
final _that = this;
switch (_that) {
case _WeatherForecast():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeatherForecast value)?  $default,){
final _that = this;
switch (_that) {
case _WeatherForecast() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uuid,  WeatherSource source,  double latitude,  double longitude,  DateTime forecastDate,  List<WeatherCondition> hourlyConditions,  DateTime fetchedAt,  DateTime expiresAt,  String? locationName,  String? rawJson)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeatherForecast() when $default != null:
return $default(_that.uuid,_that.source,_that.latitude,_that.longitude,_that.forecastDate,_that.hourlyConditions,_that.fetchedAt,_that.expiresAt,_that.locationName,_that.rawJson);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uuid,  WeatherSource source,  double latitude,  double longitude,  DateTime forecastDate,  List<WeatherCondition> hourlyConditions,  DateTime fetchedAt,  DateTime expiresAt,  String? locationName,  String? rawJson)  $default,) {final _that = this;
switch (_that) {
case _WeatherForecast():
return $default(_that.uuid,_that.source,_that.latitude,_that.longitude,_that.forecastDate,_that.hourlyConditions,_that.fetchedAt,_that.expiresAt,_that.locationName,_that.rawJson);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uuid,  WeatherSource source,  double latitude,  double longitude,  DateTime forecastDate,  List<WeatherCondition> hourlyConditions,  DateTime fetchedAt,  DateTime expiresAt,  String? locationName,  String? rawJson)?  $default,) {final _that = this;
switch (_that) {
case _WeatherForecast() when $default != null:
return $default(_that.uuid,_that.source,_that.latitude,_that.longitude,_that.forecastDate,_that.hourlyConditions,_that.fetchedAt,_that.expiresAt,_that.locationName,_that.rawJson);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeatherForecast extends WeatherForecast {
  const _WeatherForecast({required this.uuid, required this.source, required this.latitude, required this.longitude, required this.forecastDate, required final  List<WeatherCondition> hourlyConditions, required this.fetchedAt, required this.expiresAt, this.locationName, this.rawJson}): _hourlyConditions = hourlyConditions,super._();
  factory _WeatherForecast.fromJson(Map<String, dynamic> json) => _$WeatherForecastFromJson(json);

@override final  String uuid;
@override final  WeatherSource source;
@override final  double latitude;
@override final  double longitude;
@override final  DateTime forecastDate;
 final  List<WeatherCondition> _hourlyConditions;
@override List<WeatherCondition> get hourlyConditions {
  if (_hourlyConditions is EqualUnmodifiableListView) return _hourlyConditions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hourlyConditions);
}

@override final  DateTime fetchedAt;
@override final  DateTime expiresAt;
@override final  String? locationName;
@override final  String? rawJson;

/// Create a copy of WeatherForecast
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeatherForecastCopyWith<_WeatherForecast> get copyWith => __$WeatherForecastCopyWithImpl<_WeatherForecast>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeatherForecastToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeatherForecast&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.source, source) || other.source == source)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.forecastDate, forecastDate) || other.forecastDate == forecastDate)&&const DeepCollectionEquality().equals(other._hourlyConditions, _hourlyConditions)&&(identical(other.fetchedAt, fetchedAt) || other.fetchedAt == fetchedAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.locationName, locationName) || other.locationName == locationName)&&(identical(other.rawJson, rawJson) || other.rawJson == rawJson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,source,latitude,longitude,forecastDate,const DeepCollectionEquality().hash(_hourlyConditions),fetchedAt,expiresAt,locationName,rawJson);

@override
String toString() {
  return 'WeatherForecast(uuid: $uuid, source: $source, latitude: $latitude, longitude: $longitude, forecastDate: $forecastDate, hourlyConditions: $hourlyConditions, fetchedAt: $fetchedAt, expiresAt: $expiresAt, locationName: $locationName, rawJson: $rawJson)';
}


}

/// @nodoc
abstract mixin class _$WeatherForecastCopyWith<$Res> implements $WeatherForecastCopyWith<$Res> {
  factory _$WeatherForecastCopyWith(_WeatherForecast value, $Res Function(_WeatherForecast) _then) = __$WeatherForecastCopyWithImpl;
@override @useResult
$Res call({
 String uuid, WeatherSource source, double latitude, double longitude, DateTime forecastDate, List<WeatherCondition> hourlyConditions, DateTime fetchedAt, DateTime expiresAt, String? locationName, String? rawJson
});




}
/// @nodoc
class __$WeatherForecastCopyWithImpl<$Res>
    implements _$WeatherForecastCopyWith<$Res> {
  __$WeatherForecastCopyWithImpl(this._self, this._then);

  final _WeatherForecast _self;
  final $Res Function(_WeatherForecast) _then;

/// Create a copy of WeatherForecast
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uuid = null,Object? source = null,Object? latitude = null,Object? longitude = null,Object? forecastDate = null,Object? hourlyConditions = null,Object? fetchedAt = null,Object? expiresAt = null,Object? locationName = freezed,Object? rawJson = freezed,}) {
  return _then(_WeatherForecast(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as WeatherSource,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,forecastDate: null == forecastDate ? _self.forecastDate : forecastDate // ignore: cast_nullable_to_non_nullable
as DateTime,hourlyConditions: null == hourlyConditions ? _self._hourlyConditions : hourlyConditions // ignore: cast_nullable_to_non_nullable
as List<WeatherCondition>,fetchedAt: null == fetchedAt ? _self.fetchedAt : fetchedAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,locationName: freezed == locationName ? _self.locationName : locationName // ignore: cast_nullable_to_non_nullable
as String?,rawJson: freezed == rawJson ? _self.rawJson : rawJson // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
