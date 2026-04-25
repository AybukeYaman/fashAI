import 'package:fashai/src/core/firestore/firestore_model_utils.dart';
import 'package:flutter/foundation.dart';

const Object _unset = Object();

class UserProfile {
  UserProfile({
    required this.uid,
    this.displayName,
    this.email,
    this.photoUrl,
    this.locale,
    this.timezone,
    this.birthYear,
    this.gender,
    List<String> stylePreferences = const <String>[],
    this.colorAnalysis,
    UserConsents? consents,
    SubscriptionState? subscription,
    UserAggregates? aggregates,
    NotificationSettings? notificationSettings,
    required this.createdAt,
    required this.updatedAt,
    this.lastActiveAt,
  }) : stylePreferences = List<String>.unmodifiable(stylePreferences),
       consents = consents ?? const UserConsents(),
       subscription = subscription ?? const SubscriptionState(),
       aggregates = aggregates ?? UserAggregates(),
       notificationSettings =
           notificationSettings ?? const NotificationSettings();

  final String uid;
  final String? displayName;
  final String? email;
  final String? photoUrl;
  final String? locale;
  final String? timezone;
  final int? birthYear;
  final String? gender;
  final List<String> stylePreferences;
  final ColorAnalysis? colorAnalysis;
  final UserConsents consents;
  final SubscriptionState subscription;
  final UserAggregates aggregates;
  final NotificationSettings notificationSettings;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastActiveAt;

  factory UserProfile.fromFirestore(
    FirestoreSnapshot snapshot,
    Object? options,
  ) {
    final data = snapshotData(snapshot);
    final colorAnalysisData = data['colorAnalysis'];
    return UserProfile(
      uid: readString(data, 'uid', fallback: snapshot.id),
      displayName: readOptionalString(data, 'displayName'),
      email: readOptionalString(data, 'email'),
      photoUrl: readOptionalString(data, 'photoUrl'),
      locale: readOptionalString(data, 'locale'),
      timezone: readOptionalString(data, 'timezone'),
      birthYear: data['birthYear'] == null ? null : readInt(data, 'birthYear'),
      gender: readOptionalString(data, 'gender'),
      stylePreferences: readStringList(data, 'stylePreferences'),
      colorAnalysis: colorAnalysisData == null
          ? null
          : ColorAnalysis.fromMap(
              mapFromObject(colorAnalysisData, fieldName: 'colorAnalysis'),
            ),
      consents: UserConsents.fromMap(
        mapFromObject(data['consents'], fieldName: 'consents'),
      ),
      subscription: SubscriptionState.fromMap(
        mapFromObject(data['subscription'], fieldName: 'subscription'),
      ),
      aggregates: UserAggregates.fromMap(
        mapFromObject(data['aggregates'], fieldName: 'aggregates'),
      ),
      notificationSettings: NotificationSettings.fromMap(
        mapFromObject(
          data['notificationSettings'],
          fieldName: 'notificationSettings',
        ),
      ),
      createdAt: readDateTime(data, 'createdAt'),
      updatedAt: readDateTime(data, 'updatedAt'),
      lastActiveAt: readOptionalDateTime(data, 'lastActiveAt'),
    );
  }

  FirestoreJson toFirestore() {
    return <String, Object?>{
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'locale': locale,
      'timezone': timezone,
      'birthYear': birthYear,
      'gender': gender,
      'stylePreferences': stylePreferences,
      'colorAnalysis': colorAnalysis?.toMap(),
      'consents': consents.toMap(),
      'subscription': subscription.toMap(),
      'aggregates': aggregates.toMap(),
      'notificationSettings': notificationSettings.toMap(),
      'createdAt': timestampFromDate(createdAt),
      'updatedAt': timestampFromDate(updatedAt),
      'lastActiveAt': optionalTimestampFromDate(lastActiveAt),
    };
  }

  UserProfile copyWith({
    String? uid,
    Object? displayName = _unset,
    Object? email = _unset,
    Object? photoUrl = _unset,
    Object? locale = _unset,
    Object? timezone = _unset,
    Object? birthYear = _unset,
    Object? gender = _unset,
    List<String>? stylePreferences,
    Object? colorAnalysis = _unset,
    UserConsents? consents,
    SubscriptionState? subscription,
    UserAggregates? aggregates,
    NotificationSettings? notificationSettings,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? lastActiveAt = _unset,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      displayName: identical(displayName, _unset)
          ? this.displayName
          : displayName as String?,
      email: identical(email, _unset) ? this.email : email as String?,
      photoUrl: identical(photoUrl, _unset)
          ? this.photoUrl
          : photoUrl as String?,
      locale: identical(locale, _unset) ? this.locale : locale as String?,
      timezone: identical(timezone, _unset)
          ? this.timezone
          : timezone as String?,
      birthYear: identical(birthYear, _unset)
          ? this.birthYear
          : birthYear as int?,
      gender: identical(gender, _unset) ? this.gender : gender as String?,
      stylePreferences: stylePreferences ?? this.stylePreferences,
      colorAnalysis: identical(colorAnalysis, _unset)
          ? this.colorAnalysis
          : colorAnalysis as ColorAnalysis?,
      consents: consents ?? this.consents,
      subscription: subscription ?? this.subscription,
      aggregates: aggregates ?? this.aggregates,
      notificationSettings: notificationSettings ?? this.notificationSettings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastActiveAt: identical(lastActiveAt, _unset)
          ? this.lastActiveAt
          : lastActiveAt as DateTime?,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is UserProfile &&
            other.uid == uid &&
            other.displayName == displayName &&
            other.email == email &&
            other.photoUrl == photoUrl &&
            other.locale == locale &&
            other.timezone == timezone &&
            other.birthYear == birthYear &&
            other.gender == gender &&
            listEquals(other.stylePreferences, stylePreferences) &&
            other.colorAnalysis == colorAnalysis &&
            other.consents == consents &&
            other.subscription == subscription &&
            other.aggregates == aggregates &&
            other.notificationSettings == notificationSettings &&
            other.createdAt == createdAt &&
            other.updatedAt == updatedAt &&
            other.lastActiveAt == lastActiveAt;
  }

  @override
  int get hashCode => Object.hash(
    uid,
    displayName,
    email,
    photoUrl,
    locale,
    timezone,
    birthYear,
    gender,
    Object.hashAll(stylePreferences),
    colorAnalysis,
    consents,
    subscription,
    aggregates,
    notificationSettings,
    createdAt,
    updatedAt,
    lastActiveAt,
  );
}

class UserConsents {
  const UserConsents({
    this.cycleSync = false,
    this.calendarSync = false,
    this.personalization = false,
    this.marketing = false,
    this.affiliateTracking = false,
    this.notifications = false,
  });

  final bool cycleSync;
  final bool calendarSync;
  final bool personalization;
  final bool marketing;
  final bool affiliateTracking;
  final bool notifications;

  factory UserConsents.fromMap(FirestoreJson data) {
    return UserConsents(
      cycleSync: readBool(data, 'cycleSync'),
      calendarSync: readBool(data, 'calendarSync'),
      personalization: readBool(data, 'personalization'),
      marketing: readBool(data, 'marketing'),
      affiliateTracking: readBool(data, 'affiliateTracking'),
      notifications: readBool(data, 'notifications'),
    );
  }

  FirestoreJson toMap() {
    return <String, Object?>{
      'cycleSync': cycleSync,
      'calendarSync': calendarSync,
      'personalization': personalization,
      'marketing': marketing,
      'affiliateTracking': affiliateTracking,
      'notifications': notifications,
    };
  }

  UserConsents copyWith({
    bool? cycleSync,
    bool? calendarSync,
    bool? personalization,
    bool? marketing,
    bool? affiliateTracking,
    bool? notifications,
  }) {
    return UserConsents(
      cycleSync: cycleSync ?? this.cycleSync,
      calendarSync: calendarSync ?? this.calendarSync,
      personalization: personalization ?? this.personalization,
      marketing: marketing ?? this.marketing,
      affiliateTracking: affiliateTracking ?? this.affiliateTracking,
      notifications: notifications ?? this.notifications,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is UserConsents &&
            other.cycleSync == cycleSync &&
            other.calendarSync == calendarSync &&
            other.personalization == personalization &&
            other.marketing == marketing &&
            other.affiliateTracking == affiliateTracking &&
            other.notifications == notifications;
  }

  @override
  int get hashCode => Object.hash(
    cycleSync,
    calendarSync,
    personalization,
    marketing,
    affiliateTracking,
    notifications,
  );
}

class SubscriptionState {
  const SubscriptionState({
    this.status = 'free',
    this.isPro = false,
    this.entitlementId,
    this.productId,
    this.revenueCatCustomerId,
    this.currentPeriodEndsAt,
    this.willRenew,
    this.updatedAt,
  });

  final String status;
  final bool isPro;
  final String? entitlementId;
  final String? productId;
  final String? revenueCatCustomerId;
  final DateTime? currentPeriodEndsAt;
  final bool? willRenew;
  final DateTime? updatedAt;

  factory SubscriptionState.fromMap(FirestoreJson data) {
    return SubscriptionState(
      status: readString(data, 'status', fallback: 'free'),
      isPro: readBool(data, 'isPro'),
      entitlementId: readOptionalString(data, 'entitlementId'),
      productId: readOptionalString(data, 'productId'),
      revenueCatCustomerId: readOptionalString(data, 'revenueCatCustomerId'),
      currentPeriodEndsAt: readOptionalDateTime(data, 'currentPeriodEndsAt'),
      willRenew: data['willRenew'] == null ? null : readBool(data, 'willRenew'),
      updatedAt: readOptionalDateTime(data, 'updatedAt'),
    );
  }

  FirestoreJson toMap() {
    return <String, Object?>{
      'status': status,
      'isPro': isPro,
      'entitlementId': entitlementId,
      'productId': productId,
      'revenueCatCustomerId': revenueCatCustomerId,
      'currentPeriodEndsAt': optionalTimestampFromDate(currentPeriodEndsAt),
      'willRenew': willRenew,
      'updatedAt': optionalTimestampFromDate(updatedAt),
    };
  }

  SubscriptionState copyWith({
    String? status,
    bool? isPro,
    Object? entitlementId = _unset,
    Object? productId = _unset,
    Object? revenueCatCustomerId = _unset,
    Object? currentPeriodEndsAt = _unset,
    Object? willRenew = _unset,
    Object? updatedAt = _unset,
  }) {
    return SubscriptionState(
      status: status ?? this.status,
      isPro: isPro ?? this.isPro,
      entitlementId: identical(entitlementId, _unset)
          ? this.entitlementId
          : entitlementId as String?,
      productId: identical(productId, _unset)
          ? this.productId
          : productId as String?,
      revenueCatCustomerId: identical(revenueCatCustomerId, _unset)
          ? this.revenueCatCustomerId
          : revenueCatCustomerId as String?,
      currentPeriodEndsAt: identical(currentPeriodEndsAt, _unset)
          ? this.currentPeriodEndsAt
          : currentPeriodEndsAt as DateTime?,
      willRenew: identical(willRenew, _unset)
          ? this.willRenew
          : willRenew as bool?,
      updatedAt: identical(updatedAt, _unset)
          ? this.updatedAt
          : updatedAt as DateTime?,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SubscriptionState &&
            other.status == status &&
            other.isPro == isPro &&
            other.entitlementId == entitlementId &&
            other.productId == productId &&
            other.revenueCatCustomerId == revenueCatCustomerId &&
            other.currentPeriodEndsAt == currentPeriodEndsAt &&
            other.willRenew == willRenew &&
            other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
    status,
    isPro,
    entitlementId,
    productId,
    revenueCatCustomerId,
    currentPeriodEndsAt,
    willRenew,
    updatedAt,
  );
}

class UserAggregates {
  UserAggregates({
    this.totalWardrobeItems = 0,
    Map<String, int> itemsByCategory = const <String, int>{},
    this.outfitCount = 0,
    this.feedbackCount = 0,
  }) : itemsByCategory = Map<String, int>.unmodifiable(itemsByCategory);

  final int totalWardrobeItems;
  final Map<String, int> itemsByCategory;
  final int outfitCount;
  final int feedbackCount;

  factory UserAggregates.fromMap(FirestoreJson data) {
    return UserAggregates(
      totalWardrobeItems: readInt(data, 'totalWardrobeItems'),
      itemsByCategory: readIntMap(data, 'itemsByCategory'),
      outfitCount: readInt(data, 'outfitCount'),
      feedbackCount: readInt(data, 'feedbackCount'),
    );
  }

  FirestoreJson toMap() {
    return <String, Object?>{
      'totalWardrobeItems': totalWardrobeItems,
      'itemsByCategory': itemsByCategory,
      'outfitCount': outfitCount,
      'feedbackCount': feedbackCount,
    };
  }

  UserAggregates copyWith({
    int? totalWardrobeItems,
    Map<String, int>? itemsByCategory,
    int? outfitCount,
    int? feedbackCount,
  }) {
    return UserAggregates(
      totalWardrobeItems: totalWardrobeItems ?? this.totalWardrobeItems,
      itemsByCategory: itemsByCategory ?? this.itemsByCategory,
      outfitCount: outfitCount ?? this.outfitCount,
      feedbackCount: feedbackCount ?? this.feedbackCount,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is UserAggregates &&
            other.totalWardrobeItems == totalWardrobeItems &&
            mapEquals(other.itemsByCategory, itemsByCategory) &&
            other.outfitCount == outfitCount &&
            other.feedbackCount == feedbackCount;
  }

  @override
  int get hashCode => Object.hash(
    totalWardrobeItems,
    Object.hashAllUnordered(
      itemsByCategory.entries.map(
        (entry) => Object.hash(entry.key, entry.value),
      ),
    ),
    outfitCount,
    feedbackCount,
  );
}

class NotificationSettings {
  const NotificationSettings({
    this.dailyRecommendations = true,
    this.wardrobeReminders = true,
    this.styleChallenges = true,
    this.marketing = false,
    this.quietHoursStart,
    this.quietHoursEnd,
  });

  final bool dailyRecommendations;
  final bool wardrobeReminders;
  final bool styleChallenges;
  final bool marketing;
  final String? quietHoursStart;
  final String? quietHoursEnd;

  factory NotificationSettings.fromMap(FirestoreJson data) {
    return NotificationSettings(
      dailyRecommendations: readBool(
        data,
        'dailyRecommendations',
        defaultValue: true,
      ),
      wardrobeReminders: readBool(
        data,
        'wardrobeReminders',
        defaultValue: true,
      ),
      styleChallenges: readBool(data, 'styleChallenges', defaultValue: true),
      marketing: readBool(data, 'marketing'),
      quietHoursStart: readOptionalString(data, 'quietHoursStart'),
      quietHoursEnd: readOptionalString(data, 'quietHoursEnd'),
    );
  }

  FirestoreJson toMap() {
    return <String, Object?>{
      'dailyRecommendations': dailyRecommendations,
      'wardrobeReminders': wardrobeReminders,
      'styleChallenges': styleChallenges,
      'marketing': marketing,
      'quietHoursStart': quietHoursStart,
      'quietHoursEnd': quietHoursEnd,
    };
  }

  NotificationSettings copyWith({
    bool? dailyRecommendations,
    bool? wardrobeReminders,
    bool? styleChallenges,
    bool? marketing,
    Object? quietHoursStart = _unset,
    Object? quietHoursEnd = _unset,
  }) {
    return NotificationSettings(
      dailyRecommendations: dailyRecommendations ?? this.dailyRecommendations,
      wardrobeReminders: wardrobeReminders ?? this.wardrobeReminders,
      styleChallenges: styleChallenges ?? this.styleChallenges,
      marketing: marketing ?? this.marketing,
      quietHoursStart: identical(quietHoursStart, _unset)
          ? this.quietHoursStart
          : quietHoursStart as String?,
      quietHoursEnd: identical(quietHoursEnd, _unset)
          ? this.quietHoursEnd
          : quietHoursEnd as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is NotificationSettings &&
            other.dailyRecommendations == dailyRecommendations &&
            other.wardrobeReminders == wardrobeReminders &&
            other.styleChallenges == styleChallenges &&
            other.marketing == marketing &&
            other.quietHoursStart == quietHoursStart &&
            other.quietHoursEnd == quietHoursEnd;
  }

  @override
  int get hashCode => Object.hash(
    dailyRecommendations,
    wardrobeReminders,
    styleChallenges,
    marketing,
    quietHoursStart,
    quietHoursEnd,
  );
}

class ColorAnalysis {
  ColorAnalysis({
    this.season,
    this.undertone,
    this.contrast,
    List<String> paletteHex = const <String>[],
    this.analyzedAt,
  }) : paletteHex = List<String>.unmodifiable(paletteHex);

  final String? season;
  final String? undertone;
  final String? contrast;
  final List<String> paletteHex;
  final DateTime? analyzedAt;

  factory ColorAnalysis.fromMap(FirestoreJson data) {
    return ColorAnalysis(
      season: readOptionalString(data, 'season'),
      undertone: readOptionalString(data, 'undertone'),
      contrast: readOptionalString(data, 'contrast'),
      paletteHex: readStringList(data, 'paletteHex'),
      analyzedAt: readOptionalDateTime(data, 'analyzedAt'),
    );
  }

  FirestoreJson toMap() {
    return <String, Object?>{
      'season': season,
      'undertone': undertone,
      'contrast': contrast,
      'paletteHex': paletteHex,
      'analyzedAt': optionalTimestampFromDate(analyzedAt),
    };
  }

  ColorAnalysis copyWith({
    Object? season = _unset,
    Object? undertone = _unset,
    Object? contrast = _unset,
    List<String>? paletteHex,
    Object? analyzedAt = _unset,
  }) {
    return ColorAnalysis(
      season: identical(season, _unset) ? this.season : season as String?,
      undertone: identical(undertone, _unset)
          ? this.undertone
          : undertone as String?,
      contrast: identical(contrast, _unset)
          ? this.contrast
          : contrast as String?,
      paletteHex: paletteHex ?? this.paletteHex,
      analyzedAt: identical(analyzedAt, _unset)
          ? this.analyzedAt
          : analyzedAt as DateTime?,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ColorAnalysis &&
            other.season == season &&
            other.undertone == undertone &&
            other.contrast == contrast &&
            listEquals(other.paletteHex, paletteHex) &&
            other.analyzedAt == analyzedAt;
  }

  @override
  int get hashCode => Object.hash(
    season,
    undertone,
    contrast,
    Object.hashAll(paletteHex),
    analyzedAt,
  );
}
