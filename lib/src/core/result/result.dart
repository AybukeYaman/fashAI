import 'package:fashai/src/core/result/failure.dart';

typedef AppResult<T> = Result<T, Failure>;

sealed class Result<T, F extends Failure> {
  const Result();

  bool get isSuccess => this is Success<T, F>;
  bool get isFailure => this is FailureResult<T, F>;

  R when<R>({
    required R Function(T value) success,
    required R Function(F failure) failure,
  }) {
    return switch (this) {
      Success<T, F>(:final value) => success(value),
      FailureResult<T, F>(:final error) => failure(error),
    };
  }
}

final class Success<T, F extends Failure> extends Result<T, F> {
  const Success(this.value);

  final T value;
}

final class FailureResult<T, F extends Failure> extends Result<T, F> {
  const FailureResult(this.error);

  final F error;
}
