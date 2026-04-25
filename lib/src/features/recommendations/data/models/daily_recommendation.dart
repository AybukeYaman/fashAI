import 'package:fashai/src/core/firestore/firestore_model_utils.dart';
import 'package:fashai/src/features/wardrobe/data/models/wardrobe_item.dart';
import 'package:flutter/foundation.dart';

const Object _unset = Object();

class DailyRecommendation {
  DailyRecommendation({
    required this.id,
    required this.dateKey,
    required this.timezone,
    this.status = 'generated',
    List<RecommendedOutfit> outfits = const <RecommendedOutfit>[],
    this.weather,
    this.context,
    this.selectedOutfitId,
    this.feedbackSubmitted = false,
    this.modelVersion,
    this.failureReason,
    required this.generatedAt,
    this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
  }) : outfits = List<RecommendedOutfit>.unmodifiable(outfits);

  final String id;
  final String dateKey;
  final String timezone;
  final String status;
  final List<RecommendedOutfit> outfits;
  final WeatherSnapshot? weather;
  final RecommendationContext? context;
  final String? selectedOutfitId;
  final bool feedbackSubmitted;
  final String? modelVersion;
  final String? failureReason;
  final DateTime generatedAt;
  final DateTime? expiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory DailyRecommendation.fromFirestore(
    FirestoreSnapshot snapshot,
    Object? options,
  ) {
    final data = snapshotData(snapshot);
    return DailyRecommendation(
      id: snapshot.id,
      dateKey: readString(data, 'dateKey', fallback: snapshot.id),
      timezone: readString(data, 'timezone', fallback: 'Europe/Istanbul'),
      status: readString(data, 'status', fallback: 'generated'),
      outfits: mapListFromObject(
        data['outfits'],
        fieldName: 'outfits',
      ).map(RecommendedOutfit.fromMap).toList(growable: false),
      weather: data['weather'] == null
          ? null
          : WeatherSnapshot.fromMap(
              mapFromObject(data['weather'], fieldName: 'weather'),
            ),
      context: data['context'] == null
          ? null
          : RecommendationContext.fromMap(
              mapFromObject(data['context'], fieldName: 'context'),
            ),
      selectedOutfitId: readOptionalString(data, 'selectedOutfitId'),
      feedbackSubmitted: readBool(data, 'feedbackSubmitted'),
      modelVersion: readOptionalString(data, 'modelVersion'),
      failureReason: readOptionalString(data, 'failureReason'),
      generatedAt: readDateTime(data, 'generatedAt'),
      expiresAt: readOptionalDateTime(data, 'expiresAt'),
      createdAt: readDateTime(data, 'createdAt'),
      updatedAt: readDateTime(data, 'updatedAt'),
    );
  }

  FirestoreJson toFirestore() {
    return <String, Object?>{
      'dateKey': dateKey,
      'timezone': timezone,
      'status': status,
      'outfits': outfits
          .map((outfit) => outfit.toMap())
          .toList(growable: false),
      'weather': weather?.toMap(),
      'context': context?.toMap(),
      'selectedOutfitId': selectedOutfitId,
      'feedbackSubmitted': feedbackSubmitted,
      'modelVersion': modelVersion,
      'failureReason': failureReason,
      'generatedAt': timestampFromDate(generatedAt),
      'expiresAt': optionalTimestampFromDate(expiresAt),
      'createdAt': timestampFromDate(createdAt),
      'updatedAt': timestampFromDate(updatedAt),
    };
  }

  DailyRecommendation copyWith({
    String? id,
    String? dateKey,
    String? timezone,
    String? status,
    List<RecommendedOutfit>? outfits,
    Object? weather = _unset,
    Object? context = _unset,
    Object? selectedOutfitId = _unset,
    bool? feedbackSubmitted,
    Object? modelVersion = _unset,
    Object? failureReason = _unset,
    DateTime? generatedAt,
    Object? expiresAt = _unset,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DailyRecommendation(
      id: id ?? this.id,
      dateKey: dateKey ?? this.dateKey,
      timezone: timezone ?? this.timezone,
      status: status ?? this.status,
      outfits: outfits ?? this.outfits,
      weather: identical(weather, _unset)
          ? this.weather
          : weather as WeatherSnapshot?,
      context: identical(context, _unset)
          ? this.context
          : context as RecommendationContext?,
      selectedOutfitId: identical(selectedOutfitId, _unset)
          ? this.selectedOutfitId
          : selectedOutfitId as String?,
      feedbackSubmitted: feedbackSubmitted ?? this.feedbackSubmitted,
      modelVersion: identical(modelVersion, _unset)
          ? this.modelVersion
          : modelVersion as String?,
      failureReason: identical(failureReason, _unset)
          ? this.failureReason
          : failureReason as String?,
      generatedAt: generatedAt ?? this.generatedAt,
      expiresAt: identical(expiresAt, _unset)
          ? this.expiresAt
          : expiresAt as DateTime?,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is DailyRecommendation &&
            other.id == id &&
            other.dateKey == dateKey &&
            other.timezone == timezone &&
            other.status == status &&
            listEquals(other.outfits, outfits) &&
            other.weather == weather &&
            other.context == context &&
            other.selectedOutfitId == selectedOutfitId &&
            other.feedbackSubmitted == feedbackSubmitted &&
            other.modelVersion == modelVersion &&
            other.failureReason == failureReason &&
            other.generatedAt == generatedAt &&
            other.expiresAt == expiresAt &&
            other.createdAt == createdAt &&
            other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
    id,
    dateKey,
    timezone,
    status,
    Object.hashAll(outfits),
    weather,
    context,
    selectedOutfitId,
    feedbackSubmitted,
    modelVersion,
    failureReason,
    generatedAt,
    expiresAt,
    createdAt,
    updatedAt,
  );
}

class RecommendedOutfit {
  RecommendedOutfit({
    required this.id,
    required this.title,
    this.description,
    this.occasion,
    required List<String> itemIds,
    required List<WardrobeItemSnapshot> wardrobeSnapshots,
    required this.reason,
    this.imageUrl,
    this.confidence,
    List<String> tags = const <String>[],
  }) : itemIds = List<String>.unmodifiable(itemIds),
       wardrobeSnapshots = List<WardrobeItemSnapshot>.unmodifiable(
         wardrobeSnapshots,
       ),
       tags = List<String>.unmodifiable(tags);

  final String id;
  final String title;
  final String? description;
  final String? occasion;
  final List<String> itemIds;
  final List<WardrobeItemSnapshot> wardrobeSnapshots;
  final String reason;
  final String? imageUrl;
  final double? confidence;
  final List<String> tags;

  factory RecommendedOutfit.fromMap(FirestoreJson data) {
    return RecommendedOutfit(
      id: readString(data, 'id'),
      title: readString(data, 'title'),
      description: readOptionalString(data, 'description'),
      occasion: readOptionalString(data, 'occasion'),
      itemIds: readStringList(data, 'itemIds'),
      wardrobeSnapshots: mapListFromObject(
        data['wardrobeSnapshots'],
        fieldName: 'wardrobeSnapshots',
      ).map(WardrobeItemSnapshot.fromMap).toList(growable: false),
      reason: readString(data, 'reason'),
      imageUrl: readOptionalString(data, 'imageUrl'),
      confidence: readOptionalDouble(data, 'confidence'),
      tags: readStringList(data, 'tags'),
    );
  }

  FirestoreJson toMap() {
    return <String, Object?>{
      'id': id,
      'title': title,
      'description': description,
      'occasion': occasion,
      'itemIds': itemIds,
      'wardrobeSnapshots': wardrobeSnapshots
          .map((snapshot) => snapshot.toMap())
          .toList(growable: false),
      'reason': reason,
      'imageUrl': imageUrl,
      'confidence': confidence,
      'tags': tags,
    };
  }

  RecommendedOutfit copyWith({
    String? id,
    String? title,
    Object? description = _unset,
    Object? occasion = _unset,
    List<String>? itemIds,
    List<WardrobeItemSnapshot>? wardrobeSnapshots,
    String? reason,
    Object? imageUrl = _unset,
    Object? confidence = _unset,
    List<String>? tags,
  }) {
    return RecommendedOutfit(
      id: id ?? this.id,
      title: title ?? this.title,
      description: identical(description, _unset)
          ? this.description
          : description as String?,
      occasion: identical(occasion, _unset)
          ? this.occasion
          : occasion as String?,
      itemIds: itemIds ?? this.itemIds,
      wardrobeSnapshots: wardrobeSnapshots ?? this.wardrobeSnapshots,
      reason: reason ?? this.reason,
      imageUrl: identical(imageUrl, _unset)
          ? this.imageUrl
          : imageUrl as String?,
      confidence: identical(confidence, _unset)
          ? this.confidence
          : confidence as double?,
      tags: tags ?? this.tags,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RecommendedOutfit &&
            other.id == id &&
            other.title == title &&
            other.description == description &&
            other.occasion == occasion &&
            listEquals(other.itemIds, itemIds) &&
            listEquals(other.wardrobeSnapshots, wardrobeSnapshots) &&
            other.reason == reason &&
            other.imageUrl == imageUrl &&
            other.confidence == confidence &&
            listEquals(other.tags, tags);
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    occasion,
    Object.hashAll(itemIds),
    Object.hashAll(wardrobeSnapshots),
    reason,
    imageUrl,
    confidence,
    Object.hashAll(tags),
  );
}

class WeatherSnapshot {
  const WeatherSnapshot({
    this.city,
    this.condition,
    this.temperatureC,
    this.minTemperatureC,
    this.maxTemperatureC,
    this.precipitationChance,
    this.capturedAt,
  });

  final String? city;
  final String? condition;
  final double? temperatureC;
  final double? minTemperatureC;
  final double? maxTemperatureC;
  final double? precipitationChance;
  final DateTime? capturedAt;

  factory WeatherSnapshot.fromMap(FirestoreJson data) {
    return WeatherSnapshot(
      city: readOptionalString(data, 'city'),
      condition: readOptionalString(data, 'condition'),
      temperatureC: readOptionalDouble(data, 'temperatureC'),
      minTemperatureC: readOptionalDouble(data, 'minTemperatureC'),
      maxTemperatureC: readOptionalDouble(data, 'maxTemperatureC'),
      precipitationChance: readOptionalDouble(data, 'precipitationChance'),
      capturedAt: readOptionalDateTime(data, 'capturedAt'),
    );
  }

  FirestoreJson toMap() {
    return <String, Object?>{
      'city': city,
      'condition': condition,
      'temperatureC': temperatureC,
      'minTemperatureC': minTemperatureC,
      'maxTemperatureC': maxTemperatureC,
      'precipitationChance': precipitationChance,
      'capturedAt': optionalTimestampFromDate(capturedAt),
    };
  }

  WeatherSnapshot copyWith({
    Object? city = _unset,
    Object? condition = _unset,
    Object? temperatureC = _unset,
    Object? minTemperatureC = _unset,
    Object? maxTemperatureC = _unset,
    Object? precipitationChance = _unset,
    Object? capturedAt = _unset,
  }) {
    return WeatherSnapshot(
      city: identical(city, _unset) ? this.city : city as String?,
      condition: identical(condition, _unset)
          ? this.condition
          : condition as String?,
      temperatureC: identical(temperatureC, _unset)
          ? this.temperatureC
          : temperatureC as double?,
      minTemperatureC: identical(minTemperatureC, _unset)
          ? this.minTemperatureC
          : minTemperatureC as double?,
      maxTemperatureC: identical(maxTemperatureC, _unset)
          ? this.maxTemperatureC
          : maxTemperatureC as double?,
      precipitationChance: identical(precipitationChance, _unset)
          ? this.precipitationChance
          : precipitationChance as double?,
      capturedAt: identical(capturedAt, _unset)
          ? this.capturedAt
          : capturedAt as DateTime?,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is WeatherSnapshot &&
            other.city == city &&
            other.condition == condition &&
            other.temperatureC == temperatureC &&
            other.minTemperatureC == minTemperatureC &&
            other.maxTemperatureC == maxTemperatureC &&
            other.precipitationChance == precipitationChance &&
            other.capturedAt == capturedAt;
  }

  @override
  int get hashCode => Object.hash(
    city,
    condition,
    temperatureC,
    minTemperatureC,
    maxTemperatureC,
    precipitationChance,
    capturedAt,
  );
}

class RecommendationContext {
  RecommendationContext({
    this.mood,
    this.cyclePhase,
    List<String> calendarEventTypes = const <String>[],
    List<String> stylePreferences = const <String>[],
  }) : calendarEventTypes = List<String>.unmodifiable(calendarEventTypes),
       stylePreferences = List<String>.unmodifiable(stylePreferences);

  final String? mood;
  final String? cyclePhase;
  final List<String> calendarEventTypes;
  final List<String> stylePreferences;

  factory RecommendationContext.fromMap(FirestoreJson data) {
    return RecommendationContext(
      mood: readOptionalString(data, 'mood'),
      cyclePhase: readOptionalString(data, 'cyclePhase'),
      calendarEventTypes: readStringList(data, 'calendarEventTypes'),
      stylePreferences: readStringList(data, 'stylePreferences'),
    );
  }

  FirestoreJson toMap() {
    return <String, Object?>{
      'mood': mood,
      'cyclePhase': cyclePhase,
      'calendarEventTypes': calendarEventTypes,
      'stylePreferences': stylePreferences,
    };
  }

  RecommendationContext copyWith({
    Object? mood = _unset,
    Object? cyclePhase = _unset,
    List<String>? calendarEventTypes,
    List<String>? stylePreferences,
  }) {
    return RecommendationContext(
      mood: identical(mood, _unset) ? this.mood : mood as String?,
      cyclePhase: identical(cyclePhase, _unset)
          ? this.cyclePhase
          : cyclePhase as String?,
      calendarEventTypes: calendarEventTypes ?? this.calendarEventTypes,
      stylePreferences: stylePreferences ?? this.stylePreferences,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RecommendationContext &&
            other.mood == mood &&
            other.cyclePhase == cyclePhase &&
            listEquals(other.calendarEventTypes, calendarEventTypes) &&
            listEquals(other.stylePreferences, stylePreferences);
  }

  @override
  int get hashCode => Object.hash(
    mood,
    cyclePhase,
    Object.hashAll(calendarEventTypes),
    Object.hashAll(stylePreferences),
  );
}
