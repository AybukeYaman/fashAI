import {Timestamp} from "firebase-admin/firestore";
import type {RecommendationEngineInput, RecommendationWrite} from "./types";

export async function generateDailyRecommendation(
  input: RecommendationEngineInput,
): Promise<RecommendationWrite> {
  const now = Timestamp.now();

  return {
    dateKey: input.dateKey,
    timezone: input.timezone,
    status: "pending",
    outfits: [],
    generatedAt: now,
    createdAt: now,
    updatedAt: now,
    modelVersion: "recommendation-engine-stub-v1",
    failureReason: "Recommendation engine integration is not implemented yet.",
  };
}
