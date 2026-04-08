// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'routine_explanation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RoutineExplanation {

 String get summary; List<String> get factors; Map<String, dynamic>? get dataSourcesUsed; List<String>? get recommendations; DateTime? get generatedAt;
/// Create a copy of RoutineExplanation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoutineExplanationCopyWith<RoutineExplanation> get copyWith => _$RoutineExplanationCopyWithImpl<RoutineExplanation>(this as RoutineExplanation, _$identity);

  /// Serializes this RoutineExplanation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoutineExplanation&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.factors, factors)&&const DeepCollectionEquality().equals(other.dataSourcesUsed, dataSourcesUsed)&&const DeepCollectionEquality().equals(other.recommendations, recommendations)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,summary,const DeepCollectionEquality().hash(factors),const DeepCollectionEquality().hash(dataSourcesUsed),const DeepCollectionEquality().hash(recommendations),generatedAt);

@override
String toString() {
  return 'RoutineExplanation(summary: $summary, factors: $factors, dataSourcesUsed: $dataSourcesUsed, recommendations: $recommendations, generatedAt: $generatedAt)';
}


}

/// @nodoc
abstract mixin class $RoutineExplanationCopyWith<$Res>  {
  factory $RoutineExplanationCopyWith(RoutineExplanation value, $Res Function(RoutineExplanation) _then) = _$RoutineExplanationCopyWithImpl;
@useResult
$Res call({
 String summary, List<String> factors, Map<String, dynamic>? dataSourcesUsed, List<String>? recommendations, DateTime? generatedAt
});




}
/// @nodoc
class _$RoutineExplanationCopyWithImpl<$Res>
    implements $RoutineExplanationCopyWith<$Res> {
  _$RoutineExplanationCopyWithImpl(this._self, this._then);

  final RoutineExplanation _self;
  final $Res Function(RoutineExplanation) _then;

/// Create a copy of RoutineExplanation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? summary = null,Object? factors = null,Object? dataSourcesUsed = freezed,Object? recommendations = freezed,Object? generatedAt = freezed,}) {
  return _then(_self.copyWith(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,factors: null == factors ? _self.factors : factors // ignore: cast_nullable_to_non_nullable
as List<String>,dataSourcesUsed: freezed == dataSourcesUsed ? _self.dataSourcesUsed : dataSourcesUsed // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,recommendations: freezed == recommendations ? _self.recommendations : recommendations // ignore: cast_nullable_to_non_nullable
as List<String>?,generatedAt: freezed == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [RoutineExplanation].
extension RoutineExplanationPatterns on RoutineExplanation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoutineExplanation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoutineExplanation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoutineExplanation value)  $default,){
final _that = this;
switch (_that) {
case _RoutineExplanation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoutineExplanation value)?  $default,){
final _that = this;
switch (_that) {
case _RoutineExplanation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String summary,  List<String> factors,  Map<String, dynamic>? dataSourcesUsed,  List<String>? recommendations,  DateTime? generatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoutineExplanation() when $default != null:
return $default(_that.summary,_that.factors,_that.dataSourcesUsed,_that.recommendations,_that.generatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String summary,  List<String> factors,  Map<String, dynamic>? dataSourcesUsed,  List<String>? recommendations,  DateTime? generatedAt)  $default,) {final _that = this;
switch (_that) {
case _RoutineExplanation():
return $default(_that.summary,_that.factors,_that.dataSourcesUsed,_that.recommendations,_that.generatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String summary,  List<String> factors,  Map<String, dynamic>? dataSourcesUsed,  List<String>? recommendations,  DateTime? generatedAt)?  $default,) {final _that = this;
switch (_that) {
case _RoutineExplanation() when $default != null:
return $default(_that.summary,_that.factors,_that.dataSourcesUsed,_that.recommendations,_that.generatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RoutineExplanation implements RoutineExplanation {
  const _RoutineExplanation({required this.summary, required final  List<String> factors, final  Map<String, dynamic>? dataSourcesUsed, final  List<String>? recommendations, this.generatedAt}): _factors = factors,_dataSourcesUsed = dataSourcesUsed,_recommendations = recommendations;
  factory _RoutineExplanation.fromJson(Map<String, dynamic> json) => _$RoutineExplanationFromJson(json);

@override final  String summary;
 final  List<String> _factors;
@override List<String> get factors {
  if (_factors is EqualUnmodifiableListView) return _factors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_factors);
}

 final  Map<String, dynamic>? _dataSourcesUsed;
@override Map<String, dynamic>? get dataSourcesUsed {
  final value = _dataSourcesUsed;
  if (value == null) return null;
  if (_dataSourcesUsed is EqualUnmodifiableMapView) return _dataSourcesUsed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  List<String>? _recommendations;
@override List<String>? get recommendations {
  final value = _recommendations;
  if (value == null) return null;
  if (_recommendations is EqualUnmodifiableListView) return _recommendations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  DateTime? generatedAt;

/// Create a copy of RoutineExplanation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoutineExplanationCopyWith<_RoutineExplanation> get copyWith => __$RoutineExplanationCopyWithImpl<_RoutineExplanation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoutineExplanationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoutineExplanation&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other._factors, _factors)&&const DeepCollectionEquality().equals(other._dataSourcesUsed, _dataSourcesUsed)&&const DeepCollectionEquality().equals(other._recommendations, _recommendations)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,summary,const DeepCollectionEquality().hash(_factors),const DeepCollectionEquality().hash(_dataSourcesUsed),const DeepCollectionEquality().hash(_recommendations),generatedAt);

@override
String toString() {
  return 'RoutineExplanation(summary: $summary, factors: $factors, dataSourcesUsed: $dataSourcesUsed, recommendations: $recommendations, generatedAt: $generatedAt)';
}


}

/// @nodoc
abstract mixin class _$RoutineExplanationCopyWith<$Res> implements $RoutineExplanationCopyWith<$Res> {
  factory _$RoutineExplanationCopyWith(_RoutineExplanation value, $Res Function(_RoutineExplanation) _then) = __$RoutineExplanationCopyWithImpl;
@override @useResult
$Res call({
 String summary, List<String> factors, Map<String, dynamic>? dataSourcesUsed, List<String>? recommendations, DateTime? generatedAt
});




}
/// @nodoc
class __$RoutineExplanationCopyWithImpl<$Res>
    implements _$RoutineExplanationCopyWith<$Res> {
  __$RoutineExplanationCopyWithImpl(this._self, this._then);

  final _RoutineExplanation _self;
  final $Res Function(_RoutineExplanation) _then;

/// Create a copy of RoutineExplanation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? summary = null,Object? factors = null,Object? dataSourcesUsed = freezed,Object? recommendations = freezed,Object? generatedAt = freezed,}) {
  return _then(_RoutineExplanation(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,factors: null == factors ? _self._factors : factors // ignore: cast_nullable_to_non_nullable
as List<String>,dataSourcesUsed: freezed == dataSourcesUsed ? _self._dataSourcesUsed : dataSourcesUsed // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,recommendations: freezed == recommendations ? _self._recommendations : recommendations // ignore: cast_nullable_to_non_nullable
as List<String>?,generatedAt: freezed == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
