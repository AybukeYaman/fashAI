import {FieldValue, Timestamp} from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";
import {db} from "../firebaseAdmin";
import type {OutfitFeedbackData} from "../types";

export async function logFeedbackTrainingSignal(
  uid: string,
  feedbackId: string,
  data: OutfitFeedbackData,
): Promise<void> {
  const now = Timestamp.now();
  await db.collection("training_signals").doc(`${uid}_${feedbackId}`).set({
    userId: uid,
    feedbackId,
    signalType: "outfit_feedback",
    outfitId: data.outfitId,
    recommendationId: data.recommendationId ?? null,
    recommendationDate: data.recommendationDate ?? null,
    rating: data.rating,
    woreIt: data.woreIt,
    selectedItemIds: data.selectedItemIds ?? [],
    source: data.source ?? null,
    createdAt: data.createdAt ?? now,
    loggedAt: now,
  });

  await db.collection("users").doc(uid).set(
    {
      "aggregates.feedbackCount": FieldValue.increment(1),
      updatedAt: now,
    },
    {merge: true},
  );

  logger.info("Logged feedback training signal", {uid, feedbackId});
}

export function parseFeedbackData(
  data: FirebaseFirestore.DocumentData,
): OutfitFeedbackData {
  return {
    userId: typeof data.userId === "string" ? data.userId : undefined,
    outfitId: typeof data.outfitId === "string" ? data.outfitId : "",
    recommendationId:
      typeof data.recommendationId === "string"
        ? data.recommendationId
        : undefined,
    recommendationDate:
      typeof data.recommendationDate === "string"
        ? data.recommendationDate
        : undefined,
    rating: typeof data.rating === "number" ? data.rating : 0,
    woreIt: data.woreIt === true,
    selectedItemIds: Array.isArray(data.selectedItemIds)
      ? data.selectedItemIds.map((entry) => String(entry))
      : [],
    notes: typeof data.notes === "string" ? data.notes : undefined,
    source: typeof data.source === "string" ? data.source : undefined,
    createdAt: data.createdAt instanceof Timestamp ? data.createdAt : undefined,
  };
}
