import 'package:fashai/src/core/firestore/firestore_model_utils.dart';
import 'package:flutter/foundation.dart';

const Object _unset = Object();

class Trend {
  Trend({
    required this.id,
    required this.title,
    this.description,
    required this.region,
    this.season,
    this.category,
    List<String> tags = const <String>[],
    this.imageUrl,
    this.sourceUrl,
    this.score,
    this.isActive = false,
    this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
  }) : tags = List<String>.unmodifiable(tags);

  final String id;
  final String title;
  final String? description;
  final String region;
  final String? season;
  final String? category;
  final List<String> tags;
  final String? imageUrl;
  final String? sourceUrl;
  final double? score;
  final bool isActive;
  final DateTime? publishedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Trend.fromFirestore(FirestoreSnapshot snapshot, Object? options) {
    final data = snapshotData(snapshot);
    return Trend(
      id: snapshot.id,
      title: readString(data, 'title'),
      description: readOptionalString(data, 'description'),
      region: readString(data, 'region', fallback: 'TR'),
      season: readOptionalString(data, 'season'),
      category: readOptionalString(data, 'category'),
      tags: readStringList(data, 'tags'),
      imageUrl: readOptionalString(data, 'imageUrl'),
      sourceUrl: readOptionalString(data, 'sourceUrl'),
      score: readOptionalDouble(data, 'score'),
      isActive: readBool(data, 'isActive'),
      publishedAt: readOptionalDateTime(data, 'publishedAt'),
      createdAt: readDateTime(data, 'createdAt'),
      updatedAt: readDateTime(data, 'updatedAt'),
    );
  }

  FirestoreJson toFirestore() {
    return <String, Object?>{
      'title': title,
      'description': description,
      'region': region,
      'season': season,
      'category': category,
      'tags': tags,
      'imageUrl': imageUrl,
      'sourceUrl': sourceUrl,
      'score': score,
      'isActive': isActive,
      'publishedAt': optionalTimestampFromDate(publishedAt),
      'createdAt': timestampFromDate(createdAt),
      'updatedAt': timestampFromDate(updatedAt),
    };
  }

  Trend copyWith({
    String? id,
    String? title,
    Object? description = _unset,
    String? region,
    Object? season = _unset,
    Object? category = _unset,
    List<String>? tags,
    Object? imageUrl = _unset,
    Object? sourceUrl = _unset,
    Object? score = _unset,
    bool? isActive,
    Object? publishedAt = _unset,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Trend(
      id: id ?? this.id,
      title: title ?? this.title,
      description: identical(description, _unset)
          ? this.description
          : description as String?,
      region: region ?? this.region,
      season: identical(season, _unset) ? this.season : season as String?,
      category: identical(category, _unset)
          ? this.category
          : category as String?,
      tags: tags ?? this.tags,
      imageUrl: identical(imageUrl, _unset)
          ? this.imageUrl
          : imageUrl as String?,
      sourceUrl: identical(sourceUrl, _unset)
          ? this.sourceUrl
          : sourceUrl as String?,
      score: identical(score, _unset) ? this.score : score as double?,
      isActive: isActive ?? this.isActive,
      publishedAt: identical(publishedAt, _unset)
          ? this.publishedAt
          : publishedAt as DateTime?,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Trend &&
            other.id == id &&
            other.title == title &&
            other.description == description &&
            other.region == region &&
            other.season == season &&
            other.category == category &&
            listEquals(other.tags, tags) &&
            other.imageUrl == imageUrl &&
            other.sourceUrl == sourceUrl &&
            other.score == score &&
            other.isActive == isActive &&
            other.publishedAt == publishedAt &&
            other.createdAt == createdAt &&
            other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    region,
    season,
    category,
    Object.hashAll(tags),
    imageUrl,
    sourceUrl,
    score,
    isActive,
    publishedAt,
    createdAt,
    updatedAt,
  );
}
