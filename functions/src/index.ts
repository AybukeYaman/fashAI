import * as functionsV1 from "firebase-functions/v1";
import * as logger from "firebase-functions/logger";
import {setGlobalOptions} from "firebase-functions/v2";
import {
  onDocumentCreated,
  onDocumentWritten,
} from "firebase-functions/v2/firestore";
import {
  HttpsError,
  onCall,
  onRequest,
  type CallableRequest,
} from "firebase-functions/v2/https";
import {onSchedule} from "firebase-functions/v2/scheduler";
import {FUNCTION_REGION} from "./config";
import {initializeUserProfile} from "./services/userProfile";
import {recalculateWardrobeAggregate} from "./services/wardrobeAggregates";
import {
  logFeedbackTrainingSignal,
  parseFeedbackData,
} from "./services/feedbackSignals";
import {
  parseRevenueCatPayload,
  updateSubscriptionFromWebhook,
  verifyRevenueCatRequest,
} from "./services/revenueCat";
import {
  assertDeleteRequestUid,
  deleteAccountData,
} from "./services/accountLifecycle";
import {exportUserDataArchive} from "./services/dataExport";
import {
  archiveOldRecommendationDocs,
  generateRecommendationsForDueUsers,
} from "./services/recommendations";
import type {
  AccountDeleteRequest,
  AccountDeleteResponse,
  ExportUserDataRequest,
  ExportUserDataResponse,
} from "./types";
import {assertSelfOrAdmin, requireAuthenticated} from "./utils/auth";

setGlobalOptions({
  region: FUNCTION_REGION,
  maxInstances: 10,
});

export const onUserCreate = functionsV1
  .region(FUNCTION_REGION)
  .auth.user()
  .onCreate(async (user) => {
    try {
      await initializeUserProfile(user);
    } catch (error) {
      logger.error("Failed to initialize user profile", {
        uid: user.uid,
        error,
      });
      throw error;
    }
  });

export const onWardrobeItemWrite = onDocumentWritten(
  {
    document: "users/{uid}/wardrobe/{itemId}",
    region: FUNCTION_REGION,
  },
  async (event) => {
    const uid = event.params.uid;
    try {
      await recalculateWardrobeAggregate(uid);
    } catch (error) {
      logger.error("Failed to update wardrobe aggregates", {uid, error});
      throw error;
    }
  },
);

export const onFeedbackCreate = onDocumentCreated(
  {
    document: "users/{uid}/feedback/{feedbackId}",
    region: FUNCTION_REGION,
  },
  async (event) => {
    const uid = event.params.uid;
    const feedbackId = event.params.feedbackId;
    const snapshot = event.data;
    if (!snapshot) {
      logger.warn("Feedback create event had no snapshot", {uid, feedbackId});
      return;
    }

    try {
      await logFeedbackTrainingSignal(
        uid,
        feedbackId,
        parseFeedbackData(snapshot.data()),
      );
    } catch (error) {
      logger.error("Failed to log feedback training signal", {
        uid,
        feedbackId,
        error,
      });
      throw error;
    }
  },
);

export const onSubscriptionWebhook = onRequest(
  {
    region: FUNCTION_REGION,
    timeoutSeconds: 60,
    cors: false,
  },
  async (request, response) => {
    if (request.method !== "POST") {
      response.status(405).send("Method Not Allowed");
      return;
    }

    if (!verifyRevenueCatRequest(request)) {
      logger.warn("Rejected RevenueCat webhook with failed verification");
      response.status(401).send("Unauthorized");
      return;
    }

    try {
      const payload = parseRevenueCatPayload(request.body as unknown);
      const uid = await updateSubscriptionFromWebhook(payload);
      response.status(200).json({ok: true, uid});
    } catch (error) {
      logger.error("Failed to process RevenueCat webhook", {error});
      response.status(400).json({ok: false});
    }
  },
);

export const onAccountDelete = onCall(
  {
    region: FUNCTION_REGION,
    timeoutSeconds: 540,
    memory: "1GiB",
  },
  async (
    request: CallableRequest<AccountDeleteRequest>,
  ): Promise<AccountDeleteResponse> => {
    const callerUid = requireAuthenticated(request);
    const targetUid = request.data.uid ?? callerUid;
    assertDeleteRequestUid(targetUid);
    assertSelfOrAdmin(callerUid, targetUid, request);

    try {
      return await deleteAccountData(targetUid);
    } catch (error) {
      logger.error("Failed to delete account data", {targetUid, error});
      throw new HttpsError("internal", "Account deletion failed.");
    }
  },
);

export const exportUserData = onCall(
  {
    region: FUNCTION_REGION,
    timeoutSeconds: 540,
    memory: "1GiB",
  },
  async (
    request: CallableRequest<ExportUserDataRequest>,
  ): Promise<ExportUserDataResponse> => {
    const callerUid = requireAuthenticated(request);
    const targetUid = request.data.uid ?? callerUid;
    assertSelfOrAdmin(callerUid, targetUid, request);

    try {
      return await exportUserDataArchive(targetUid);
    } catch (error) {
      if (error instanceof HttpsError) {
        throw error;
      }
      logger.error("Failed to export user data", {targetUid, error});
      throw new HttpsError("internal", "User data export failed.");
    }
  },
);

export const dailyRecommendationGenerator = onSchedule(
  {
    schedule: "every 1 hours",
    region: FUNCTION_REGION,
    timeZone: "Etc/UTC",
    timeoutSeconds: 540,
  },
  async () => {
    try {
      await generateRecommendationsForDueUsers();
    } catch (error) {
      logger.error("Failed to generate daily recommendations", {error});
      throw error;
    }
  },
);

export const archiveOldRecommendations = onSchedule(
  {
    schedule: "every day 04:30",
    region: FUNCTION_REGION,
    timeZone: "Etc/UTC",
    timeoutSeconds: 300,
  },
  async () => {
    try {
      await archiveOldRecommendationDocs();
    } catch (error) {
      logger.error("Failed to archive old recommendations", {error});
      throw error;
    }
  },
);
