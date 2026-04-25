import 'package:fashai/src/core/firestore/firestore_model_utils.dart';
import 'package:fashai/src/features/wardrobe/data/models/wardrobe_item.dart';
import 'package:flutter/foundation.dart';

const Object _unset = Object();

class Outfit {
  Outfit({
    required this.id,
    required this.title,
    this.description,
    this.occasion,
    required List<WardrobeItemSnapshot> wardrobeSnapshots,
    required List<String> itemIds,
    this.imageUrl,
    this.reason,
    this.sourceRecommendationId,
    this.localDate,
    this.wornAt,
    this.isFavorite = false,
    this.isArchived = false,
    required this.createdAt,
    required this.updatedAt,
  }) : wardrobeSnapshots = List<WardrobeItemSnapshot>.unmodifiable(
         wardrobeSnapshots,
       ),
       itemIds = List<String>.unmodifiable(itemIds);

  final String id;
  final String title;
  final String? description;
  final String? occasion;

  // Outfit docs embed wardrobe snapshots so history still renders after a
  // wardrobe item is edited or deleted.
  final List<WardrobeItemSnapshot> wardrobeSnapshots;

  final List<String> itemIds;
  final String? imageUrl;
  final String? reason;
  final String? sourceRecommendationId;
  final String? localDate;
  final DateTime? wornAt;
  final bool isFavorite;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Outfit.fromFirestore(FirestoreSnapshot snapshot, Object? options) {
    return Outfit.fromMap(snapshot.id, snapshotData(snapshot));
  }

  factory Outfit.fromMap(String id, FirestoreJson data) {
    return Outfit(
      id: id,
      title: readString(data, 'title'),
      description: readOptionalString(data, 'description'),
      occasion: readOptionalString(data, 'occasion'),
      wardrobeSnapshots: mapListFromObject(
        data['wardrobeSnapshots'],
        fieldName: 'wardrobeSnapshots',
      ).map(WardrobeItemSnapshot.fromMap).toList(growable: false),
      itemIds: readStringList(data, 'itemIds'),
      imageUrl: readOptionalString(data, 'imageUrl'),
      reason: readOptionalString(data, 'reason'),
      sourceRecommendationId: readOptionalString(
        data,
        'sourceRecommendationId',
      ),
      localDate: readOptionalString(data, 'localDate'),
      wornAt: readOptionalDateTime(data, 'wornAt'),
      isFavorite: readBool(data, 'isFavorite'),
      isArchived: readBool(data, 'isArchived'),
      createdAt: readDateTime(data, 'createdAt'),
      updatedAt: readDateTime(data, 'updatedAt'),
    );
  }

  FirestoreJson toFirestore() {
    return <String, Object?>{
      'title': title,
      'description': description,
      'occasion': occasion,
      'wardrobeSnapshots': wardrobeSnapshots
          .map((snapshot) => snapshot.toMap())
          .toList(growable: false),
      'itemIds': itemIds,
      'imageUrl': imageUrl,
      'reason': reason,
      'sourceRecommendationId': sourceRecommendationId,
      'localDate': localDate,
      'wornAt': optionalTimestampFromDate(wornAt),
      'isFavorite': isFavorite,
      'isArchived': isArchived,
      'createdAt': timestampFromDate(createdAt),
      'updatedAt': timestampFromDate(updatedAt),
    };
  }

  Outfit copyWith({
    String? id,
    String? title,
    Object? description = _unset,
    Object? occasion = _unset,
    List<WardrobeItemSnapshot>? wardrobeSnapshots,
    List<String>? itemIds,
    Object? imageUrl = _unset,
    Object? reason = _unset,
    Object? sourceRecommendationId = _unset,
    Object? localDate = _unset,
    Object? wornAt = _unset,
    bool? isFavorite,
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Outfit(
      id: id ?? this.id,
      title: title ?? this.title,
      description: identical(description, _unset)
          ? this.description
          : description as String?,
      occasion: identical(occasion, _unset)
          ? this.occasion
          : occasion as String?,
      wardrobeSnapshots: wardrobeSnapshots ?? this.wardrobeSnapshots,
      itemIds: itemIds ?? this.itemIds,
      imageUrl: identical(imageUrl, _unset)
          ? this.imageUrl
          : imageUrl as String?,
      reason: identical(reason, _unset) ? this.reason : reason as String?,
      sourceRecommendationId: identical(sourceRecommendationId, _unset)
          ? this.sourceRecommendationId
          : sourceRecommendationId as String?,
      localDate: identical(localDate, _unset)
          ? this.localDate
          : localDate as String?,
      wornAt: identical(wornAt, _unset) ? this.wornAt : wornAt as DateTime?,
      isFavorite: isFavorite ?? this.isFavorite,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Outfit &&
            other.id == id &&
            other.title == title &&
            other.description == description &&
            other.occasion == occasion &&
            listEquals(other.wardrobeSnapshots, wardrobeSnapshots) &&
            listEquals(other.itemIds, itemIds) &&
            other.imageUrl == imageUrl &&
            other.reason == reason &&
            other.sourceRecommendationId == sourceRecommendationId &&
            other.localDate == localDate &&
            other.wornAt == wornAt &&
            other.isFavorite == isFavorite &&
            other.isArchived == isArchived &&
            other.createdAt == createdAt &&
            other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    occasion,
    Object.hashAll(wardrobeSnapshots),
    Object.hashAll(itemIds),
    imageUrl,
    reason,
    sourceRecommendationId,
    localDate,
    wornAt,
    isFavorite,
    isArchived,
    createdAt,
    updatedAt,
  );
}
