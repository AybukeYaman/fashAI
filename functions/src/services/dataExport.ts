import {PassThrough} from "node:stream";
import archiver from "archiver";
import {HttpsError} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import nodemailer from "nodemailer";
import type {CollectionReference} from "firebase-admin/firestore";
import {
  EXPORT_LINK_TTL_DAYS,
  MAX_USER_EXPORT_BYTES,
} from "../config";
import {auth, db, storage} from "../firebaseAdmin";
import type {
  ExportUserDataResponse,
  ExportedDocument,
  UserDataExport,
} from "../types";
import {daysFromNow} from "../utils/time";
import {toJsonObject} from "../utils/serialization";

export async function exportUserDataArchive(
  uid: string,
): Promise<ExportUserDataResponse> {
  const exportPayload = await collectUserData(uid);
  const archiveBuffer = await zipJsonPayload(exportPayload);

  if (archiveBuffer.byteLength > MAX_USER_EXPORT_BYTES) {
    throw new HttpsError(
      "resource-exhausted",
      "User export is too large for the current export pipeline.",
    );
  }

  const expiresAt = daysFromNow(EXPORT_LINK_TTL_DAYS);
  const storagePath = `users/${uid}/exports/export-${Date.now()}.zip`;
  const bucket = storage.bucket();
  const file = bucket.file(storagePath);

  await file.save(archiveBuffer, {
    contentType: "application/zip",
    metadata: {
      cacheControl: "private, max-age=0, no-store",
      metadata: {
        kvkkExport: "true",
        uid,
      },
    },
  });

  const [signedUrl] = await file.getSignedUrl({
    action: "read",
    expires: expiresAt,
  });

  const emailSent = await sendExportEmail(uid, signedUrl, expiresAt);

  logger.info("Created user data export", {
    uid,
    storagePath,
    emailSent,
  });

  return {
    uid,
    storagePath,
    signedUrl,
    expiresAt: expiresAt.toISOString(),
    emailSent,
  };
}

async function collectUserData(uid: string): Promise<UserDataExport> {
  const userRef = db.collection("users").doc(uid);
  const collections: Record<string, ExportedDocument[]> = {};

  collections.profile = await collectSingleDocument(userRef);
  collections.wardrobe = await collectCollection(
    userRef.collection("wardrobe"),
  );
  collections.outfits = await collectCollection(userRef.collection("outfits"));
  collections.recommendations = await collectCollection(
    userRef.collection("recommendations"),
  );
  collections.feedback = await collectCollection(
    userRef.collection("feedback"),
  );
  collections.calendarCache = await collectCollection(
    userRef.collection("calendar_cache"),
  );
  collections.notifications = await collectCollection(
    userRef.collection("notifications"),
  );
  collections.private = await collectCollection(userRef.collection("private"));
  collections.affiliateClicks = await collectQuery(
    db.collection("affiliate_clicks").where("userId", "==", uid),
  );
  collections.trainingSignals = await collectQuery(
    db.collection("training_signals").where("userId", "==", uid),
  );
  collections.challengeSubmissions = await collectQuery(
    db.collectionGroup("submissions").where("userId", "==", uid),
  );

  return {
    version: 1,
    exportedAt: new Date().toISOString(),
    uid,
    collections,
  };
}

async function collectSingleDocument(
  ref: FirebaseFirestore.DocumentReference,
): Promise<ExportedDocument[]> {
  const snapshot = await ref.get();
  if (!snapshot.exists) {
    return [];
  }
  return [
    {
      id: snapshot.id,
      path: snapshot.ref.path,
      data: toJsonObject(snapshot.data() ?? {}),
    },
  ];
}

async function collectCollection(
  ref: CollectionReference,
): Promise<ExportedDocument[]> {
  const snapshot = await ref.get();
  return snapshot.docs.map((doc) => ({
    id: doc.id,
    path: doc.ref.path,
    data: toJsonObject(doc.data()),
  }));
}

async function collectQuery(
  query: FirebaseFirestore.Query,
): Promise<ExportedDocument[]> {
  const snapshot = await query.get();
  return snapshot.docs.map((doc) => ({
    id: doc.id,
    path: doc.ref.path,
    data: toJsonObject(doc.data()),
  }));
}

async function zipJsonPayload(payload: UserDataExport): Promise<Buffer> {
  const archive = archiver("zip", {zlib: {level: 9}});
  const stream = new PassThrough();
  const chunks: Buffer[] = [];

  const completion = new Promise<Buffer>((resolve, reject) => {
    stream.on("data", (chunk: Buffer | string) => {
      chunks.push(Buffer.isBuffer(chunk) ? chunk : Buffer.from(chunk));
    });
    stream.on("end", () => resolve(Buffer.concat(chunks)));
    stream.on("error", reject);
    archive.on("error", reject);
  });

  archive.pipe(stream);
  archive.append(JSON.stringify(payload, null, 2), {
    name: `combime-user-export-${payload.uid}.json`,
  });
  await archive.finalize();
  return completion;
}

async function sendExportEmail(
  uid: string,
  signedUrl: string,
  expiresAt: Date,
): Promise<boolean> {
  const user = await auth.getUser(uid);
  const email = user.email;
  if (!email) {
    logger.warn("Cannot email export link because user has no email", {uid});
    return false;
  }

  const smtpHost = process.env.SMTP_HOST;
  const smtpFrom = process.env.SMTP_FROM;
  if (!smtpHost || !smtpFrom) {
    logger.warn("SMTP is not configured; export link was not emailed", {uid});
    return false;
  }

  const smtpUser = process.env.SMTP_USER;
  const smtpPass = process.env.SMTP_PASS;
  const transporter = nodemailer.createTransport({
    host: smtpHost,
    port: Number(process.env.SMTP_PORT ?? "587"),
    secure: process.env.SMTP_SECURE === "true",
    auth:
      smtpUser && smtpPass
        ? {
            user: smtpUser,
            pass: smtpPass,
          }
        : undefined,
  });

  await transporter.sendMail({
    from: smtpFrom,
    to: email,
    subject: "Combime data export",
    text:
      `Your Combime data export is ready.\n\n${signedUrl}\n\n` +
      `This link expires at ${expiresAt.toISOString()}.`,
  });

  return true;
}
