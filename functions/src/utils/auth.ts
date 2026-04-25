import {HttpsError, type CallableRequest} from "firebase-functions/v2/https";

export function requireAuthenticated<T>(request: CallableRequest<T>): string {
  const uid = request.auth?.uid;
  if (!uid) {
    throw new HttpsError("unauthenticated", "Authentication is required.");
  }
  return uid;
}

export function assertSelfOrAdmin<T>(
  callerUid: string,
  targetUid: string,
  request: CallableRequest<T>,
): void {
  const isAdmin = request.auth?.token.admin === true;
  if (callerUid !== targetUid && !isAdmin) {
    throw new HttpsError(
      "permission-denied",
      "You can only manage your own account data.",
    );
  }
}
