// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'export_bundle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DataExportBundle {

 String get version;// Schema version for compatibility
 DateTime get exportedAt; String get deviceId;// Anonymous device identifier
 ExportData get data; String? get encryptionKeyHash;
/// Create a copy of DataExportBundle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DataExportBundleCopyWith<DataExportBundle> get copyWith => _$DataExportBundleCopyWithImpl<DataExportBundle>(this as DataExportBundle, _$identity);

  /// Serializes this DataExportBundle to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DataExportBundle&&(identical(other.version, version) || other.version == version)&&(identical(other.exportedAt, exportedAt) || other.exportedAt == exportedAt)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.data, data) || other.data == data)&&(identical(other.encryptionKeyHash, encryptionKeyHash) || other.encryptionKeyHash == encryptionKeyHash));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,exportedAt,deviceId,data,encryptionKeyHash);

@override
String toString() {
  return 'DataExportBundle(version: $version, exportedAt: $exportedAt, deviceId: $deviceId, data: $data, encryptionKeyHash: $encryptionKeyHash)';
}


}

/// @nodoc
abstract mixin class $DataExportBundleCopyWith<$Res>  {
  factory $DataExportBundleCopyWith(DataExportBundle value, $Res Function(DataExportBundle) _then) = _$DataExportBundleCopyWithImpl;
@useResult
$Res call({
 String version, DateTime exportedAt, String deviceId, ExportData data, String? encryptionKeyHash
});


$ExportDataCopyWith<$Res> get data;

}
/// @nodoc
class _$DataExportBundleCopyWithImpl<$Res>
    implements $DataExportBundleCopyWith<$Res> {
  _$DataExportBundleCopyWithImpl(this._self, this._then);

  final DataExportBundle _self;
  final $Res Function(DataExportBundle) _then;

/// Create a copy of DataExportBundle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? exportedAt = null,Object? deviceId = null,Object? data = null,Object? encryptionKeyHash = freezed,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,exportedAt: null == exportedAt ? _self.exportedAt : exportedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ExportData,encryptionKeyHash: freezed == encryptionKeyHash ? _self.encryptionKeyHash : encryptionKeyHash // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of DataExportBundle
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExportDataCopyWith<$Res> get data {
  
  return $ExportDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [DataExportBundle].
extension DataExportBundlePatterns on DataExportBundle {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DataExportBundle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DataExportBundle() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DataExportBundle value)  $default,){
final _that = this;
switch (_that) {
case _DataExportBundle():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DataExportBundle value)?  $default,){
final _that = this;
switch (_that) {
case _DataExportBundle() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String version,  DateTime exportedAt,  String deviceId,  ExportData data,  String? encryptionKeyHash)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DataExportBundle() when $default != null:
return $default(_that.version,_that.exportedAt,_that.deviceId,_that.data,_that.encryptionKeyHash);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String version,  DateTime exportedAt,  String deviceId,  ExportData data,  String? encryptionKeyHash)  $default,) {final _that = this;
switch (_that) {
case _DataExportBundle():
return $default(_that.version,_that.exportedAt,_that.deviceId,_that.data,_that.encryptionKeyHash);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String version,  DateTime exportedAt,  String deviceId,  ExportData data,  String? encryptionKeyHash)?  $default,) {final _that = this;
switch (_that) {
case _DataExportBundle() when $default != null:
return $default(_that.version,_that.exportedAt,_that.deviceId,_that.data,_that.encryptionKeyHash);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DataExportBundle implements DataExportBundle {
  const _DataExportBundle({required this.version, required this.exportedAt, required this.deviceId, required this.data, this.encryptionKeyHash});
  factory _DataExportBundle.fromJson(Map<String, dynamic> json) => _$DataExportBundleFromJson(json);

@override final  String version;
// Schema version for compatibility
@override final  DateTime exportedAt;
@override final  String deviceId;
// Anonymous device identifier
@override final  ExportData data;
@override final  String? encryptionKeyHash;

/// Create a copy of DataExportBundle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DataExportBundleCopyWith<_DataExportBundle> get copyWith => __$DataExportBundleCopyWithImpl<_DataExportBundle>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DataExportBundleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DataExportBundle&&(identical(other.version, version) || other.version == version)&&(identical(other.exportedAt, exportedAt) || other.exportedAt == exportedAt)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.data, data) || other.data == data)&&(identical(other.encryptionKeyHash, encryptionKeyHash) || other.encryptionKeyHash == encryptionKeyHash));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,exportedAt,deviceId,data,encryptionKeyHash);

@override
String toString() {
  return 'DataExportBundle(version: $version, exportedAt: $exportedAt, deviceId: $deviceId, data: $data, encryptionKeyHash: $encryptionKeyHash)';
}


}

/// @nodoc
abstract mixin class _$DataExportBundleCopyWith<$Res> implements $DataExportBundleCopyWith<$Res> {
  factory _$DataExportBundleCopyWith(_DataExportBundle value, $Res Function(_DataExportBundle) _then) = __$DataExportBundleCopyWithImpl;
@override @useResult
$Res call({
 String version, DateTime exportedAt, String deviceId, ExportData data, String? encryptionKeyHash
});


@override $ExportDataCopyWith<$Res> get data;

}
/// @nodoc
class __$DataExportBundleCopyWithImpl<$Res>
    implements _$DataExportBundleCopyWith<$Res> {
  __$DataExportBundleCopyWithImpl(this._self, this._then);

  final _DataExportBundle _self;
  final $Res Function(_DataExportBundle) _then;

/// Create a copy of DataExportBundle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? exportedAt = null,Object? deviceId = null,Object? data = null,Object? encryptionKeyHash = freezed,}) {
  return _then(_DataExportBundle(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,exportedAt: null == exportedAt ? _self.exportedAt : exportedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ExportData,encryptionKeyHash: freezed == encryptionKeyHash ? _self.encryptionKeyHash : encryptionKeyHash // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of DataExportBundle
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExportDataCopyWith<$Res> get data {
  
  return $ExportDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$ExportData {

 List<Map<String, dynamic>> get routines; List<Map<String, dynamic>> get timeBlocks; List<Map<String, dynamic>> get calendarCache; List<Map<String, dynamic>> get weatherCache; Map<String, dynamic> get preferences;
/// Create a copy of ExportData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExportDataCopyWith<ExportData> get copyWith => _$ExportDataCopyWithImpl<ExportData>(this as ExportData, _$identity);

  /// Serializes this ExportData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportData&&const DeepCollectionEquality().equals(other.routines, routines)&&const DeepCollectionEquality().equals(other.timeBlocks, timeBlocks)&&const DeepCollectionEquality().equals(other.calendarCache, calendarCache)&&const DeepCollectionEquality().equals(other.weatherCache, weatherCache)&&const DeepCollectionEquality().equals(other.preferences, preferences));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(routines),const DeepCollectionEquality().hash(timeBlocks),const DeepCollectionEquality().hash(calendarCache),const DeepCollectionEquality().hash(weatherCache),const DeepCollectionEquality().hash(preferences));

@override
String toString() {
  return 'ExportData(routines: $routines, timeBlocks: $timeBlocks, calendarCache: $calendarCache, weatherCache: $weatherCache, preferences: $preferences)';
}


}

/// @nodoc
abstract mixin class $ExportDataCopyWith<$Res>  {
  factory $ExportDataCopyWith(ExportData value, $Res Function(ExportData) _then) = _$ExportDataCopyWithImpl;
@useResult
$Res call({
 List<Map<String, dynamic>> routines, List<Map<String, dynamic>> timeBlocks, List<Map<String, dynamic>> calendarCache, List<Map<String, dynamic>> weatherCache, Map<String, dynamic> preferences
});




}
/// @nodoc
class _$ExportDataCopyWithImpl<$Res>
    implements $ExportDataCopyWith<$Res> {
  _$ExportDataCopyWithImpl(this._self, this._then);

  final ExportData _self;
  final $Res Function(ExportData) _then;

/// Create a copy of ExportData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? routines = null,Object? timeBlocks = null,Object? calendarCache = null,Object? weatherCache = null,Object? preferences = null,}) {
  return _then(_self.copyWith(
routines: null == routines ? _self.routines : routines // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,timeBlocks: null == timeBlocks ? _self.timeBlocks : timeBlocks // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,calendarCache: null == calendarCache ? _self.calendarCache : calendarCache // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,weatherCache: null == weatherCache ? _self.weatherCache : weatherCache // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,preferences: null == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [ExportData].
extension ExportDataPatterns on ExportData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExportData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExportData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExportData value)  $default,){
final _that = this;
switch (_that) {
case _ExportData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExportData value)?  $default,){
final _that = this;
switch (_that) {
case _ExportData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Map<String, dynamic>> routines,  List<Map<String, dynamic>> timeBlocks,  List<Map<String, dynamic>> calendarCache,  List<Map<String, dynamic>> weatherCache,  Map<String, dynamic> preferences)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExportData() when $default != null:
return $default(_that.routines,_that.timeBlocks,_that.calendarCache,_that.weatherCache,_that.preferences);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Map<String, dynamic>> routines,  List<Map<String, dynamic>> timeBlocks,  List<Map<String, dynamic>> calendarCache,  List<Map<String, dynamic>> weatherCache,  Map<String, dynamic> preferences)  $default,) {final _that = this;
switch (_that) {
case _ExportData():
return $default(_that.routines,_that.timeBlocks,_that.calendarCache,_that.weatherCache,_that.preferences);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Map<String, dynamic>> routines,  List<Map<String, dynamic>> timeBlocks,  List<Map<String, dynamic>> calendarCache,  List<Map<String, dynamic>> weatherCache,  Map<String, dynamic> preferences)?  $default,) {final _that = this;
switch (_that) {
case _ExportData() when $default != null:
return $default(_that.routines,_that.timeBlocks,_that.calendarCache,_that.weatherCache,_that.preferences);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExportData implements ExportData {
  const _ExportData({required final  List<Map<String, dynamic>> routines, required final  List<Map<String, dynamic>> timeBlocks, required final  List<Map<String, dynamic>> calendarCache, required final  List<Map<String, dynamic>> weatherCache, required final  Map<String, dynamic> preferences}): _routines = routines,_timeBlocks = timeBlocks,_calendarCache = calendarCache,_weatherCache = weatherCache,_preferences = preferences;
  factory _ExportData.fromJson(Map<String, dynamic> json) => _$ExportDataFromJson(json);

 final  List<Map<String, dynamic>> _routines;
@override List<Map<String, dynamic>> get routines {
  if (_routines is EqualUnmodifiableListView) return _routines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_routines);
}

 final  List<Map<String, dynamic>> _timeBlocks;
@override List<Map<String, dynamic>> get timeBlocks {
  if (_timeBlocks is EqualUnmodifiableListView) return _timeBlocks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_timeBlocks);
}

 final  List<Map<String, dynamic>> _calendarCache;
@override List<Map<String, dynamic>> get calendarCache {
  if (_calendarCache is EqualUnmodifiableListView) return _calendarCache;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_calendarCache);
}

 final  List<Map<String, dynamic>> _weatherCache;
@override List<Map<String, dynamic>> get weatherCache {
  if (_weatherCache is EqualUnmodifiableListView) return _weatherCache;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weatherCache);
}

 final  Map<String, dynamic> _preferences;
@override Map<String, dynamic> get preferences {
  if (_preferences is EqualUnmodifiableMapView) return _preferences;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_preferences);
}


/// Create a copy of ExportData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExportDataCopyWith<_ExportData> get copyWith => __$ExportDataCopyWithImpl<_ExportData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExportDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExportData&&const DeepCollectionEquality().equals(other._routines, _routines)&&const DeepCollectionEquality().equals(other._timeBlocks, _timeBlocks)&&const DeepCollectionEquality().equals(other._calendarCache, _calendarCache)&&const DeepCollectionEquality().equals(other._weatherCache, _weatherCache)&&const DeepCollectionEquality().equals(other._preferences, _preferences));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_routines),const DeepCollectionEquality().hash(_timeBlocks),const DeepCollectionEquality().hash(_calendarCache),const DeepCollectionEquality().hash(_weatherCache),const DeepCollectionEquality().hash(_preferences));

@override
String toString() {
  return 'ExportData(routines: $routines, timeBlocks: $timeBlocks, calendarCache: $calendarCache, weatherCache: $weatherCache, preferences: $preferences)';
}


}

/// @nodoc
abstract mixin class _$ExportDataCopyWith<$Res> implements $ExportDataCopyWith<$Res> {
  factory _$ExportDataCopyWith(_ExportData value, $Res Function(_ExportData) _then) = __$ExportDataCopyWithImpl;
@override @useResult
$Res call({
 List<Map<String, dynamic>> routines, List<Map<String, dynamic>> timeBlocks, List<Map<String, dynamic>> calendarCache, List<Map<String, dynamic>> weatherCache, Map<String, dynamic> preferences
});




}
/// @nodoc
class __$ExportDataCopyWithImpl<$Res>
    implements _$ExportDataCopyWith<$Res> {
  __$ExportDataCopyWithImpl(this._self, this._then);

  final _ExportData _self;
  final $Res Function(_ExportData) _then;

/// Create a copy of ExportData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? routines = null,Object? timeBlocks = null,Object? calendarCache = null,Object? weatherCache = null,Object? preferences = null,}) {
  return _then(_ExportData(
routines: null == routines ? _self._routines : routines // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,timeBlocks: null == timeBlocks ? _self._timeBlocks : timeBlocks // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,calendarCache: null == calendarCache ? _self._calendarCache : calendarCache // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,weatherCache: null == weatherCache ? _self._weatherCache : weatherCache // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,preferences: null == preferences ? _self._preferences : preferences // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
