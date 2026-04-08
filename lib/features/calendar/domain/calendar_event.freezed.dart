// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calendar_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CalendarEvent {

 String get id; String get calendarId; String get title; DateTime get startTime; DateTime get endTime; bool get isAllDay; DateTime get createdAt; DateTime get updatedAt; String? get description; String? get location; String? get recurrenceRule; String? get timezone; List<String>? get attendees; String? get organizerEmail; CalendarEventStatus? get status; bool? get isOrganizer; String? get meetingUrl; Map<String, dynamic>? get metadata;
/// Create a copy of CalendarEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalendarEventCopyWith<CalendarEvent> get copyWith => _$CalendarEventCopyWithImpl<CalendarEvent>(this as CalendarEvent, _$identity);

  /// Serializes this CalendarEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalendarEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.calendarId, calendarId) || other.calendarId == calendarId)&&(identical(other.title, title) || other.title == title)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.isAllDay, isAllDay) || other.isAllDay == isAllDay)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.location, location) || other.location == location)&&(identical(other.recurrenceRule, recurrenceRule) || other.recurrenceRule == recurrenceRule)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&const DeepCollectionEquality().equals(other.attendees, attendees)&&(identical(other.organizerEmail, organizerEmail) || other.organizerEmail == organizerEmail)&&(identical(other.status, status) || other.status == status)&&(identical(other.isOrganizer, isOrganizer) || other.isOrganizer == isOrganizer)&&(identical(other.meetingUrl, meetingUrl) || other.meetingUrl == meetingUrl)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,calendarId,title,startTime,endTime,isAllDay,createdAt,updatedAt,description,location,recurrenceRule,timezone,const DeepCollectionEquality().hash(attendees),organizerEmail,status,isOrganizer,meetingUrl,const DeepCollectionEquality().hash(metadata));

@override
String toString() {
  return 'CalendarEvent(id: $id, calendarId: $calendarId, title: $title, startTime: $startTime, endTime: $endTime, isAllDay: $isAllDay, createdAt: $createdAt, updatedAt: $updatedAt, description: $description, location: $location, recurrenceRule: $recurrenceRule, timezone: $timezone, attendees: $attendees, organizerEmail: $organizerEmail, status: $status, isOrganizer: $isOrganizer, meetingUrl: $meetingUrl, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $CalendarEventCopyWith<$Res>  {
  factory $CalendarEventCopyWith(CalendarEvent value, $Res Function(CalendarEvent) _then) = _$CalendarEventCopyWithImpl;
@useResult
$Res call({
 String id, String calendarId, String title, DateTime startTime, DateTime endTime, bool isAllDay, DateTime createdAt, DateTime updatedAt, String? description, String? location, String? recurrenceRule, String? timezone, List<String>? attendees, String? organizerEmail, CalendarEventStatus? status, bool? isOrganizer, String? meetingUrl, Map<String, dynamic>? metadata
});




}
/// @nodoc
class _$CalendarEventCopyWithImpl<$Res>
    implements $CalendarEventCopyWith<$Res> {
  _$CalendarEventCopyWithImpl(this._self, this._then);

  final CalendarEvent _self;
  final $Res Function(CalendarEvent) _then;

/// Create a copy of CalendarEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? calendarId = null,Object? title = null,Object? startTime = null,Object? endTime = null,Object? isAllDay = null,Object? createdAt = null,Object? updatedAt = null,Object? description = freezed,Object? location = freezed,Object? recurrenceRule = freezed,Object? timezone = freezed,Object? attendees = freezed,Object? organizerEmail = freezed,Object? status = freezed,Object? isOrganizer = freezed,Object? meetingUrl = freezed,Object? metadata = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,calendarId: null == calendarId ? _self.calendarId : calendarId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime,isAllDay: null == isAllDay ? _self.isAllDay : isAllDay // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,recurrenceRule: freezed == recurrenceRule ? _self.recurrenceRule : recurrenceRule // ignore: cast_nullable_to_non_nullable
as String?,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,attendees: freezed == attendees ? _self.attendees : attendees // ignore: cast_nullable_to_non_nullable
as List<String>?,organizerEmail: freezed == organizerEmail ? _self.organizerEmail : organizerEmail // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CalendarEventStatus?,isOrganizer: freezed == isOrganizer ? _self.isOrganizer : isOrganizer // ignore: cast_nullable_to_non_nullable
as bool?,meetingUrl: freezed == meetingUrl ? _self.meetingUrl : meetingUrl // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [CalendarEvent].
extension CalendarEventPatterns on CalendarEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalendarEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalendarEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalendarEvent value)  $default,){
final _that = this;
switch (_that) {
case _CalendarEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalendarEvent value)?  $default,){
final _that = this;
switch (_that) {
case _CalendarEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String calendarId,  String title,  DateTime startTime,  DateTime endTime,  bool isAllDay,  DateTime createdAt,  DateTime updatedAt,  String? description,  String? location,  String? recurrenceRule,  String? timezone,  List<String>? attendees,  String? organizerEmail,  CalendarEventStatus? status,  bool? isOrganizer,  String? meetingUrl,  Map<String, dynamic>? metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CalendarEvent() when $default != null:
return $default(_that.id,_that.calendarId,_that.title,_that.startTime,_that.endTime,_that.isAllDay,_that.createdAt,_that.updatedAt,_that.description,_that.location,_that.recurrenceRule,_that.timezone,_that.attendees,_that.organizerEmail,_that.status,_that.isOrganizer,_that.meetingUrl,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String calendarId,  String title,  DateTime startTime,  DateTime endTime,  bool isAllDay,  DateTime createdAt,  DateTime updatedAt,  String? description,  String? location,  String? recurrenceRule,  String? timezone,  List<String>? attendees,  String? organizerEmail,  CalendarEventStatus? status,  bool? isOrganizer,  String? meetingUrl,  Map<String, dynamic>? metadata)  $default,) {final _that = this;
switch (_that) {
case _CalendarEvent():
return $default(_that.id,_that.calendarId,_that.title,_that.startTime,_that.endTime,_that.isAllDay,_that.createdAt,_that.updatedAt,_that.description,_that.location,_that.recurrenceRule,_that.timezone,_that.attendees,_that.organizerEmail,_that.status,_that.isOrganizer,_that.meetingUrl,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String calendarId,  String title,  DateTime startTime,  DateTime endTime,  bool isAllDay,  DateTime createdAt,  DateTime updatedAt,  String? description,  String? location,  String? recurrenceRule,  String? timezone,  List<String>? attendees,  String? organizerEmail,  CalendarEventStatus? status,  bool? isOrganizer,  String? meetingUrl,  Map<String, dynamic>? metadata)?  $default,) {final _that = this;
switch (_that) {
case _CalendarEvent() when $default != null:
return $default(_that.id,_that.calendarId,_that.title,_that.startTime,_that.endTime,_that.isAllDay,_that.createdAt,_that.updatedAt,_that.description,_that.location,_that.recurrenceRule,_that.timezone,_that.attendees,_that.organizerEmail,_that.status,_that.isOrganizer,_that.meetingUrl,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CalendarEvent extends CalendarEvent {
  const _CalendarEvent({required this.id, required this.calendarId, required this.title, required this.startTime, required this.endTime, required this.isAllDay, required this.createdAt, required this.updatedAt, this.description, this.location, this.recurrenceRule, this.timezone, final  List<String>? attendees, this.organizerEmail, this.status, this.isOrganizer, this.meetingUrl, final  Map<String, dynamic>? metadata}): _attendees = attendees,_metadata = metadata,super._();
  factory _CalendarEvent.fromJson(Map<String, dynamic> json) => _$CalendarEventFromJson(json);

@override final  String id;
@override final  String calendarId;
@override final  String title;
@override final  DateTime startTime;
@override final  DateTime endTime;
@override final  bool isAllDay;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String? description;
@override final  String? location;
@override final  String? recurrenceRule;
@override final  String? timezone;
 final  List<String>? _attendees;
@override List<String>? get attendees {
  final value = _attendees;
  if (value == null) return null;
  if (_attendees is EqualUnmodifiableListView) return _attendees;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? organizerEmail;
@override final  CalendarEventStatus? status;
@override final  bool? isOrganizer;
@override final  String? meetingUrl;
 final  Map<String, dynamic>? _metadata;
@override Map<String, dynamic>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of CalendarEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalendarEventCopyWith<_CalendarEvent> get copyWith => __$CalendarEventCopyWithImpl<_CalendarEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CalendarEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalendarEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.calendarId, calendarId) || other.calendarId == calendarId)&&(identical(other.title, title) || other.title == title)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.isAllDay, isAllDay) || other.isAllDay == isAllDay)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.location, location) || other.location == location)&&(identical(other.recurrenceRule, recurrenceRule) || other.recurrenceRule == recurrenceRule)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&const DeepCollectionEquality().equals(other._attendees, _attendees)&&(identical(other.organizerEmail, organizerEmail) || other.organizerEmail == organizerEmail)&&(identical(other.status, status) || other.status == status)&&(identical(other.isOrganizer, isOrganizer) || other.isOrganizer == isOrganizer)&&(identical(other.meetingUrl, meetingUrl) || other.meetingUrl == meetingUrl)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,calendarId,title,startTime,endTime,isAllDay,createdAt,updatedAt,description,location,recurrenceRule,timezone,const DeepCollectionEquality().hash(_attendees),organizerEmail,status,isOrganizer,meetingUrl,const DeepCollectionEquality().hash(_metadata));

@override
String toString() {
  return 'CalendarEvent(id: $id, calendarId: $calendarId, title: $title, startTime: $startTime, endTime: $endTime, isAllDay: $isAllDay, createdAt: $createdAt, updatedAt: $updatedAt, description: $description, location: $location, recurrenceRule: $recurrenceRule, timezone: $timezone, attendees: $attendees, organizerEmail: $organizerEmail, status: $status, isOrganizer: $isOrganizer, meetingUrl: $meetingUrl, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$CalendarEventCopyWith<$Res> implements $CalendarEventCopyWith<$Res> {
  factory _$CalendarEventCopyWith(_CalendarEvent value, $Res Function(_CalendarEvent) _then) = __$CalendarEventCopyWithImpl;
@override @useResult
$Res call({
 String id, String calendarId, String title, DateTime startTime, DateTime endTime, bool isAllDay, DateTime createdAt, DateTime updatedAt, String? description, String? location, String? recurrenceRule, String? timezone, List<String>? attendees, String? organizerEmail, CalendarEventStatus? status, bool? isOrganizer, String? meetingUrl, Map<String, dynamic>? metadata
});




}
/// @nodoc
class __$CalendarEventCopyWithImpl<$Res>
    implements _$CalendarEventCopyWith<$Res> {
  __$CalendarEventCopyWithImpl(this._self, this._then);

  final _CalendarEvent _self;
  final $Res Function(_CalendarEvent) _then;

/// Create a copy of CalendarEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? calendarId = null,Object? title = null,Object? startTime = null,Object? endTime = null,Object? isAllDay = null,Object? createdAt = null,Object? updatedAt = null,Object? description = freezed,Object? location = freezed,Object? recurrenceRule = freezed,Object? timezone = freezed,Object? attendees = freezed,Object? organizerEmail = freezed,Object? status = freezed,Object? isOrganizer = freezed,Object? meetingUrl = freezed,Object? metadata = freezed,}) {
  return _then(_CalendarEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,calendarId: null == calendarId ? _self.calendarId : calendarId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime,isAllDay: null == isAllDay ? _self.isAllDay : isAllDay // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,recurrenceRule: freezed == recurrenceRule ? _self.recurrenceRule : recurrenceRule // ignore: cast_nullable_to_non_nullable
as String?,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,attendees: freezed == attendees ? _self._attendees : attendees // ignore: cast_nullable_to_non_nullable
as List<String>?,organizerEmail: freezed == organizerEmail ? _self.organizerEmail : organizerEmail // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CalendarEventStatus?,isOrganizer: freezed == isOrganizer ? _self.isOrganizer : isOrganizer // ignore: cast_nullable_to_non_nullable
as bool?,meetingUrl: freezed == meetingUrl ? _self.meetingUrl : meetingUrl // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
