import {Timestamp} from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";
import {db} from "../firebaseAdmin";
import type {WardrobeAggregate} from "../types";

export async function recalculateWardrobeAggregate(
  uid: string,
): Promise<WardrobeAggregate> {
  const wardrobeSnapshot = await db
    .collection("users")
    .doc(uid)
    .collection("wardrobe")
    .where("isArchived", "==", false)
    .get();

  const itemsByCategory: Record<string, number> = {};
  for (const doc of wardrobeSnapshot.docs) {
    const category = categoryFromWardrobeDoc(doc.data());
    itemsByCategory[category] = (itemsByCategory[category] ?? 0) + 1;
  }

  const aggregate: WardrobeAggregate = {
    totalWardrobeItems: wardrobeSnapshot.size,
    itemsByCategory,
  };

  await db.collection("users").doc(uid).set(
    {
      "aggregates.totalWardrobeItems": aggregate.totalWardrobeItems,
      "aggregates.itemsByCategory": aggregate.itemsByCategory,
      updatedAt: Timestamp.now(),
    },
    {merge: true},
  );

  logger.info("Updated wardrobe aggregates", {
    uid,
    totalWardrobeItems: aggregate.totalWardrobeItems,
  });

  return aggregate;
}

function categoryFromWardrobeDoc(data: FirebaseFirestore.DocumentData): string {
  const category = data.category;
  return typeof category === "string" && category.trim().length > 0
    ? category
    : "unknown";
}
