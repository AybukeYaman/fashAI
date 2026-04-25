import 'package:fashai/src/core/firestore/firestore_model_utils.dart';
import 'package:flutter/foundation.dart';

const Object _unset = Object();

class Brand {
  Brand({
    required this.id,
    required this.name,
    this.slug,
    this.description,
    this.logoUrl,
    this.websiteUrl,
    this.country,
    List<String> categories = const <String>[],
    this.isActive = false,
    this.affiliateEnabled = false,
    required this.createdAt,
    required this.updatedAt,
  }) : categories = List<String>.unmodifiable(categories);

  final String id;
  final String name;
  final String? slug;
  final String? description;
  final String? logoUrl;
  final String? websiteUrl;
  final String? country;
  final List<String> categories;
  final bool isActive;
  final bool affiliateEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Brand.fromFirestore(FirestoreSnapshot snapshot, Object? options) {
    final data = snapshotData(snapshot);
    return Brand(
      id: snapshot.id,
      name: readString(data, 'name'),
      slug: readOptionalString(data, 'slug'),
      description: readOptionalString(data, 'description'),
      logoUrl: readOptionalString(data, 'logoUrl'),
      websiteUrl: readOptionalString(data, 'websiteUrl'),
      country: readOptionalString(data, 'country'),
      categories: readStringList(data, 'categories'),
      isActive: readBool(data, 'isActive'),
      affiliateEnabled: readBool(data, 'affiliateEnabled'),
      createdAt: readDateTime(data, 'createdAt'),
      updatedAt: readDateTime(data, 'updatedAt'),
    );
  }

  FirestoreJson toFirestore() {
    return <String, Object?>{
      'name': name,
      'slug': slug,
      'description': description,
      'logoUrl': logoUrl,
      'websiteUrl': websiteUrl,
      'country': country,
      'categories': categories,
      'isActive': isActive,
      'affiliateEnabled': affiliateEnabled,
      'createdAt': timestampFromDate(createdAt),
      'updatedAt': timestampFromDate(updatedAt),
    };
  }

  Brand copyWith({
    String? id,
    String? name,
    Object? slug = _unset,
    Object? description = _unset,
    Object? logoUrl = _unset,
    Object? websiteUrl = _unset,
    Object? country = _unset,
    List<String>? categories,
    bool? isActive,
    bool? affiliateEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Brand(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: identical(slug, _unset) ? this.slug : slug as String?,
      description: identical(description, _unset)
          ? this.description
          : description as String?,
      logoUrl: identical(logoUrl, _unset) ? this.logoUrl : logoUrl as String?,
      websiteUrl: identical(websiteUrl, _unset)
          ? this.websiteUrl
          : websiteUrl as String?,
      country: identical(country, _unset) ? this.country : country as String?,
      categories: categories ?? this.categories,
      isActive: isActive ?? this.isActive,
      affiliateEnabled: affiliateEnabled ?? this.affiliateEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Brand &&
            other.id == id &&
            other.name == name &&
            other.slug == slug &&
            other.description == description &&
            other.logoUrl == logoUrl &&
            other.websiteUrl == websiteUrl &&
            other.country == country &&
            listEquals(other.categories, categories) &&
            other.isActive == isActive &&
            other.affiliateEnabled == affiliateEnabled &&
            other.createdAt == createdAt &&
            other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    slug,
    description,
    logoUrl,
    websiteUrl,
    country,
    Object.hashAll(categories),
    isActive,
    affiliateEnabled,
    createdAt,
    updatedAt,
  );
}
