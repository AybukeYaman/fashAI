import 'package:fashai/src/core/firestore/firestore_model_utils.dart';

const Object _unset = Object();

class CachedCalendarEvent {
  const CachedCalendarEvent({
    required this.id,
    this.calendarId,
    this.externalEventId,
    this.title,
    required this.eventType,
    required this.startAt,
    required this.endAt,
    required this.isAllDay,
    this.locationLabel,
    required this.source,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String? calendarId;
  final String? externalEventId;
  final String? title;
  final String eventType;
  final DateTime startAt;
  final DateTime endAt;
  final bool isAllDay;
  final String? locationLabel;
  final String source;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory CachedCalendarEvent.fromFirestore(
    FirestoreSnapshot snapshot,
    Object? options,
  ) {
    final data = snapshotData(snapshot);
    return CachedCalendarEvent(
      id: snapshot.id,
      calendarId: readOptionalString(data, 'calendarId'),
      externalEventId: readOptionalString(data, 'externalEventId'),
      title: readOptionalString(data, 'title'),
      eventType: readString(data, 'eventType'),
      startAt: readDateTime(data, 'startAt'),
      endAt: readDateTime(data, 'endAt'),
      isAllDay: readBool(data, 'isAllDay'),
      locationLabel: readOptionalString(data, 'locationLabel'),
      source: readString(data, 'source'),
      createdAt: readDateTime(data, 'createdAt'),
      updatedAt: readDateTime(data, 'updatedAt'),
    );
  }

  FirestoreJson toFirestore() {
    return <String, Object?>{
      'calendarId': calendarId,
      'externalEventId': externalEventId,
      'title': title,
      'eventType': eventType,
      'startAt': timestampFromDate(startAt),
      'endAt': timestampFromDate(endAt),
      'isAllDay': isAllDay,
      'locationLabel': locationLabel,
      'source': source,
      'createdAt': timestampFromDate(createdAt),
      'updatedAt': timestampFromDate(updatedAt),
    };
  }

  CachedCalendarEvent copyWith({
    String? id,
    Object? calendarId = _unset,
    Object? externalEventId = _unset,
    Object? title = _unset,
    String? eventType,
    DateTime? startAt,
    DateTime? endAt,
    bool? isAllDay,
    Object? locationLabel = _unset,
    String? source,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CachedCalendarEvent(
      id: id ?? this.id,
      calendarId: identical(calendarId, _unset)
          ? this.calendarId
          : calendarId as String?,
      externalEventId: identical(externalEventId, _unset)
          ? this.externalEventId
          : externalEventId as String?,
      title: identical(title, _unset) ? this.title : title as String?,
      eventType: eventType ?? this.eventType,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      isAllDay: isAllDay ?? this.isAllDay,
      locationLabel: identical(locationLabel, _unset)
          ? this.locationLabel
          : locationLabel as String?,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CachedCalendarEvent &&
            other.id == id &&
            other.calendarId == calendarId &&
            other.externalEventId == externalEventId &&
            other.title == title &&
            other.eventType == eventType &&
            other.startAt == startAt &&
            other.endAt == endAt &&
            other.isAllDay == isAllDay &&
            other.locationLabel == locationLabel &&
            other.source == source &&
            other.createdAt == createdAt &&
            other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
    id,
    calendarId,
    externalEventId,
    title,
    eventType,
    startAt,
    endAt,
    isAllDay,
    locationLabel,
    source,
    createdAt,
    updatedAt,
  );
}
