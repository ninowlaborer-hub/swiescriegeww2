// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calendar_source.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CalendarSource {

 String get id; String get name; int get color; bool get isSelected; bool get isPrimary; bool get isReadOnly; DateTime get createdAt; DateTime get updatedAt; String? get accountName; String? get accountType; CalendarSourceType? get sourceType; Map<String, dynamic>? get metadata;
/// Create a copy of CalendarSource
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalendarSourceCopyWith<CalendarSource> get copyWith => _$CalendarSourceCopyWithImpl<CalendarSource>(this as CalendarSource, _$identity);

  /// Serializes this CalendarSource to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalendarSource&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.color, color) || other.color == color)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary)&&(identical(other.isReadOnly, isReadOnly) || other.isReadOnly == isReadOnly)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.accountType, accountType) || other.accountType == accountType)&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,color,isSelected,isPrimary,isReadOnly,createdAt,updatedAt,accountName,accountType,sourceType,const DeepCollectionEquality().hash(metadata));

@override
String toString() {
  return 'CalendarSource(id: $id, name: $name, color: $color, isSelected: $isSelected, isPrimary: $isPrimary, isReadOnly: $isReadOnly, createdAt: $createdAt, updatedAt: $updatedAt, accountName: $accountName, accountType: $accountType, sourceType: $sourceType, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $CalendarSourceCopyWith<$Res>  {
  factory $CalendarSourceCopyWith(CalendarSource value, $Res Function(CalendarSource) _then) = _$CalendarSourceCopyWithImpl;
@useResult
$Res call({
 String id, String name, int color, bool isSelected, bool isPrimary, bool isReadOnly, DateTime createdAt, DateTime updatedAt, String? accountName, String? accountType, CalendarSourceType? sourceType, Map<String, dynamic>? metadata
});




}
/// @nodoc
class _$CalendarSourceCopyWithImpl<$Res>
    implements $CalendarSourceCopyWith<$Res> {
  _$CalendarSourceCopyWithImpl(this._self, this._then);

  final CalendarSource _self;
  final $Res Function(CalendarSource) _then;

/// Create a copy of CalendarSource
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? color = null,Object? isSelected = null,Object? isPrimary = null,Object? isReadOnly = null,Object? createdAt = null,Object? updatedAt = null,Object? accountName = freezed,Object? accountType = freezed,Object? sourceType = freezed,Object? metadata = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int,isSelected: null == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,isReadOnly: null == isReadOnly ? _self.isReadOnly : isReadOnly // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,accountName: freezed == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String?,accountType: freezed == accountType ? _self.accountType : accountType // ignore: cast_nullable_to_non_nullable
as String?,sourceType: freezed == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as CalendarSourceType?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [CalendarSource].
extension CalendarSourcePatterns on CalendarSource {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalendarSource value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalendarSource() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalendarSource value)  $default,){
final _that = this;
switch (_that) {
case _CalendarSource():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalendarSource value)?  $default,){
final _that = this;
switch (_that) {
case _CalendarSource() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int color,  bool isSelected,  bool isPrimary,  bool isReadOnly,  DateTime createdAt,  DateTime updatedAt,  String? accountName,  String? accountType,  CalendarSourceType? sourceType,  Map<String, dynamic>? metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CalendarSource() when $default != null:
return $default(_that.id,_that.name,_that.color,_that.isSelected,_that.isPrimary,_that.isReadOnly,_that.createdAt,_that.updatedAt,_that.accountName,_that.accountType,_that.sourceType,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int color,  bool isSelected,  bool isPrimary,  bool isReadOnly,  DateTime createdAt,  DateTime updatedAt,  String? accountName,  String? accountType,  CalendarSourceType? sourceType,  Map<String, dynamic>? metadata)  $default,) {final _that = this;
switch (_that) {
case _CalendarSource():
return $default(_that.id,_that.name,_that.color,_that.isSelected,_that.isPrimary,_that.isReadOnly,_that.createdAt,_that.updatedAt,_that.accountName,_that.accountType,_that.sourceType,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int color,  bool isSelected,  bool isPrimary,  bool isReadOnly,  DateTime createdAt,  DateTime updatedAt,  String? accountName,  String? accountType,  CalendarSourceType? sourceType,  Map<String, dynamic>? metadata)?  $default,) {final _that = this;
switch (_that) {
case _CalendarSource() when $default != null:
return $default(_that.id,_that.name,_that.color,_that.isSelected,_that.isPrimary,_that.isReadOnly,_that.createdAt,_that.updatedAt,_that.accountName,_that.accountType,_that.sourceType,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CalendarSource extends CalendarSource {
  const _CalendarSource({required this.id, required this.name, required this.color, required this.isSelected, required this.isPrimary, required this.isReadOnly, required this.createdAt, required this.updatedAt, this.accountName, this.accountType, this.sourceType, final  Map<String, dynamic>? metadata}): _metadata = metadata,super._();
  factory _CalendarSource.fromJson(Map<String, dynamic> json) => _$CalendarSourceFromJson(json);

@override final  String id;
@override final  String name;
@override final  int color;
@override final  bool isSelected;
@override final  bool isPrimary;
@override final  bool isReadOnly;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String? accountName;
@override final  String? accountType;
@override final  CalendarSourceType? sourceType;
 final  Map<String, dynamic>? _metadata;
@override Map<String, dynamic>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of CalendarSource
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalendarSourceCopyWith<_CalendarSource> get copyWith => __$CalendarSourceCopyWithImpl<_CalendarSource>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CalendarSourceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalendarSource&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.color, color) || other.color == color)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary)&&(identical(other.isReadOnly, isReadOnly) || other.isReadOnly == isReadOnly)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.accountType, accountType) || other.accountType == accountType)&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,color,isSelected,isPrimary,isReadOnly,createdAt,updatedAt,accountName,accountType,sourceType,const DeepCollectionEquality().hash(_metadata));

@override
String toString() {
  return 'CalendarSource(id: $id, name: $name, color: $color, isSelected: $isSelected, isPrimary: $isPrimary, isReadOnly: $isReadOnly, createdAt: $createdAt, updatedAt: $updatedAt, accountName: $accountName, accountType: $accountType, sourceType: $sourceType, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$CalendarSourceCopyWith<$Res> implements $CalendarSourceCopyWith<$Res> {
  factory _$CalendarSourceCopyWith(_CalendarSource value, $Res Function(_CalendarSource) _then) = __$CalendarSourceCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int color, bool isSelected, bool isPrimary, bool isReadOnly, DateTime createdAt, DateTime updatedAt, String? accountName, String? accountType, CalendarSourceType? sourceType, Map<String, dynamic>? metadata
});




}
/// @nodoc
class __$CalendarSourceCopyWithImpl<$Res>
    implements _$CalendarSourceCopyWith<$Res> {
  __$CalendarSourceCopyWithImpl(this._self, this._then);

  final _CalendarSource _self;
  final $Res Function(_CalendarSource) _then;

/// Create a copy of CalendarSource
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? color = null,Object? isSelected = null,Object? isPrimary = null,Object? isReadOnly = null,Object? createdAt = null,Object? updatedAt = null,Object? accountName = freezed,Object? accountType = freezed,Object? sourceType = freezed,Object? metadata = freezed,}) {
  return _then(_CalendarSource(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int,isSelected: null == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,isReadOnly: null == isReadOnly ? _self.isReadOnly : isReadOnly // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,accountName: freezed == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String?,accountType: freezed == accountType ? _self.accountType : accountType // ignore: cast_nullable_to_non_nullable
as String?,sourceType: freezed == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as CalendarSourceType?,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
