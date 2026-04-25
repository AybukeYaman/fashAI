import 'package:fashai/src/core/firestore/firestore_model_utils.dart';
import 'package:fashai/src/features/wardrobe/data/models/wardrobe_item.dart';
import 'package:flutter/foundation.dart';

const Object _unset = Object();

class StyleChallenge {
  StyleChallenge({
    required this.id,
    required this.title,
    this.description,
    this.theme,
    this.coverImageUrl,
    List<String> tags = const <String>[],
    required this.startsAt,
    required this.endsAt,
    this.isActive = false,
    this.sortOrder = 0,
    required this.createdAt,
    required this.updatedAt,
  }) : tags = List<String>.unmodifiable(tags);

  final String id;
  final String title;
  final String? description;
  final String? theme;
  final String? coverImageUrl;
  final List<String> tags;
  final DateTime startsAt;
  final DateTime endsAt;
  final bool isActive;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory StyleChallenge.fromFirestore(
    FirestoreSnapshot snapshot,
    Object? options,
  ) {
    final data = snapshotData(snapshot);
    return StyleChallenge(
      id: snapshot.id,
      title: readString(data, 'title'),
      description: readOptionalString(data, 'description'),
      theme: readOptionalString(data, 'theme'),
      coverImageUrl: readOptionalString(data, 'coverImageUrl'),
      tags: readStringList(data, 'tags'),
      startsAt: readDateTime(data, 'startsAt'),
      endsAt: readDateTime(data, 'endsAt'),
      isActive: readBool(data, 'isActive'),
      sortOrder: readInt(data, 'sortOrder'),
      createdAt: readDateTime(data, 'createdAt'),
      updatedAt: readDateTime(data, 'updatedAt'),
    );
  }

  FirestoreJson toFirestore() {
    return <String, Object?>{
      'title': title,
      'description': description,
      'theme': theme,
      'coverImageUrl': coverImageUrl,
      'tags': tags,
      'startsAt': timestampFromDate(startsAt),
      'endsAt': timestampFromDate(endsAt),
      'isActive': isActive,
      'sortOrder': sortOrder,
      'createdAt': timestampFromDate(createdAt),
      'updatedAt': timestampFromDate(updatedAt),
    };
  }

  StyleChallenge copyWith({
    String? id,
    String? title,
    Object? description = _unset,
    Object? theme = _unset,
    Object? coverImageUrl = _unset,
    List<String>? tags,
    DateTime? startsAt,
    DateTime? endsAt,
    bool? isActive,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StyleChallenge(
      id: id ?? this.id,
      title: title ?? this.title,
      description: identical(description, _unset)
          ? this.description
          : description as String?,
      theme: identical(theme, _unset) ? this.theme : theme as String?,
      coverImageUrl: identical(coverImageUrl, _unset)
          ? this.coverImageUrl
          : coverImageUrl as String?,
      tags: tags ?? this.tags,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is StyleChallenge &&
            other.id == id &&
            other.title == title &&
            other.description == description &&
            other.theme == theme &&
            other.coverImageUrl == coverImageUrl &&
            listEquals(other.tags, tags) &&
            other.startsAt == startsAt &&
            other.endsAt == endsAt &&
            other.isActive == isActive &&
            other.sortOrder == sortOrder &&
            other.createdAt == createdAt &&
            other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    theme,
    coverImageUrl,
    Object.hashAll(tags),
    startsAt,
    endsAt,
    isActive,
    sortOrder,
    createdAt,
    updatedAt,
  );
}

class StyleChallengeSubmission {
  StyleChallengeSubmission({
    required this.id,
    required this.userId,
    this.outfitId,
    required this.outfitSnapshot,
    this.caption,
    this.photoUrl,
    this.score = 0,
    this.voteCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String userId;
  final String? outfitId;
  final ChallengeOutfitSnapshot outfitSnapshot;
  final String? caption;
  final String? photoUrl;
  final int score;
  final int voteCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory StyleChallengeSubmission.fromFirestore(
    FirestoreSnapshot snapshot,
    Object? options,
  ) {
    final data = snapshotData(snapshot);
    return StyleChallengeSubmission(
      id: snapshot.id,
      userId: readString(data, 'userId'),
      outfitId: readOptionalString(data, 'outfitId'),
      outfitSnapshot: ChallengeOutfitSnapshot.fromMap(
        mapFromObject(data['outfitSnapshot'], fieldName: 'outfitSnapshot'),
      ),
      caption: readOptionalString(data, 'caption'),
      photoUrl: readOptionalString(data, 'photoUrl'),
      score: readInt(data, 'score'),
      voteCount: readInt(data, 'voteCount'),
      createdAt: readDateTime(data, 'createdAt'),
      updatedAt: readDateTime(data, 'updatedAt'),
    );
  }

  FirestoreJson toFirestore() {
    return <String, Object?>{
      'userId': userId,
      'outfitId': outfitId,
      'outfitSnapshot': outfitSnapshot.toMap(),
      'caption': caption,
      'photoUrl': photoUrl,
      'score': score,
      'voteCount': voteCount,
      'createdAt': timestampFromDate(createdAt),
      'updatedAt': timestampFromDate(updatedAt),
    };
  }

  StyleChallengeSubmission copyWith({
    String? id,
    String? userId,
    Object? outfitId = _unset,
    ChallengeOutfitSnapshot? outfitSnapshot,
    Object? caption = _unset,
    Object? photoUrl = _unset,
    int? score,
    int? voteCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StyleChallengeSubmission(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      outfitId: identical(outfitId, _unset)
          ? this.outfitId
          : outfitId as String?,
      outfitSnapshot: outfitSnapshot ?? this.outfitSnapshot,
      caption: identical(caption, _unset) ? this.caption : caption as String?,
      photoUrl: identical(photoUrl, _unset)
          ? this.photoUrl
          : photoUrl as String?,
      score: score ?? this.score,
      voteCount: voteCount ?? this.voteCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is StyleChallengeSubmission &&
            other.id == id &&
            other.userId == userId &&
            other.outfitId == outfitId &&
            other.outfitSnapshot == outfitSnapshot &&
            other.caption == caption &&
            other.photoUrl == photoUrl &&
            other.score == score &&
            other.voteCount == voteCount &&
            other.createdAt == createdAt &&
            other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    outfitId,
    outfitSnapshot,
    caption,
    photoUrl,
    score,
    voteCount,
    createdAt,
    updatedAt,
  );
}

class ChallengeOutfitSnapshot {
  ChallengeOutfitSnapshot({
    required this.title,
    this.imageUrl,
    required List<String> itemIds,
    required List<WardrobeItemSnapshot> wardrobeSnapshots,
  }) : itemIds = List<String>.unmodifiable(itemIds),
       wardrobeSnapshots = List<WardrobeItemSnapshot>.unmodifiable(
         wardrobeSnapshots,
       );

  final String title;
  final String? imageUrl;
  final List<String> itemIds;
  final List<WardrobeItemSnapshot> wardrobeSnapshots;

  factory ChallengeOutfitSnapshot.fromMap(FirestoreJson data) {
    return ChallengeOutfitSnapshot(
      title: readString(data, 'title'),
      imageUrl: readOptionalString(data, 'imageUrl'),
      itemIds: readStringList(data, 'itemIds'),
      wardrobeSnapshots: mapListFromObject(
        data['wardrobeSnapshots'],
        fieldName: 'wardrobeSnapshots',
      ).map(WardrobeItemSnapshot.fromMap).toList(growable: false),
    );
  }

  FirestoreJson toMap() {
    return <String, Object?>{
      'title': title,
      'imageUrl': imageUrl,
      'itemIds': itemIds,
      'wardrobeSnapshots': wardrobeSnapshots
          .map((snapshot) => snapshot.toMap())
          .toList(growable: false),
    };
  }

  ChallengeOutfitSnapshot copyWith({
    String? title,
    Object? imageUrl = _unset,
    List<String>? itemIds,
    List<WardrobeItemSnapshot>? wardrobeSnapshots,
  }) {
    return ChallengeOutfitSnapshot(
      title: title ?? this.title,
      imageUrl: identical(imageUrl, _unset)
          ? this.imageUrl
          : imageUrl as String?,
      itemIds: itemIds ?? this.itemIds,
      wardrobeSnapshots: wardrobeSnapshots ?? this.wardrobeSnapshots,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ChallengeOutfitSnapshot &&
            other.title == title &&
            other.imageUrl == imageUrl &&
            listEquals(other.itemIds, itemIds) &&
            listEquals(other.wardrobeSnapshots, wardrobeSnapshots);
  }

  @override
  int get hashCode => Object.hash(
    title,
    imageUrl,
    Object.hashAll(itemIds),
    Object.hashAll(wardrobeSnapshots),
  );
}
