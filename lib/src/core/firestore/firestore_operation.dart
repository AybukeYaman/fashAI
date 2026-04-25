import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashai/src/core/result/failure.dart';
import 'package:fashai/src/core/result/result.dart';

Future<AppResult<T>> guardFirestore<T>(Future<T> Function() operation) async {
  try {
    return Success<T, Failure>(await operation());
  } catch (error, stackTrace) {
    return FailureResult<T, Failure>(_failureFromError(error, stackTrace));
  }
}

Stream<AppResult<T>> guardFirestoreStream<T>(
  Stream<T> Function() operation,
) async* {
  try {
    await for (final value in operation()) {
      yield Success<T, Failure>(value);
    }
  } catch (error, stackTrace) {
    yield FailureResult<T, Failure>(_failureFromError(error, stackTrace));
  }
}

Failure _failureFromError(Object error, StackTrace stackTrace) {
  if (error is FirebaseException) {
    if (error.code == 'permission-denied') {
      return PermissionFailure(
        message: error.message ?? 'Firestore permission denied.',
        code: error.code,
        cause: error,
        stackTrace: stackTrace,
      );
    }
    if (error.code == 'not-found') {
      return NotFoundFailure(
        message: error.message ?? 'Firestore document was not found.',
        code: error.code,
        cause: error,
      );
    }
    return FirestoreFailure(
      message: error.message ?? 'Firestore operation failed.',
      code: error.code,
      cause: error,
      stackTrace: stackTrace,
    );
  }

  if (error is StateError) {
    return UnexpectedFailure(
      message: error.message,
      cause: error,
      stackTrace: stackTrace,
    );
  }

  return UnexpectedFailure(
    message: 'Unexpected data-layer failure.',
    cause: error,
    stackTrace: stackTrace,
  );
}
