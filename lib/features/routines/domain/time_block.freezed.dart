// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'time_block.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TimeBlock {

 String get id; String get routineId; String get title; String? get description; DateTime get startTime; DateTime get endTime; String get activityType; String? get category; int get priority; bool get isSnoozed; DateTime? get snoozedUntil; String? get source;// calendar, ai, manual
 DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of TimeBlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimeBlockCopyWith<TimeBlock> get copyWith => _$TimeBlockCopyWithImpl<TimeBlock>(this as TimeBlock, _$identity);

  /// Serializes this TimeBlock to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimeBlock&&(identical(other.id, id) || other.id == id)&&(identical(other.routineId, routineId) || other.routineId == routineId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.activityType, activityType) || other.activityType == activityType)&&(identical(other.category, category) || other.category == category)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.isSnoozed, isSnoozed) || other.isSnoozed == isSnoozed)&&(identical(other.snoozedUntil, snoozedUntil) || other.snoozedUntil == snoozedUntil)&&(identical(other.source, source) || other.source == source)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,routineId,title,description,startTime,endTime,activityType,category,priority,isSnoozed,snoozedUntil,source,createdAt,updatedAt);

@override
String toString() {
  return 'TimeBlock(id: $id, routineId: $routineId, title: $title, description: $description, startTime: $startTime, endTime: $endTime, activityType: $activityType, category: $category, priority: $priority, isSnoozed: $isSnoozed, snoozedUntil: $snoozedUntil, source: $source, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $TimeBlockCopyWith<$Res>  {
  factory $TimeBlockCopyWith(TimeBlock value, $Res Function(TimeBlock) _then) = _$TimeBlockCopyWithImpl;
@useResult
$Res call({
 String id, String routineId, String title, String? description, DateTime startTime, DateTime endTime, String activityType, String? category, int priority, bool isSnoozed, DateTime? snoozedUntil, String? source, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$TimeBlockCopyWithImpl<$Res>
    implements $TimeBlockCopyWith<$Res> {
  _$TimeBlockCopyWithImpl(this._self, this._then);

  final TimeBlock _self;
  final $Res Function(TimeBlock) _then;

/// Create a copy of TimeBlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? routineId = null,Object? title = null,Object? description = freezed,Object? startTime = null,Object? endTime = null,Object? activityType = null,Object? category = freezed,Object? priority = null,Object? isSnoozed = null,Object? snoozedUntil = freezed,Object? source = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,routineId: null == routineId ? _self.routineId : routineId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime,activityType: null == activityType ? _self.activityType : activityType // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,isSnoozed: null == isSnoozed ? _self.isSnoozed : isSnoozed // ignore: cast_nullable_to_non_nullable
as bool,snoozedUntil: freezed == snoozedUntil ? _self.snoozedUntil : snoozedUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TimeBlock].
extension TimeBlockPatterns on TimeBlock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimeBlock value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimeBlock() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimeBlock value)  $default,){
final _that = this;
switch (_that) {
case _TimeBlock():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimeBlock value)?  $default,){
final _that = this;
switch (_that) {
case _TimeBlock() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String routineId,  String title,  String? description,  DateTime startTime,  DateTime endTime,  String activityType,  String? category,  int priority,  bool isSnoozed,  DateTime? snoozedUntil,  String? source,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimeBlock() when $default != null:
return $default(_that.id,_that.routineId,_that.title,_that.description,_that.startTime,_that.endTime,_that.activityType,_that.category,_that.priority,_that.isSnoozed,_that.snoozedUntil,_that.source,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String routineId,  String title,  String? description,  DateTime startTime,  DateTime endTime,  String activityType,  String? category,  int priority,  bool isSnoozed,  DateTime? snoozedUntil,  String? source,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _TimeBlock():
return $default(_that.id,_that.routineId,_that.title,_that.description,_that.startTime,_that.endTime,_that.activityType,_that.category,_that.priority,_that.isSnoozed,_that.snoozedUntil,_that.source,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String routineId,  String title,  String? description,  DateTime startTime,  DateTime endTime,  String activityType,  String? category,  int priority,  bool isSnoozed,  DateTime? snoozedUntil,  String? source,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _TimeBlock() when $default != null:
return $default(_that.id,_that.routineId,_that.title,_that.description,_that.startTime,_that.endTime,_that.activityType,_that.category,_that.priority,_that.isSnoozed,_that.snoozedUntil,_that.source,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TimeBlock implements TimeBlock {
  const _TimeBlock({required this.id, required this.routineId, required this.title, this.description, required this.startTime, required this.endTime, required this.activityType, this.category, this.priority = 0, this.isSnoozed = false, this.snoozedUntil, this.source, required this.createdAt, required this.updatedAt});
  factory _TimeBlock.fromJson(Map<String, dynamic> json) => _$TimeBlockFromJson(json);

@override final  String id;
@override final  String routineId;
@override final  String title;
@override final  String? description;
@override final  DateTime startTime;
@override final  DateTime endTime;
@override final  String activityType;
@override final  String? category;
@override@JsonKey() final  int priority;
@override@JsonKey() final  bool isSnoozed;
@override final  DateTime? snoozedUntil;
@override final  String? source;
// calendar, ai, manual
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of TimeBlock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimeBlockCopyWith<_TimeBlock> get copyWith => __$TimeBlockCopyWithImpl<_TimeBlock>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimeBlockToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimeBlock&&(identical(other.id, id) || other.id == id)&&(identical(other.routineId, routineId) || other.routineId == routineId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.activityType, activityType) || other.activityType == activityType)&&(identical(other.category, category) || other.category == category)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.isSnoozed, isSnoozed) || other.isSnoozed == isSnoozed)&&(identical(other.snoozedUntil, snoozedUntil) || other.snoozedUntil == snoozedUntil)&&(identical(other.source, source) || other.source == source)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,routineId,title,description,startTime,endTime,activityType,category,priority,isSnoozed,snoozedUntil,source,createdAt,updatedAt);

@override
String toString() {
  return 'TimeBlock(id: $id, routineId: $routineId, title: $title, description: $description, startTime: $startTime, endTime: $endTime, activityType: $activityType, category: $category, priority: $priority, isSnoozed: $isSnoozed, snoozedUntil: $snoozedUntil, source: $source, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$TimeBlockCopyWith<$Res> implements $TimeBlockCopyWith<$Res> {
  factory _$TimeBlockCopyWith(_TimeBlock value, $Res Function(_TimeBlock) _then) = __$TimeBlockCopyWithImpl;
@override @useResult
$Res call({
 String id, String routineId, String title, String? description, DateTime startTime, DateTime endTime, String activityType, String? category, int priority, bool isSnoozed, DateTime? snoozedUntil, String? source, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$TimeBlockCopyWithImpl<$Res>
    implements _$TimeBlockCopyWith<$Res> {
  __$TimeBlockCopyWithImpl(this._self, this._then);

  final _TimeBlock _self;
  final $Res Function(_TimeBlock) _then;

/// Create a copy of TimeBlock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? routineId = null,Object? title = null,Object? description = freezed,Object? startTime = null,Object? endTime = null,Object? activityType = null,Object? category = freezed,Object? priority = null,Object? isSnoozed = null,Object? snoozedUntil = freezed,Object? source = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_TimeBlock(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,routineId: null == routineId ? _self.routineId : routineId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime,activityType: null == activityType ? _self.activityType : activityType // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,isSnoozed: null == isSnoozed ? _self.isSnoozed : isSnoozed // ignore: cast_nullable_to_non_nullable
as bool,snoozedUntil: freezed == snoozedUntil ? _self.snoozedUntil : snoozedUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
