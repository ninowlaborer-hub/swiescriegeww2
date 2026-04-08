// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'routine.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Routine {

 String get id; DateTime get date; String get title; List<TimeBlock> get timeBlocks; RoutineExplanation? get explanation; double? get confidenceScore; bool get isAccepted; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Routine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoutineCopyWith<Routine> get copyWith => _$RoutineCopyWithImpl<Routine>(this as Routine, _$identity);

  /// Serializes this Routine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Routine&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.timeBlocks, timeBlocks)&&(identical(other.explanation, explanation) || other.explanation == explanation)&&(identical(other.confidenceScore, confidenceScore) || other.confidenceScore == confidenceScore)&&(identical(other.isAccepted, isAccepted) || other.isAccepted == isAccepted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,title,const DeepCollectionEquality().hash(timeBlocks),explanation,confidenceScore,isAccepted,createdAt,updatedAt);

@override
String toString() {
  return 'Routine(id: $id, date: $date, title: $title, timeBlocks: $timeBlocks, explanation: $explanation, confidenceScore: $confidenceScore, isAccepted: $isAccepted, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $RoutineCopyWith<$Res>  {
  factory $RoutineCopyWith(Routine value, $Res Function(Routine) _then) = _$RoutineCopyWithImpl;
@useResult
$Res call({
 String id, DateTime date, String title, List<TimeBlock> timeBlocks, RoutineExplanation? explanation, double? confidenceScore, bool isAccepted, DateTime createdAt, DateTime updatedAt
});


$RoutineExplanationCopyWith<$Res>? get explanation;

}
/// @nodoc
class _$RoutineCopyWithImpl<$Res>
    implements $RoutineCopyWith<$Res> {
  _$RoutineCopyWithImpl(this._self, this._then);

  final Routine _self;
  final $Res Function(Routine) _then;

/// Create a copy of Routine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? date = null,Object? title = null,Object? timeBlocks = null,Object? explanation = freezed,Object? confidenceScore = freezed,Object? isAccepted = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,timeBlocks: null == timeBlocks ? _self.timeBlocks : timeBlocks // ignore: cast_nullable_to_non_nullable
as List<TimeBlock>,explanation: freezed == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as RoutineExplanation?,confidenceScore: freezed == confidenceScore ? _self.confidenceScore : confidenceScore // ignore: cast_nullable_to_non_nullable
as double?,isAccepted: null == isAccepted ? _self.isAccepted : isAccepted // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of Routine
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoutineExplanationCopyWith<$Res>? get explanation {
    if (_self.explanation == null) {
    return null;
  }

  return $RoutineExplanationCopyWith<$Res>(_self.explanation!, (value) {
    return _then(_self.copyWith(explanation: value));
  });
}
}


/// Adds pattern-matching-related methods to [Routine].
extension RoutinePatterns on Routine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Routine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Routine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Routine value)  $default,){
final _that = this;
switch (_that) {
case _Routine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Routine value)?  $default,){
final _that = this;
switch (_that) {
case _Routine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime date,  String title,  List<TimeBlock> timeBlocks,  RoutineExplanation? explanation,  double? confidenceScore,  bool isAccepted,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Routine() when $default != null:
return $default(_that.id,_that.date,_that.title,_that.timeBlocks,_that.explanation,_that.confidenceScore,_that.isAccepted,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime date,  String title,  List<TimeBlock> timeBlocks,  RoutineExplanation? explanation,  double? confidenceScore,  bool isAccepted,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Routine():
return $default(_that.id,_that.date,_that.title,_that.timeBlocks,_that.explanation,_that.confidenceScore,_that.isAccepted,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime date,  String title,  List<TimeBlock> timeBlocks,  RoutineExplanation? explanation,  double? confidenceScore,  bool isAccepted,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Routine() when $default != null:
return $default(_that.id,_that.date,_that.title,_that.timeBlocks,_that.explanation,_that.confidenceScore,_that.isAccepted,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Routine implements Routine {
  const _Routine({required this.id, required this.date, required this.title, required final  List<TimeBlock> timeBlocks, this.explanation, this.confidenceScore, this.isAccepted = false, required this.createdAt, required this.updatedAt}): _timeBlocks = timeBlocks;
  factory _Routine.fromJson(Map<String, dynamic> json) => _$RoutineFromJson(json);

@override final  String id;
@override final  DateTime date;
@override final  String title;
 final  List<TimeBlock> _timeBlocks;
@override List<TimeBlock> get timeBlocks {
  if (_timeBlocks is EqualUnmodifiableListView) return _timeBlocks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_timeBlocks);
}

@override final  RoutineExplanation? explanation;
@override final  double? confidenceScore;
@override@JsonKey() final  bool isAccepted;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Routine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoutineCopyWith<_Routine> get copyWith => __$RoutineCopyWithImpl<_Routine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoutineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Routine&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._timeBlocks, _timeBlocks)&&(identical(other.explanation, explanation) || other.explanation == explanation)&&(identical(other.confidenceScore, confidenceScore) || other.confidenceScore == confidenceScore)&&(identical(other.isAccepted, isAccepted) || other.isAccepted == isAccepted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,title,const DeepCollectionEquality().hash(_timeBlocks),explanation,confidenceScore,isAccepted,createdAt,updatedAt);

@override
String toString() {
  return 'Routine(id: $id, date: $date, title: $title, timeBlocks: $timeBlocks, explanation: $explanation, confidenceScore: $confidenceScore, isAccepted: $isAccepted, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$RoutineCopyWith<$Res> implements $RoutineCopyWith<$Res> {
  factory _$RoutineCopyWith(_Routine value, $Res Function(_Routine) _then) = __$RoutineCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime date, String title, List<TimeBlock> timeBlocks, RoutineExplanation? explanation, double? confidenceScore, bool isAccepted, DateTime createdAt, DateTime updatedAt
});


@override $RoutineExplanationCopyWith<$Res>? get explanation;

}
/// @nodoc
class __$RoutineCopyWithImpl<$Res>
    implements _$RoutineCopyWith<$Res> {
  __$RoutineCopyWithImpl(this._self, this._then);

  final _Routine _self;
  final $Res Function(_Routine) _then;

/// Create a copy of Routine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? date = null,Object? title = null,Object? timeBlocks = null,Object? explanation = freezed,Object? confidenceScore = freezed,Object? isAccepted = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Routine(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,timeBlocks: null == timeBlocks ? _self._timeBlocks : timeBlocks // ignore: cast_nullable_to_non_nullable
as List<TimeBlock>,explanation: freezed == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as RoutineExplanation?,confidenceScore: freezed == confidenceScore ? _self.confidenceScore : confidenceScore // ignore: cast_nullable_to_non_nullable
as double?,isAccepted: null == isAccepted ? _self.isAccepted : isAccepted // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of Routine
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoutineExplanationCopyWith<$Res>? get explanation {
    if (_self.explanation == null) {
    return null;
  }

  return $RoutineExplanationCopyWith<$Res>(_self.explanation!, (value) {
    return _then(_self.copyWith(explanation: value));
  });
}
}

// dart format on
