import type {Timestamp} from "firebase-admin/firestore";

export type JsonPrimitive = string | number | boolean | null;
export type JsonValue = JsonPrimitive | JsonValue[] | JsonObject;
export interface JsonObject {
  [key: string]: JsonValue;
}

export interface UserProfileDefaults {
  uid: string;
  displayName: string | null;
  email: string | null;
  photoUrl: string | null;
  createdAt: Timestamp;
}

export interface WardrobeAggregate {
  totalWardrobeItems: number;
  itemsByCategory: Record<string, number>;
}

export interface OutfitFeedbackData {
  userId?: string;
  outfitId: string;
  recommendationId?: string;
  recommendationDate?: string;
  rating: number;
  woreIt: boolean;
  selectedItemIds?: string[];
  notes?: string;
  source?: string;
  createdAt?: Timestamp;
}

export interface RevenueCatEvent {
  app_user_id?: string;
  type?: string;
  product_id?: string;
  entitlement_ids?: string[];
  expiration_at_ms?: number;
  purchased_at_ms?: number;
  store?: string;
  id?: string;
  environment?: string;
}

export interface RevenueCatWebhookPayload {
  api_version?: string;
  event?: RevenueCatEvent;
}

export interface SubscriptionState {
  status: "free" | "active" | "trialing" | "expired" | "billingIssue";
  isPro: boolean;
  entitlementId: string | null;
  productId: string | null;
  revenueCatCustomerId: string | null;
  currentPeriodEndsAt: Timestamp | null;
  willRenew: boolean | null;
  updatedAt: Timestamp;
}

export interface AccountDeleteRequest {
  uid?: string;
}

export interface AccountDeleteResponse {
  uid: string;
  firestoreDeleted: boolean;
  storageDeleted: boolean;
  authDeleted: boolean;
  rootDocumentsDeleted: number;
}

export interface ExportUserDataRequest {
  uid?: string;
}

export interface ExportUserDataResponse {
  uid: string;
  storagePath: string;
  signedUrl: string;
  expiresAt: string;
  emailSent: boolean;
}

export interface ExportedDocument {
  id: string;
  path: string;
  data: JsonObject;
}

export interface UserDataExport {
  version: 1;
  exportedAt: string;
  uid: string;
  collections: Record<string, ExportedDocument[]>;
}

export interface RecommendationEngineInput {
  uid: string;
  dateKey: string;
  timezone: string;
}

export interface RecommendationWrite {
  dateKey: string;
  timezone: string;
  status: "pending" | "generated" | "failed";
  outfits: JsonObject[];
  generatedAt: Timestamp;
  createdAt: Timestamp;
  updatedAt: Timestamp;
  modelVersion: string;
  failureReason?: string;
}
