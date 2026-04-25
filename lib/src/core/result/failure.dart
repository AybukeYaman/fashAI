sealed class Failure {
  const Failure({
    required this.message,
    this.code,
    this.cause,
    this.stackTrace,
  });

  final String message;
  final String? code;
  final Object? cause;
  final StackTrace? stackTrace;
}

final class FirestoreFailure extends Failure {
  const FirestoreFailure({
    required super.message,
    super.code,
    super.cause,
    super.stackTrace,
  });
}

final class PermissionFailure extends Failure {
  const PermissionFailure({
    required super.message,
    super.code,
    super.cause,
    super.stackTrace,
  });
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure({required super.message, super.code, super.cause});
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    required super.message,
    super.code,
    super.cause,
    super.stackTrace,
  });
}
