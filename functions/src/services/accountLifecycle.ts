import {HttpsError} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import type {Query} from "firebase-admin/firestore";
import {auth, db, storage} from "../firebaseAdmin";
import type {AccountDeleteResponse} from "../types";

export async function deleteAccountData(
  uid: string,
): Promise<AccountDeleteResponse> {
  const userRef = db.collection("users").doc(uid);

  await db.recursiveDelete(userRef);
  const firestoreDeleted = true;
  const rootDocumentsDeleted = await deleteRootPersonalDocuments(uid);

  await storage.bucket().deleteFiles({
    prefix: `users/${uid}/`,
    force: true,
  });
  const storageDeleted = true;

  try {
    await auth.deleteUser(uid);
  } catch (error) {
    if (isFirebaseAuthUserNotFound(error)) {
      logger.warn("Auth user already deleted during account deletion", {uid});
    } else {
      throw error;
    }
  }

  logger.info("Deleted account data", {uid});

  return {
    uid,
    firestoreDeleted,
    storageDeleted,
    authDeleted: true,
    rootDocumentsDeleted,
  };
}

export function assertDeleteRequestUid(uid: string): void {
  if (!uid.trim()) {
    throw new HttpsError("invalid-argument", "A valid uid is required.");
  }
}

function isFirebaseAuthUserNotFound(error: unknown): boolean {
  return (
    typeof error === "object" &&
    error !== null &&
    "code" in error &&
    error.code === "auth/user-not-found"
  );
}

async function deleteRootPersonalDocuments(uid: string): Promise<number> {
  const counts = await Promise.all([
    deleteQueryBatches(db.collection("affiliate_clicks").where("userId", "==", uid)),
    deleteQueryBatches(db.collection("training_signals").where("userId", "==", uid)),
    deleteQueryBatches(db.collectionGroup("submissions").where("userId", "==", uid)),
  ]);
  return counts.reduce((sum, count) => sum + count, 0);
}

async function deleteQueryBatches(query: Query): Promise<number> {
  let deletedCount = 0;
  while (true) {
    const snapshot = await query.limit(450).get();
    if (snapshot.empty) {
      return deletedCount;
    }

    const batch = db.batch();
    for (const doc of snapshot.docs) {
      batch.delete(doc.ref);
    }
    await batch.commit();
    deletedCount += snapshot.size;
  }
}
