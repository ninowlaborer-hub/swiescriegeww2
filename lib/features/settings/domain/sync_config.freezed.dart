// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SyncConfig {

/// Whether automatic sync is enabled
 bool get autoSyncEnabled;/// Cloud provider (icloud, google_drive, or manual_only)
 CloudProvider get cloudProvider;/// Sync frequency in hours (only applies if auto-sync is enabled)
 int get syncFrequencyHours;/// Last successful sync timestamp
 DateTime? get lastSyncTime;/// Last sync error (if any)
 String? get lastSyncError;/// Whether to include cache data in sync
 bool get includeCacheInSync;/// Cloud storage file path (provider-specific)
 String? get cloudFilePath;
/// Create a copy of SyncConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncConfigCopyWith<SyncConfig> get copyWith => _$SyncConfigCopyWithImpl<SyncConfig>(this as SyncConfig, _$identity);

  /// Serializes this SyncConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncConfig&&(identical(other.autoSyncEnabled, autoSyncEnabled) || other.autoSyncEnabled == autoSyncEnabled)&&(identical(other.cloudProvider, cloudProvider) || other.cloudProvider == cloudProvider)&&(identical(other.syncFrequencyHours, syncFrequencyHours) || other.syncFrequencyHours == syncFrequencyHours)&&(identical(other.lastSyncTime, lastSyncTime) || other.lastSyncTime == lastSyncTime)&&(identical(other.lastSyncError, lastSyncError) || other.lastSyncError == lastSyncError)&&(identical(other.includeCacheInSync, includeCacheInSync) || other.includeCacheInSync == includeCacheInSync)&&(identical(other.cloudFilePath, cloudFilePath) || other.cloudFilePath == cloudFilePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,autoSyncEnabled,cloudProvider,syncFrequencyHours,lastSyncTime,lastSyncError,includeCacheInSync,cloudFilePath);

@override
String toString() {
  return 'SyncConfig(autoSyncEnabled: $autoSyncEnabled, cloudProvider: $cloudProvider, syncFrequencyHours: $syncFrequencyHours, lastSyncTime: $lastSyncTime, lastSyncError: $lastSyncError, includeCacheInSync: $includeCacheInSync, cloudFilePath: $cloudFilePath)';
}


}

/// @nodoc
abstract mixin class $SyncConfigCopyWith<$Res>  {
  factory $SyncConfigCopyWith(SyncConfig value, $Res Function(SyncConfig) _then) = _$SyncConfigCopyWithImpl;
@useResult
$Res call({
 bool autoSyncEnabled, CloudProvider cloudProvider, int syncFrequencyHours, DateTime? lastSyncTime, String? lastSyncError, bool includeCacheInSync, String? cloudFilePath
});




}
/// @nodoc
class _$SyncConfigCopyWithImpl<$Res>
    implements $SyncConfigCopyWith<$Res> {
  _$SyncConfigCopyWithImpl(this._self, this._then);

  final SyncConfig _self;
  final $Res Function(SyncConfig) _then;

/// Create a copy of SyncConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? autoSyncEnabled = null,Object? cloudProvider = null,Object? syncFrequencyHours = null,Object? lastSyncTime = freezed,Object? lastSyncError = freezed,Object? includeCacheInSync = null,Object? cloudFilePath = freezed,}) {
  return _then(_self.copyWith(
autoSyncEnabled: null == autoSyncEnabled ? _self.autoSyncEnabled : autoSyncEnabled // ignore: cast_nullable_to_non_nullable
as bool,cloudProvider: null == cloudProvider ? _self.cloudProvider : cloudProvider // ignore: cast_nullable_to_non_nullable
as CloudProvider,syncFrequencyHours: null == syncFrequencyHours ? _self.syncFrequencyHours : syncFrequencyHours // ignore: cast_nullable_to_non_nullable
as int,lastSyncTime: freezed == lastSyncTime ? _self.lastSyncTime : lastSyncTime // ignore: cast_nullable_to_non_nullable
as DateTime?,lastSyncError: freezed == lastSyncError ? _self.lastSyncError : lastSyncError // ignore: cast_nullable_to_non_nullable
as String?,includeCacheInSync: null == includeCacheInSync ? _self.includeCacheInSync : includeCacheInSync // ignore: cast_nullable_to_non_nullable
as bool,cloudFilePath: freezed == cloudFilePath ? _self.cloudFilePath : cloudFilePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncConfig].
extension SyncConfigPatterns on SyncConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncConfig value)  $default,){
final _that = this;
switch (_that) {
case _SyncConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncConfig value)?  $default,){
final _that = this;
switch (_that) {
case _SyncConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool autoSyncEnabled,  CloudProvider cloudProvider,  int syncFrequencyHours,  DateTime? lastSyncTime,  String? lastSyncError,  bool includeCacheInSync,  String? cloudFilePath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncConfig() when $default != null:
return $default(_that.autoSyncEnabled,_that.cloudProvider,_that.syncFrequencyHours,_that.lastSyncTime,_that.lastSyncError,_that.includeCacheInSync,_that.cloudFilePath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool autoSyncEnabled,  CloudProvider cloudProvider,  int syncFrequencyHours,  DateTime? lastSyncTime,  String? lastSyncError,  bool includeCacheInSync,  String? cloudFilePath)  $default,) {final _that = this;
switch (_that) {
case _SyncConfig():
return $default(_that.autoSyncEnabled,_that.cloudProvider,_that.syncFrequencyHours,_that.lastSyncTime,_that.lastSyncError,_that.includeCacheInSync,_that.cloudFilePath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool autoSyncEnabled,  CloudProvider cloudProvider,  int syncFrequencyHours,  DateTime? lastSyncTime,  String? lastSyncError,  bool includeCacheInSync,  String? cloudFilePath)?  $default,) {final _that = this;
switch (_that) {
case _SyncConfig() when $default != null:
return $default(_that.autoSyncEnabled,_that.cloudProvider,_that.syncFrequencyHours,_that.lastSyncTime,_that.lastSyncError,_that.includeCacheInSync,_that.cloudFilePath);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SyncConfig extends SyncConfig {
  const _SyncConfig({this.autoSyncEnabled = false, this.cloudProvider = CloudProvider.manualOnly, this.syncFrequencyHours = 24, this.lastSyncTime, this.lastSyncError, this.includeCacheInSync = false, this.cloudFilePath}): super._();
  factory _SyncConfig.fromJson(Map<String, dynamic> json) => _$SyncConfigFromJson(json);

/// Whether automatic sync is enabled
@override@JsonKey() final  bool autoSyncEnabled;
/// Cloud provider (icloud, google_drive, or manual_only)
@override@JsonKey() final  CloudProvider cloudProvider;
/// Sync frequency in hours (only applies if auto-sync is enabled)
@override@JsonKey() final  int syncFrequencyHours;
/// Last successful sync timestamp
@override final  DateTime? lastSyncTime;
/// Last sync error (if any)
@override final  String? lastSyncError;
/// Whether to include cache data in sync
@override@JsonKey() final  bool includeCacheInSync;
/// Cloud storage file path (provider-specific)
@override final  String? cloudFilePath;

/// Create a copy of SyncConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncConfigCopyWith<_SyncConfig> get copyWith => __$SyncConfigCopyWithImpl<_SyncConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncConfig&&(identical(other.autoSyncEnabled, autoSyncEnabled) || other.autoSyncEnabled == autoSyncEnabled)&&(identical(other.cloudProvider, cloudProvider) || other.cloudProvider == cloudProvider)&&(identical(other.syncFrequencyHours, syncFrequencyHours) || other.syncFrequencyHours == syncFrequencyHours)&&(identical(other.lastSyncTime, lastSyncTime) || other.lastSyncTime == lastSyncTime)&&(identical(other.lastSyncError, lastSyncError) || other.lastSyncError == lastSyncError)&&(identical(other.includeCacheInSync, includeCacheInSync) || other.includeCacheInSync == includeCacheInSync)&&(identical(other.cloudFilePath, cloudFilePath) || other.cloudFilePath == cloudFilePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,autoSyncEnabled,cloudProvider,syncFrequencyHours,lastSyncTime,lastSyncError,includeCacheInSync,cloudFilePath);

@override
String toString() {
  return 'SyncConfig(autoSyncEnabled: $autoSyncEnabled, cloudProvider: $cloudProvider, syncFrequencyHours: $syncFrequencyHours, lastSyncTime: $lastSyncTime, lastSyncError: $lastSyncError, includeCacheInSync: $includeCacheInSync, cloudFilePath: $cloudFilePath)';
}


}

/// @nodoc
abstract mixin class _$SyncConfigCopyWith<$Res> implements $SyncConfigCopyWith<$Res> {
  factory _$SyncConfigCopyWith(_SyncConfig value, $Res Function(_SyncConfig) _then) = __$SyncConfigCopyWithImpl;
@override @useResult
$Res call({
 bool autoSyncEnabled, CloudProvider cloudProvider, int syncFrequencyHours, DateTime? lastSyncTime, String? lastSyncError, bool includeCacheInSync, String? cloudFilePath
});




}
/// @nodoc
class __$SyncConfigCopyWithImpl<$Res>
    implements _$SyncConfigCopyWith<$Res> {
  __$SyncConfigCopyWithImpl(this._self, this._then);

  final _SyncConfig _self;
  final $Res Function(_SyncConfig) _then;

/// Create a copy of SyncConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? autoSyncEnabled = null,Object? cloudProvider = null,Object? syncFrequencyHours = null,Object? lastSyncTime = freezed,Object? lastSyncError = freezed,Object? includeCacheInSync = null,Object? cloudFilePath = freezed,}) {
  return _then(_SyncConfig(
autoSyncEnabled: null == autoSyncEnabled ? _self.autoSyncEnabled : autoSyncEnabled // ignore: cast_nullable_to_non_nullable
as bool,cloudProvider: null == cloudProvider ? _self.cloudProvider : cloudProvider // ignore: cast_nullable_to_non_nullable
as CloudProvider,syncFrequencyHours: null == syncFrequencyHours ? _self.syncFrequencyHours : syncFrequencyHours // ignore: cast_nullable_to_non_nullable
as int,lastSyncTime: freezed == lastSyncTime ? _self.lastSyncTime : lastSyncTime // ignore: cast_nullable_to_non_nullable
as DateTime?,lastSyncError: freezed == lastSyncError ? _self.lastSyncError : lastSyncError // ignore: cast_nullable_to_non_nullable
as String?,includeCacheInSync: null == includeCacheInSync ? _self.includeCacheInSync : includeCacheInSync // ignore: cast_nullable_to_non_nullable
as bool,cloudFilePath: freezed == cloudFilePath ? _self.cloudFilePath : cloudFilePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
