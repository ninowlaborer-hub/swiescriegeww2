// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CalendarEvent _$CalendarEventFromJson(Map<String, dynamic> json) =>
    _CalendarEvent(
      id: json['id'] as String,
      calendarId: json['calendarId'] as String,
      title: json['title'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      isAllDay: json['isAllDay'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      description: json['description'] as String?,
      location: json['location'] as String?,
      recurrenceRule: json['recurrenceRule'] as String?,
      timezone: json['timezone'] as String?,
      attendees: (json['attendees'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      organizerEmail: json['organizerEmail'] as String?,
      status: $enumDecodeNullable(_$CalendarEventStatusEnumMap, json['status']),
      isOrganizer: json['isOrganizer'] as bool?,
      meetingUrl: json['meetingUrl'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$CalendarEventToJson(_CalendarEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'calendarId': instance.calendarId,
      'title': instance.title,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'isAllDay': instance.isAllDay,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'description': instance.description,
      'location': instance.location,
      'recurrenceRule': instance.recurrenceRule,
      'timezone': instance.timezone,
      'attendees': instance.attendees,
      'organizerEmail': instance.organizerEmail,
      'status': _$CalendarEventStatusEnumMap[instance.status],
      'isOrganizer': instance.isOrganizer,
      'meetingUrl': instance.meetingUrl,
      'metadata': instance.metadata,
    };

const _$CalendarEventStatusEnumMap = {
  CalendarEventStatus.confirmed: 'confirmed',
  CalendarEventStatus.tentative: 'tentative',
  CalendarEventStatus.cancelled: 'cancelled',
};
