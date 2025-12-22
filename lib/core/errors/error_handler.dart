import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictac/core/constants/error_constants.dart';
import 'package:tictac/core/domain/errors/app_exception.dart';
import 'package:tictac/core/providers/service_providers.dart';
import 'package:tictac/core/services/logger_service.dart';

class ErrorHandler {

  ErrorHandler(this._logger);
  final LoggerService _logger;

  AppException handleError(
    Object error,
    StackTrace? stackTrace, {
    String? context,
  }) {
    _logger.error(
      context ?? ErrorMessages.defaultContext,
      error,
      stackTrace,
    );

    if (error is AppException) {
      return error;
    }

    final errorString = error.toString().toLowerCase();

    if (errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('timeout') ||
        errorString.contains('socket')) {
      return AppException.network(
        translationKey: _getNetworkErrorTranslationKey(error),
        stackTrace: stackTrace,
      );
    }

    if (errorString.contains('storage') || errorString.contains('database') || errorString.contains('firestore')) {
      return AppException.storage(
        translationKey: _getStorageErrorTranslationKey(error),
        stackTrace: stackTrace,
      );
    }

    if (errorString.contains('auth') ||
        errorString.contains('authentication') ||
        errorString.contains('signin') ||
        errorString.contains('permission')) {
      return AppException.authentication(
        translationKey: _getAuthErrorTranslationKey(error),
        stackTrace: stackTrace,
      );
    }

    return AppException.unknown(
      translationKey: _getUnknownErrorTranslationKey(error),
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  String _getNetworkErrorTranslationKey(Object error) {
    final errorString = error.toString().toLowerCase();
    if (errorString.contains('timeout')) {
      return ErrorTranslationKeys.networkTimeout;
    }
    if (errorString.contains('connection')) {
      return ErrorTranslationKeys.networkConnection;
    }
    return ErrorTranslationKeys.networkGeneric;
  }

  String _getStorageErrorTranslationKey(Object error) {
    final errorString = error.toString().toLowerCase();
    if (errorString.contains('permission')) {
      return ErrorTranslationKeys.storagePermission;
    }
    if (errorString.contains('quota')) {
      return ErrorTranslationKeys.storageQuota;
    }
    return ErrorTranslationKeys.storageGeneric;
  }

  String _getAuthErrorTranslationKey(Object error) {
    final errorString = error.toString().toLowerCase();
    if (errorString.contains('cancelled')) {
      return ErrorTranslationKeys.authCancelled;
    }
    if (errorString.contains('invalid')) {
      return ErrorTranslationKeys.authInvalid;
    }
    return ErrorTranslationKeys.authGeneric;
  }

  String _getUnknownErrorTranslationKey(Object error) {
    return ErrorTranslationKeys.unknown;
  }
}

final Provider<ErrorHandler> errorHandlerProvider = Provider<ErrorHandler>(
  (Ref ref) => ErrorHandler(ref.read(loggerServiceProvider)),
);
