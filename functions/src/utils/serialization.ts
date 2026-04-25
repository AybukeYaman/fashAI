import {
  DocumentReference,
  GeoPoint,
  Timestamp,
} from "firebase-admin/firestore";
import type {JsonObject, JsonValue} from "../types";

export function toJsonValue(value: unknown): JsonValue {
  if (
    value === null ||
    typeof value === "string" ||
    typeof value === "number" ||
    typeof value === "boolean"
  ) {
    return value;
  }
  if (value instanceof Timestamp) {
    return value.toDate().toISOString();
  }
  if (value instanceof Date) {
    return value.toISOString();
  }
  if (value instanceof GeoPoint) {
    return {
      latitude: value.latitude,
      longitude: value.longitude,
    };
  }
  if (value instanceof DocumentReference) {
    return value.path;
  }
  if (Array.isArray(value)) {
    return value.map((entry) => toJsonValue(entry));
  }
  if (typeof value === "object") {
    return toJsonObject(value);
  }
  return String(value);
}

export function toJsonObject(value: unknown): JsonObject {
  if (value === null || typeof value !== "object") {
    return {};
  }
  return Object.fromEntries(
    Object.entries(value as Record<string, unknown>).map(([key, entry]) => [
      key,
      toJsonValue(entry),
    ]),
  );
}
