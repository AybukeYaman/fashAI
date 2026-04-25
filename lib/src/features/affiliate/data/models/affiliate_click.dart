import 'package:fashai/src/core/firestore/firestore_model_utils.dart';
import 'package:flutter/foundation.dart';

const Object _unset = Object();

class AffiliateClick {
  AffiliateClick({
    required this.id,
    required this.userId,
    required this.brandId,
    this.capsuleCollectionId,
    this.itemId,
    required this.targetUrl,
    Map<String, String> utm = const <String, String>{},
    this.deviceLocale,
    required this.createdAt,
  }) : utm = Map<String, String>.unmodifiable(utm);

  final String id;
  final String userId;
  final String brandId;
  final String? capsuleCollectionId;
  final String? itemId;
  final String targetUrl;
  final Map<String, String> utm;
  final String? deviceLocale;
  final DateTime createdAt;

  factory AffiliateClick.fromFirestore(
    FirestoreSnapshot snapshot,
    Object? options,
  ) {
    final data = snapshotData(snapshot);
    return AffiliateClick(
      id: snapshot.id,
      userId: readString(data, 'userId'),
      brandId: readString(data, 'brandId'),
      capsuleCollectionId: readOptionalString(data, 'capsuleCollectionId'),
      itemId: readOptionalString(data, 'itemId'),
      targetUrl: readString(data, 'targetUrl'),
      utm: readStringMap(data, 'utm'),
      deviceLocale: readOptionalString(data, 'deviceLocale'),
      createdAt: readDateTime(data, 'createdAt'),
    );
  }

  FirestoreJson toFirestore() {
    return <String, Object?>{
      'userId': userId,
      'brandId': brandId,
      'capsuleCollectionId': capsuleCollectionId,
      'itemId': itemId,
      'targetUrl': targetUrl,
      'utm': utm,
      'deviceLocale': deviceLocale,
      'createdAt': timestampFromDate(createdAt),
    };
  }

  AffiliateClick copyWith({
    String? id,
    String? userId,
    String? brandId,
    Object? capsuleCollectionId = _unset,
    Object? itemId = _unset,
    String? targetUrl,
    Map<String, String>? utm,
    Object? deviceLocale = _unset,
    DateTime? createdAt,
  }) {
    return AffiliateClick(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      brandId: brandId ?? this.brandId,
      capsuleCollectionId: identical(capsuleCollectionId, _unset)
          ? this.capsuleCollectionId
          : capsuleCollectionId as String?,
      itemId: identical(itemId, _unset) ? this.itemId : itemId as String?,
      targetUrl: targetUrl ?? this.targetUrl,
      utm: utm ?? this.utm,
      deviceLocale: identical(deviceLocale, _unset)
          ? this.deviceLocale
          : deviceLocale as String?,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AffiliateClick &&
            other.id == id &&
            other.userId == userId &&
            other.brandId == brandId &&
            other.capsuleCollectionId == capsuleCollectionId &&
            other.itemId == itemId &&
            other.targetUrl == targetUrl &&
            mapEquals(other.utm, utm) &&
            other.deviceLocale == deviceLocale &&
            other.createdAt == createdAt;
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    brandId,
    capsuleCollectionId,
    itemId,
    targetUrl,
    Object.hashAllUnordered(
      utm.entries.map((entry) => Object.hash(entry.key, entry.value)),
    ),
    deviceLocale,
    createdAt,
  );
}
