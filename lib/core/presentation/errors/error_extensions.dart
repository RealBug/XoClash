import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictac/core/domain/errors/app_exception.dart';

extension AsyncValueErrorExtension<T> on AsyncValue<T> {
  AppException? get appException {
    return hasError && error is AppException ? error as AppException : null;
  }

  bool get isRetryable {
    return appException?.isRetryable ?? false;
  }
}
