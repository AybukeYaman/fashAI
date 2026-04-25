import 'package:fashai/src/core/firestore/firestore_model_utils.dart';
import 'package:flutter/foundation.dart';

const Object _unset = Object();

class OutfitFeedback {
  OutfitFeedback({
    required this.id,
    this.userId,
    required this.outfitId,
    this.recommendationId,
    this.recommendationDate,
    required this.rating,
    required this.woreIt,
    List<String> selectedItemIds = const <String>[],
    this.notes,
    this.source,
    required this.createdAt,
  }) : selectedItemIds = List<String>.unmodifiable(selectedItemIds);

  final String id;
  final String? userId;
  final String outfitId;
  final String? recommendationId;
  final String? recommendationDate;
  final int rating;
  final bool woreIt;
  final List<String> selectedItemIds;
  final String? notes;
  final String? source;
  final DateTime createdAt;

  factory OutfitFeedback.fromFirestore(
    FirestoreSnapshot snapshot,
    Object? options,
  ) {
    final data = snapshotData(snapshot);
    return OutfitFeedback(
      id: snapshot.id,
      userId: readOptionalString(data, 'userId'),
      outfitId: readString(data, 'outfitId'),
      recommendationId: readOptionalString(data, 'recommendationId'),
      recommendationDate: readOptionalString(data, 'recommendationDate'),
      rating: readInt(data, 'rating'),
      woreIt: readBool(data, 'woreIt'),
      selectedItemIds: readStringList(data, 'selectedItemIds'),
      notes: readOptionalString(data, 'notes'),
      source: readOptionalString(data, 'source'),
      createdAt: readDateTime(data, 'createdAt'),
    );
  }

  FirestoreJson toFirestore() {
    return <String, Object?>{
      'userId': userId,
      'outfitId': outfitId,
      'recommendationId': recommendationId,
      'recommendationDate': recommendationDate,
      'rating': rating,
      'woreIt': woreIt,
      'selectedItemIds': selectedItemIds,
      'notes': notes,
      'source': source,
      'createdAt': timestampFromDate(createdAt),
    };
  }

  OutfitFeedback copyWith({
    String? id,
    Object? userId = _unset,
    String? outfitId,
    Object? recommendationId = _unset,
    Object? recommendationDate = _unset,
    int? rating,
    bool? woreIt,
    List<String>? selectedItemIds,
    Object? notes = _unset,
    Object? source = _unset,
    DateTime? createdAt,
  }) {
    return OutfitFeedback(
      id: id ?? this.id,
      userId: identical(userId, _unset) ? this.userId : userId as String?,
      outfitId: outfitId ?? this.outfitId,
      recommendationId: identical(recommendationId, _unset)
          ? this.recommendationId
          : recommendationId as String?,
      recommendationDate: identical(recommendationDate, _unset)
          ? this.recommendationDate
          : recommendationDate as String?,
      rating: rating ?? this.rating,
      woreIt: woreIt ?? this.woreIt,
      selectedItemIds: selectedItemIds ?? this.selectedItemIds,
      notes: identical(notes, _unset) ? this.notes : notes as String?,
      source: identical(source, _unset) ? this.source : source as String?,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is OutfitFeedback &&
            other.id == id &&
            other.userId == userId &&
            other.outfitId == outfitId &&
            other.recommendationId == recommendationId &&
            other.recommendationDate == recommendationDate &&
            other.rating == rating &&
            other.woreIt == woreIt &&
            listEquals(other.selectedItemIds, selectedItemIds) &&
            other.notes == notes &&
            other.source == source &&
            other.createdAt == createdAt;
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    outfitId,
    recommendationId,
    recommendationDate,
    rating,
    woreIt,
    Object.hashAll(selectedItemIds),
    notes,
    source,
    createdAt,
  );
}
