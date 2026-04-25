import 'package:fashai/src/core/firestore/firestore_model_utils.dart';
import 'package:flutter/foundation.dart';

const Object _unset = Object();

class InboxNotification {
  InboxNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.deepLink,
    this.imageUrl,
    FirestoreJson payload = const <String, Object?>{},
    this.isRead = false,
    this.readAt,
    required this.createdAt,
    required this.updatedAt,
  }) : payload = Map<String, Object?>.unmodifiable(payload);

  final String id;
  final String title;
  final String body;
  final String type;
  final String? deepLink;
  final String? imageUrl;
  final FirestoreJson payload;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory InboxNotification.fromFirestore(
    FirestoreSnapshot snapshot,
    Object? options,
  ) {
    final data = snapshotData(snapshot);
    return InboxNotification(
      id: snapshot.id,
      title: readString(data, 'title'),
      body: readString(data, 'body'),
      type: readString(data, 'type'),
      deepLink: readOptionalString(data, 'deepLink'),
      imageUrl: readOptionalString(data, 'imageUrl'),
      payload: mapFromObject(data['payload'], fieldName: 'payload'),
      isRead: readBool(data, 'isRead'),
      readAt: readOptionalDateTime(data, 'readAt'),
      createdAt: readDateTime(data, 'createdAt'),
      updatedAt: readDateTime(data, 'updatedAt'),
    );
  }

  FirestoreJson toFirestore() {
    return <String, Object?>{
      'title': title,
      'body': body,
      'type': type,
      'deepLink': deepLink,
      'imageUrl': imageUrl,
      'payload': payload,
      'isRead': isRead,
      'readAt': optionalTimestampFromDate(readAt),
      'createdAt': timestampFromDate(createdAt),
      'updatedAt': timestampFromDate(updatedAt),
    };
  }

  InboxNotification copyWith({
    String? id,
    String? title,
    String? body,
    String? type,
    Object? deepLink = _unset,
    Object? imageUrl = _unset,
    FirestoreJson? payload,
    bool? isRead,
    Object? readAt = _unset,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InboxNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      deepLink: identical(deepLink, _unset)
          ? this.deepLink
          : deepLink as String?,
      imageUrl: identical(imageUrl, _unset)
          ? this.imageUrl
          : imageUrl as String?,
      payload: payload ?? this.payload,
      isRead: isRead ?? this.isRead,
      readAt: identical(readAt, _unset) ? this.readAt : readAt as DateTime?,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is InboxNotification &&
            other.id == id &&
            other.title == title &&
            other.body == body &&
            other.type == type &&
            other.deepLink == deepLink &&
            other.imageUrl == imageUrl &&
            mapEquals(other.payload, payload) &&
            other.isRead == isRead &&
            other.readAt == readAt &&
            other.createdAt == createdAt &&
            other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    body,
    type,
    deepLink,
    imageUrl,
    Object.hashAllUnordered(
      payload.entries.map((entry) => Object.hash(entry.key, entry.value)),
    ),
    isRead,
    readAt,
    createdAt,
    updatedAt,
  );
}
