import 'package:fashai/src/core/firestore/firestore_model_utils.dart';
import 'package:flutter/foundation.dart';

const Object _unset = Object();

class WardrobeItem {
  WardrobeItem({
    required this.id,
    required this.name,
    required this.category,
    required List<String> colors,
    required List<String> tags,
    required this.imageUrl,
    required this.storagePath,
    this.brand,
    this.size,
    this.material,
    this.season,
    this.notes,
    List<String> detectedLabels = const <String>[],
    this.detectionConfidence,
    this.wearCount = 0,
    this.lastWornAt,
    this.isFavorite = false,
    this.isArchived = false,
    required this.createdAt,
    required this.updatedAt,
  }) : colors = List<String>.unmodifiable(colors),
       tags = List<String>.unmodifiable(tags),
       detectedLabels = List<String>.unmodifiable(detectedLabels);

  final String id;
  final String name;
  final String category;
  final List<String> colors;
  final List<String> tags;
  final String imageUrl;
  final String storagePath;
  final String? brand;
  final String? size;
  final String? material;
  final String? season;
  final String? notes;
  final List<String> detectedLabels;
  final double? detectionConfidence;
  final int wearCount;
  final DateTime? lastWornAt;
  final bool isFavorite;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory WardrobeItem.fromFirestore(
    FirestoreSnapshot snapshot,
    Object? options,
  ) {
    return WardrobeItem.fromMap(snapshot.id, snapshotData(snapshot));
  }

  factory WardrobeItem.fromMap(String id, FirestoreJson data) {
    return WardrobeItem(
      id: id,
      name: readString(data, 'name'),
      category: readString(data, 'category'),
      colors: readStringList(data, 'colors'),
      tags: readStringList(data, 'tags'),
      imageUrl: readString(data, 'imageUrl'),
      storagePath: readString(data, 'storagePath'),
      brand: readOptionalString(data, 'brand'),
      size: readOptionalString(data, 'size'),
      material: readOptionalString(data, 'material'),
      season: readOptionalString(data, 'season'),
      notes: readOptionalString(data, 'notes'),
      detectedLabels: readStringList(data, 'detectedLabels'),
      detectionConfidence: readOptionalDouble(data, 'detectionConfidence'),
      wearCount: readInt(data, 'wearCount'),
      lastWornAt: readOptionalDateTime(data, 'lastWornAt'),
      isFavorite: readBool(data, 'isFavorite'),
      isArchived: readBool(data, 'isArchived'),
      createdAt: readDateTime(data, 'createdAt'),
      updatedAt: readDateTime(data, 'updatedAt'),
    );
  }

  FirestoreJson toFirestore() {
    return <String, Object?>{
      'name': name,
      'category': category,
      'colors': colors,
      'tags': tags,
      'imageUrl': imageUrl,
      'storagePath': storagePath,
      'brand': brand,
      'size': size,
      'material': material,
      'season': season,
      'notes': notes,
      'detectedLabels': detectedLabels,
      'detectionConfidence': detectionConfidence,
      'wearCount': wearCount,
      'lastWornAt': optionalTimestampFromDate(lastWornAt),
      'isFavorite': isFavorite,
      'isArchived': isArchived,
      'createdAt': timestampFromDate(createdAt),
      'updatedAt': timestampFromDate(updatedAt),
    };
  }

  WardrobeItemSnapshot toSnapshot({DateTime? capturedAt}) {
    return WardrobeItemSnapshot(
      id: id,
      name: name,
      category: category,
      colors: colors,
      tags: tags,
      imageUrl: imageUrl,
      storagePath: storagePath,
      brand: brand,
      size: size,
      capturedAt: capturedAt ?? DateTime.now().toUtc(),
    );
  }

  WardrobeItem copyWith({
    String? id,
    String? name,
    String? category,
    List<String>? colors,
    List<String>? tags,
    String? imageUrl,
    String? storagePath,
    Object? brand = _unset,
    Object? size = _unset,
    Object? material = _unset,
    Object? season = _unset,
    Object? notes = _unset,
    List<String>? detectedLabels,
    Object? detectionConfidence = _unset,
    int? wearCount,
    Object? lastWornAt = _unset,
    bool? isFavorite,
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WardrobeItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      colors: colors ?? this.colors,
      tags: tags ?? this.tags,
      imageUrl: imageUrl ?? this.imageUrl,
      storagePath: storagePath ?? this.storagePath,
      brand: identical(brand, _unset) ? this.brand : brand as String?,
      size: identical(size, _unset) ? this.size : size as String?,
      material: identical(material, _unset)
          ? this.material
          : material as String?,
      season: identical(season, _unset) ? this.season : season as String?,
      notes: identical(notes, _unset) ? this.notes : notes as String?,
      detectedLabels: detectedLabels ?? this.detectedLabels,
      detectionConfidence: identical(detectionConfidence, _unset)
          ? this.detectionConfidence
          : detectionConfidence as double?,
      wearCount: wearCount ?? this.wearCount,
      lastWornAt: identical(lastWornAt, _unset)
          ? this.lastWornAt
          : lastWornAt as DateTime?,
      isFavorite: isFavorite ?? this.isFavorite,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is WardrobeItem &&
            other.id == id &&
            other.name == name &&
            other.category == category &&
            listEquals(other.colors, colors) &&
            listEquals(other.tags, tags) &&
            other.imageUrl == imageUrl &&
            other.storagePath == storagePath &&
            other.brand == brand &&
            other.size == size &&
            other.material == material &&
            other.season == season &&
            other.notes == notes &&
            listEquals(other.detectedLabels, detectedLabels) &&
            other.detectionConfidence == detectionConfidence &&
            other.wearCount == wearCount &&
            other.lastWornAt == lastWornAt &&
            other.isFavorite == isFavorite &&
            other.isArchived == isArchived &&
            other.createdAt == createdAt &&
            other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    category,
    Object.hashAll(colors),
    Object.hashAll(tags),
    imageUrl,
    storagePath,
    brand,
    size,
    material,
    season,
    notes,
    Object.hashAll(detectedLabels),
    detectionConfidence,
    wearCount,
    lastWornAt,
    isFavorite,
    isArchived,
    createdAt,
    updatedAt,
  );
}

class WardrobeItemSnapshot {
  WardrobeItemSnapshot({
    required this.id,
    required this.name,
    required this.category,
    required List<String> colors,
    required List<String> tags,
    required this.imageUrl,
    this.storagePath,
    this.brand,
    this.size,
    required this.capturedAt,
  }) : colors = List<String>.unmodifiable(colors),
       tags = List<String>.unmodifiable(tags);

  final String id;
  final String name;
  final String category;
  final List<String> colors;
  final List<String> tags;
  final String imageUrl;
  final String? storagePath;
  final String? brand;
  final String? size;
  final DateTime capturedAt;

  factory WardrobeItemSnapshot.fromMap(FirestoreJson data) {
    return WardrobeItemSnapshot(
      id: readString(data, 'id'),
      name: readString(data, 'name'),
      category: readString(data, 'category'),
      colors: readStringList(data, 'colors'),
      tags: readStringList(data, 'tags'),
      imageUrl: readString(data, 'imageUrl'),
      storagePath: readOptionalString(data, 'storagePath'),
      brand: readOptionalString(data, 'brand'),
      size: readOptionalString(data, 'size'),
      capturedAt: readDateTime(data, 'capturedAt'),
    );
  }

  FirestoreJson toMap() {
    return <String, Object?>{
      'id': id,
      'name': name,
      'category': category,
      'colors': colors,
      'tags': tags,
      'imageUrl': imageUrl,
      'storagePath': storagePath,
      'brand': brand,
      'size': size,
      'capturedAt': timestampFromDate(capturedAt),
    };
  }

  WardrobeItemSnapshot copyWith({
    String? id,
    String? name,
    String? category,
    List<String>? colors,
    List<String>? tags,
    String? imageUrl,
    Object? storagePath = _unset,
    Object? brand = _unset,
    Object? size = _unset,
    DateTime? capturedAt,
  }) {
    return WardrobeItemSnapshot(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      colors: colors ?? this.colors,
      tags: tags ?? this.tags,
      imageUrl: imageUrl ?? this.imageUrl,
      storagePath: identical(storagePath, _unset)
          ? this.storagePath
          : storagePath as String?,
      brand: identical(brand, _unset) ? this.brand : brand as String?,
      size: identical(size, _unset) ? this.size : size as String?,
      capturedAt: capturedAt ?? this.capturedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is WardrobeItemSnapshot &&
            other.id == id &&
            other.name == name &&
            other.category == category &&
            listEquals(other.colors, colors) &&
            listEquals(other.tags, tags) &&
            other.imageUrl == imageUrl &&
            other.storagePath == storagePath &&
            other.brand == brand &&
            other.size == size &&
            other.capturedAt == capturedAt;
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    category,
    Object.hashAll(colors),
    Object.hashAll(tags),
    imageUrl,
    storagePath,
    brand,
    size,
    capturedAt,
  );
}
