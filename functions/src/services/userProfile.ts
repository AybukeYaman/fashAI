import type {UserRecord} from "firebase-admin/auth";
import {Timestamp} from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";
import {DEFAULT_TIMEZONE} from "../config";
import {db} from "../firebaseAdmin";
import type {UserProfileDefaults} from "../types";

export function buildDefaultUserProfile(user: UserRecord): UserProfileDefaults {
  return {
    uid: user.uid,
    displayName: user.displayName ?? null,
    email: user.email ?? null,
    photoUrl: user.photoURL ?? null,
    createdAt: Timestamp.now(),
  };
}

export async function initializeUserProfile(user: UserRecord): Promise<void> {
  const defaults = buildDefaultUserProfile(user);
  const userRef = db.collection("users").doc(defaults.uid);
  const now = defaults.createdAt;

  await userRef.set(
    {
      uid: defaults.uid,
      displayName: defaults.displayName,
      email: defaults.email,
      photoUrl: defaults.photoUrl,
      locale: "tr-TR",
      timezone: DEFAULT_TIMEZONE,
      stylePreferences: [],
      colorAnalysis: null,
      consents: {
        cycleSync: false,
        calendarSync: false,
        personalization: false,
        marketing: false,
        affiliateTracking: false,
        notifications: false,
      },
      subscription: {
        status: "free",
        isPro: false,
        entitlementId: null,
        productId: null,
        revenueCatCustomerId: null,
        currentPeriodEndsAt: null,
        willRenew: null,
        updatedAt: now,
      },
      aggregates: {
        totalWardrobeItems: 0,
        itemsByCategory: {},
        outfitCount: 0,
        feedbackCount: 0,
      },
      notificationSettings: {
        dailyRecommendations: true,
        wardrobeReminders: true,
        styleChallenges: true,
        marketing: false,
        quietHoursStart: null,
        quietHoursEnd: null,
      },
      createdAt: now,
      updatedAt: now,
      lastActiveAt: null,
    },
    {merge: true},
  );

  logger.info("Initialized user profile", {uid: defaults.uid});
}
