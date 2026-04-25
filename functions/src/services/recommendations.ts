import {Timestamp} from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";
import {
  DEFAULT_TIMEZONE,
  RECOMMENDATION_RETENTION_DAYS,
} from "../config";
import {db} from "../firebaseAdmin";
import {generateDailyRecommendation} from "../recommendation-engine";
import {daysAgo, localDateParts} from "../utils/time";

export async function generateRecommendationsForDueUsers(
  now = new Date(),
): Promise<number> {
  const users = await db
    .collection("users")
    .where("consents.personalization", "==", true)
    .limit(200)
    .get();

  let generatedCount = 0;
  for (const userDoc of users.docs) {
    const data = userDoc.data();
    const timezone =
      typeof data.timezone === "string" ? data.timezone : DEFAULT_TIMEZONE;
    const local = localDateParts(now, timezone);

    if (local.hour < 2 || local.hour > 5) {
      continue;
    }

    const recommendationRef = userDoc.ref
      .collection("recommendations")
      .doc(local.dateKey);
    const existing = await recommendationRef.get();
    if (existing.exists) {
      continue;
    }

    const recommendation = await generateDailyRecommendation({
      uid: userDoc.id,
      dateKey: local.dateKey,
      timezone,
    });

    await recommendationRef.set(recommendation);
    generatedCount += 1;
  }

  logger.info("Generated scheduled daily recommendations", {
    generatedCount,
  });

  return generatedCount;
}

export async function archiveOldRecommendationDocs(): Promise<number> {
  const cutoff = Timestamp.fromDate(daysAgo(RECOMMENDATION_RETENTION_DAYS));
  const oldRecommendations = await db
    .collectionGroup("recommendations")
    .where("generatedAt", "<", cutoff)
    .limit(500)
    .get();

  if (oldRecommendations.empty) {
    return 0;
  }

  const batch = db.batch();
  for (const doc of oldRecommendations.docs) {
    batch.delete(doc.ref);
  }
  await batch.commit();

  logger.info("Archived old recommendations", {
    deletedCount: oldRecommendations.size,
  });

  return oldRecommendations.size;
}
