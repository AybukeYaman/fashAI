import 'package:fashai/src/core/firestore/firestore_model_utils.dart';
import 'package:flutter/foundation.dart';

const Object _unset = Object();

class CapsuleCollection {
  CapsuleCollection({
    required this.id,
    required this.title,
    this.subtitle,
    this.description,
    this.brandId,
    this.category,
    this.region,
    this.coverImageUrl,
    this.heroImageUrl,
    List<String> tags = const <String>[],
    List<CapsuleItem> items = const <CapsuleItem>[],
    this.itemCount = 0,
    this.isActive = false,
    this.sortOrder = 0,
    this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
  }) : tags = List<String>.unmodifiable(tags),
       items = List<CapsuleItem>.unmodifiable(items);

  final String id;
  final String title;
  final String? subtitle;
  final String? description;
  final String? brandId;
  final String? category;
  final String? region;
  final String? coverImageUrl;
  final String? heroImageUrl;
  final List<String> tags;
  final List<CapsuleItem> items;
  final int itemCount;
  final bool isActive;
  final int sortOrder;
  final DateTime? publishedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory CapsuleCollection.fromFirestore(
    FirestoreSnapshot snapshot,
    Object? options,
  ) {
    final data = snapshotData(snapshot);
    return CapsuleCollection(
      id: snapshot.id,
      title: readString(data, 'title'),
      subtitle: readOptionalString(data, 'subtitle'),
      description: readOptionalString(data, 'description'),
      brandId: readOptionalString(data, 'brandId'),
      category: readOptionalString(data, 'category'),
      region: readOptionalString(data, 'region'),
      coverImageUrl: readOptionalString(data, 'coverImageUrl'),
      heroImageUrl: readOptionalString(data, 'heroImageUrl'),
      tags: readStringList(data, 'tags'),
      items: mapListFromObject(
        data['items'],
        fieldName: 'items',
      ).map(CapsuleItem.fromMap).toList(growable: false),
      itemCount: readInt(data, 'itemCount'),
      isActive: readBool(data, 'isActive'),
      sortOrder: readInt(data, 'sortOrder'),
      publishedAt: readOptionalDateTime(data, 'publishedAt'),
      createdAt: readDateTime(data, 'createdAt'),
      updatedAt: readDateTime(data, 'updatedAt'),
    );
  }

  FirestoreJson toFirestore() {
    return <String, Object?>{
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'brandId': brandId,
      'category': category,
      'region': region,
      'coverImageUrl': coverImageUrl,
      'heroImageUrl': heroImageUrl,
      'tags': tags,
      'items': items.map((item) => item.toMap()).toList(growable: false),
      'itemCount': itemCount,
      'isActive': isActive,
      'sortOrder': sortOrder,
      'publishedAt': optionalTimestampFromDate(publishedAt),
      'createdAt': timestampFromDate(createdAt),
      'updatedAt': timestampFromDate(updatedAt),
    };
  }

  CapsuleCollection copyWith({
    String? id,
    String? title,
    Object? subtitle = _unset,
    Object? description = _unset,
    Object? brandId = _unset,
    Object? category = _unset,
    Object? region = _unset,
    Object? coverImageUrl = _unset,
    Object? heroImageUrl = _unset,
    List<String>? tags,
    List<CapsuleItem>? items,
    int? itemCount,
    bool? isActive,
    int? sortOrder,
    Object? publishedAt = _unset,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CapsuleCollection(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: identical(subtitle, _unset)
          ? this.subtitle
          : subtitle as String?,
      description: identical(description, _unset)
          ? this.description
          : description as String?,
      brandId: identical(brandId, _unset) ? this.brandId : brandId as String?,
      category: identical(category, _unset)
          ? this.category
          : category as String?,
      region: identical(region, _unset) ? this.region : region as String?,
      coverImageUrl: identical(coverImageUrl, _unset)
          ? this.coverImageUrl
          : coverImageUrl as String?,
      heroImageUrl: identical(heroImageUrl, _unset)
          ? this.heroImageUrl
          : heroImageUrl as String?,
      tags: tags ?? this.tags,
      items: items ?? this.items,
      itemCount: itemCount ?? this.itemCount,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
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
        other is CapsuleCollection &&
            other.id == id &&
            other.title == title &&
            other.subtitle == subtitle &&
            other.description == description &&
            other.brandId == brandId &&
            other.category == category &&
            other.region == region &&
            other.coverImageUrl == coverImageUrl &&
            other.heroImageUrl == heroImageUrl &&
            listEquals(other.tags, tags) &&
            listEquals(other.items, items) &&
            other.itemCount == itemCount &&
            other.isActive == isActive &&
            other.sortOrder == sortOrder &&
            other.publishedAt == publishedAt &&
            other.createdAt == createdAt &&
            other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    title,
    subtitle,
    description,
    brandId,
    category,
    region,
    coverImageUrl,
    heroImageUrl,
    Object.hashAll(tags),
    Object.hashAll(items),
    itemCount,
    isActive,
    sortOrder,
    publishedAt,
    createdAt,
    updatedAt,
  ]);
}

class CapsuleItem {
  CapsuleItem({
    required this.id,
    this.brandId,
    required this.name,
    required this.category,
    this.imageUrl,
    this.productUrl,
    this.priceTry,
    this.currency = 'TRY',
    this.affiliateEnabled = false,
    this.colorHex,
    List<String> tags = const <String>[],
  }) : tags = List<String>.unmodifiable(tags);

  final String id;
  final String? brandId;
  final String name;
  final String category;
  final String? imageUrl;
  final String? productUrl;
  final double? priceTry;
  final String currency;
  final bool affiliateEnabled;
  final String? colorHex;
  final List<String> tags;

  factory CapsuleItem.fromMap(FirestoreJson data) {
    return CapsuleItem(
      id: readString(data, 'id'),
      brandId: readOptionalString(data, 'brandId'),
      name: readString(data, 'name'),
      category: readString(data, 'category'),
      imageUrl: readOptionalString(data, 'imageUrl'),
      productUrl: readOptionalString(data, 'productUrl'),
      priceTry: readOptionalDouble(data, 'priceTry'),
      currency: readString(data, 'currency', fallback: 'TRY'),
      affiliateEnabled: readBool(data, 'affiliateEnabled'),
      colorHex: readOptionalString(data, 'colorHex'),
      tags: readStringList(data, 'tags'),
    );
  }

  FirestoreJson toMap() {
    return <String, Object?>{
      'id': id,
      'brandId': brandId,
      'name': name,
      'category': category,
      'imageUrl': imageUrl,
      'productUrl': productUrl,
      'priceTry': priceTry,
      'currency': currency,
      'affiliateEnabled': affiliateEnabled,
      'colorHex': colorHex,
      'tags': tags,
    };
  }

  CapsuleItem copyWith({
    String? id,
    Object? brandId = _unset,
    String? name,
    String? category,
    Object? imageUrl = _unset,
    Object? productUrl = _unset,
    Object? priceTry = _unset,
    String? currency,
    bool? affiliateEnabled,
    Object? colorHex = _unset,
    List<String>? tags,
  }) {
    return CapsuleItem(
      id: id ?? this.id,
      brandId: identical(brandId, _unset) ? this.brandId : brandId as String?,
      name: name ?? this.name,
      category: category ?? this.category,
      imageUrl: identical(imageUrl, _unset)
          ? this.imageUrl
          : imageUrl as String?,
      productUrl: identical(productUrl, _unset)
          ? this.productUrl
          : productUrl as String?,
      priceTry: identical(priceTry, _unset)
          ? this.priceTry
          : priceTry as double?,
      currency: currency ?? this.currency,
      affiliateEnabled: affiliateEnabled ?? this.affiliateEnabled,
      colorHex: identical(colorHex, _unset)
          ? this.colorHex
          : colorHex as String?,
      tags: tags ?? this.tags,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CapsuleItem &&
            other.id == id &&
            other.brandId == brandId &&
            other.name == name &&
            other.category == category &&
            other.imageUrl == imageUrl &&
            other.productUrl == productUrl &&
            other.priceTry == priceTry &&
            other.currency == currency &&
            other.affiliateEnabled == affiliateEnabled &&
            other.colorHex == colorHex &&
            listEquals(other.tags, tags);
  }

  @override
  int get hashCode => Object.hash(
    id,
    brandId,
    name,
    category,
    imageUrl,
    productUrl,
    priceTry,
    currency,
    affiliateEnabled,
    colorHex,
    Object.hashAll(tags),
  );
}
