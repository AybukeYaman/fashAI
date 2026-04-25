import crypto from "node:crypto";
import type {Request} from "firebase-functions/v2/https";
import {Timestamp} from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";
import {db} from "../firebaseAdmin";
import type {
  RevenueCatWebhookPayload,
  SubscriptionState,
} from "../types";

export function verifyRevenueCatRequest(request: Request): boolean {
  const bearerToken = process.env.REVENUECAT_WEBHOOK_TOKEN;
  const signatureSecret = process.env.REVENUECAT_WEBHOOK_SIGNATURE_SECRET;

  if (bearerToken) {
    const authorization = request.header("authorization") ?? "";
    return authorization === `Bearer ${bearerToken}`;
  }

  if (signatureSecret) {
    const signature = request.header("x-revenuecat-signature");
    if (!signature) {
      return false;
    }
    return verifyHmacSignature(signatureSecret, request.rawBody, signature);
  }

  logger.warn("RevenueCat webhook verification is not configured.");
  return false;
}

export function parseRevenueCatPayload(
  body: unknown,
): RevenueCatWebhookPayload {
  if (typeof body === "string") {
    return JSON.parse(body) as RevenueCatWebhookPayload;
  }
  if (body !== null && typeof body === "object") {
    return body as RevenueCatWebhookPayload;
  }
  return {};
}

export function subscriptionFromRevenueCat(
  payload: RevenueCatWebhookPayload,
): SubscriptionState {
  const event = payload.event ?? {};
  const eventType = event.type ?? "UNKNOWN";
  const now = Timestamp.now();
  const expiresAt =
    typeof event.expiration_at_ms === "number"
      ? Timestamp.fromMillis(event.expiration_at_ms)
      : null;
  const entitlementId = event.entitlement_ids?.[0] ?? null;
  const isCurrentlyEntitled =
    expiresAt === null || expiresAt.toMillis() > Date.now();

  if (eventType === "EXPIRATION") {
    return {
      status: "expired",
      isPro: false,
      entitlementId,
      productId: event.product_id ?? null,
      revenueCatCustomerId: event.app_user_id ?? null,
      currentPeriodEndsAt: expiresAt,
      willRenew: false,
      updatedAt: now,
    };
  }

  if (eventType === "BILLING_ISSUE") {
    return {
      status: "billingIssue",
      isPro: isCurrentlyEntitled,
      entitlementId,
      productId: event.product_id ?? null,
      revenueCatCustomerId: event.app_user_id ?? null,
      currentPeriodEndsAt: expiresAt,
      willRenew: true,
      updatedAt: now,
    };
  }

  return {
    status: "active",
    isPro: isCurrentlyEntitled,
    entitlementId,
    productId: event.product_id ?? null,
    revenueCatCustomerId: event.app_user_id ?? null,
    currentPeriodEndsAt: expiresAt,
    willRenew: eventType === "CANCELLATION" ? false : true,
    updatedAt: now,
  };
}

export async function updateSubscriptionFromWebhook(
  payload: RevenueCatWebhookPayload,
): Promise<string> {
  const uid = payload.event?.app_user_id;
  if (!uid) {
    throw new Error("RevenueCat payload missing event.app_user_id.");
  }

  const subscription = subscriptionFromRevenueCat(payload);
  await db.collection("users").doc(uid).set(
    {
      subscription,
      updatedAt: Timestamp.now(),
    },
    {merge: true},
  );

  logger.info("Updated subscription from RevenueCat webhook", {
    uid,
    eventType: payload.event?.type ?? "UNKNOWN",
  });

  return uid;
}

function verifyHmacSignature(
  secret: string,
  rawBody: Buffer,
  receivedSignature: string,
): boolean {
  const expected = crypto
    .createHmac("sha256", secret)
    .update(rawBody)
    .digest("hex");
  const normalized = receivedSignature.replace(/^sha256=/, "");
  const expectedBuffer = Buffer.from(expected, "hex");
  const receivedBuffer = Buffer.from(normalized, "hex");

  return (
    expectedBuffer.length === receivedBuffer.length &&
    crypto.timingSafeEqual(expectedBuffer, receivedBuffer)
  );
}
