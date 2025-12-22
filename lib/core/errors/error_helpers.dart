import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictac/core/constants/error_constants.dart';
import 'package:tictac/core/domain/errors/app_exception.dart';
import 'package:tictac/core/errors/error_handler.dart';

class ErrorHelpers {
  ErrorHelpers._();

  static Future<T> handleAsyncError<T>({
    required Ref ref,
    required Future<T> Function() action,
    required void Function(AppException, StackTrace) onError,
    String? context,
    bool shouldRethrow = false,
  }) async {
    try {
      return await action();
    } catch (e, stackTrace) {
      final errorHandler = ref.read(errorHandlerProvider);
      final appException = errorHandler.handleError(e, stackTrace, context: context ?? ErrorMessages.defaultContext);

      onError(appException, stackTrace);

      if (shouldRethrow) {
        throw appException;
      }

      rethrow;
    }
  }
}
