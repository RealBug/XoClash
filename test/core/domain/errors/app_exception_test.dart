import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/core/constants/error_constants.dart';
import 'package:tictac/core/domain/errors/app_exception.dart';

void main() {
  group('AppException', () {
    group('getTranslationKey extension getter', () {
      test('should return translationKey for NetworkException', () {
        const AppException exception = AppException.network(
          translationKey: ErrorTranslationKeys.networkTimeout,
        );

        expect(exception.getTranslationKey, equals(ErrorTranslationKeys.networkTimeout));
      });

      test('should return translationKey for StorageException', () {
        const AppException exception = AppException.storage(
          translationKey: ErrorTranslationKeys.storagePermission,
        );

        expect(exception.getTranslationKey, equals(ErrorTranslationKeys.storagePermission));
      });

      test('should return translationKey for AuthenticationException', () {
        const AppException exception = AppException.authentication(
          translationKey: ErrorTranslationKeys.authCancelled,
        );

        expect(exception.getTranslationKey, equals(ErrorTranslationKeys.authCancelled));
      });

      test('should return translationKey for ValidationException', () {
        const AppException exception = AppException.validation(
          translationKey: 'errorValidation',
        );

        expect(exception.getTranslationKey, equals('errorValidation'));
      });

      test('should return translationKey for UnknownException', () {
        const AppException exception = AppException.unknown(
          translationKey: ErrorTranslationKeys.unknown,
        );

        expect(exception.getTranslationKey, equals(ErrorTranslationKeys.unknown));
      });
    });

    group('errorCode', () {
      test('should return errorCode when provided for NetworkException', () {
        const AppException exception = AppException.network(
          translationKey: ErrorTranslationKeys.networkTimeout,
          code: 'NETWORK_TIMEOUT',
        );

        expect(exception.errorCode, equals('NETWORK_TIMEOUT'));
      });

      test('should return errorCode when provided for StorageException', () {
        const AppException exception = AppException.storage(
          translationKey: ErrorTranslationKeys.storagePermission,
          code: 'STORAGE_ERROR',
        );

        expect(exception.errorCode, equals('STORAGE_ERROR'));
      });

      test('should return errorCode when provided for AuthenticationException', () {
        const AppException exception = AppException.authentication(
          translationKey: ErrorTranslationKeys.authCancelled,
          code: 'AUTH_ERROR',
        );

        expect(exception.errorCode, equals('AUTH_ERROR'));
      });

      test('should return errorCode when provided for ValidationException', () {
        const AppException exception = AppException.validation(
          translationKey: 'errorValidation',
          code: 'VALIDATION_ERROR',
        );

        expect(exception.errorCode, equals('VALIDATION_ERROR'));
      });

      test('should return errorCode when provided for UnknownException', () {
        const AppException exception = AppException.unknown(
          translationKey: ErrorTranslationKeys.unknown,
          code: 'UNKNOWN_ERROR',
        );

        expect(exception.errorCode, equals('UNKNOWN_ERROR'));
      });

      test('should return null when errorCode not provided', () {
        const AppException exception = AppException.network(
          translationKey: ErrorTranslationKeys.networkTimeout,
        );

        expect(exception.errorCode, isNull);
      });
    });

    group('isRetryable', () {
      test('should return true for NetworkException', () {
        const AppException exception = AppException.network(
          translationKey: ErrorTranslationKeys.networkTimeout,
        );

        expect(exception.isRetryable, isTrue);
      });

      test('should return false for StorageException', () {
        const AppException exception = AppException.storage(
          translationKey: ErrorTranslationKeys.storagePermission,
        );

        expect(exception.isRetryable, isFalse);
      });

      test('should return true for AuthenticationException', () {
        const AppException exception = AppException.authentication(
          translationKey: ErrorTranslationKeys.authCancelled,
        );

        expect(exception.isRetryable, isTrue);
      });

      test('should return false for ValidationException', () {
        const AppException exception = AppException.validation(
          translationKey: 'errorValidation',
        );

        expect(exception.isRetryable, isFalse);
      });

      test('should return false for UnknownException', () {
        const AppException exception = AppException.unknown(
          translationKey: ErrorTranslationKeys.unknown,
        );

        expect(exception.isRetryable, isFalse);
      });
    });

    group('equality', () {
      test('should be equal when same type and same properties', () {
        const AppException exception1 = AppException.network(
          translationKey: ErrorTranslationKeys.networkTimeout,
          code: 'NETWORK_TIMEOUT',
        );
        const AppException exception2 = AppException.network(
          translationKey: ErrorTranslationKeys.networkTimeout,
          code: 'NETWORK_TIMEOUT',
        );

        expect(exception1, equals(exception2));
      });

      test('should not be equal when different types', () {
        const AppException exception1 = AppException.network(
          translationKey: ErrorTranslationKeys.networkTimeout,
        );
        const AppException exception2 = AppException.storage(
          translationKey: ErrorTranslationKeys.storagePermission,
        );

        expect(exception1, isNot(equals(exception2)));
      });

      test('should not be equal when different translationKeys', () {
        const AppException exception1 = AppException.network(
          translationKey: ErrorTranslationKeys.networkTimeout,
        );
        const AppException exception2 = AppException.network(
          translationKey: ErrorTranslationKeys.networkConnection,
        );

        expect(exception1, isNot(equals(exception2)));
      });

      test('should not be equal when different errorCodes', () {
        const AppException exception1 = AppException.network(
          translationKey: ErrorTranslationKeys.networkTimeout,
          code: 'NETWORK_TIMEOUT',
        );
        const AppException exception2 = AppException.network(
          translationKey: ErrorTranslationKeys.networkTimeout,
          code: 'NETWORK_ERROR',
        );

        expect(exception1, isNot(equals(exception2)));
      });
    });

    group('stackTrace', () {
      test('should preserve stackTrace when provided', () {
        final StackTrace stackTrace = StackTrace.current;
        final AppException exception = AppException.network(
          translationKey: ErrorTranslationKeys.networkTimeout,
          stackTrace: stackTrace,
        );

        expect(
            exception.when(
              network: (String translationKey, String? code, StackTrace? st) => st,
              storage: (String translationKey, String? code, StackTrace? st) => st,
              authentication: (String translationKey, String? code, StackTrace? st) => st,
              validation: (String translationKey, String? code, StackTrace? st) => st,
              unknown: (String translationKey, String? code, Object? originalError, StackTrace? st) => st,
            ),
            equals(stackTrace));
      });

      test('should allow null stackTrace', () {
        const AppException exception = AppException.network(
          translationKey: ErrorTranslationKeys.networkTimeout,
        );

        expect(
            exception.when(
              network: (String translationKey, String? code, StackTrace? st) => st,
              storage: (String translationKey, String? code, StackTrace? st) => st,
              authentication: (String translationKey, String? code, StackTrace? st) => st,
              validation: (String translationKey, String? code, StackTrace? st) => st,
              unknown: (String translationKey, String? code, Object? originalError, StackTrace? st) => st,
            ),
            isNull);
      });
    });

    group('originalError', () {
      test('should preserve originalError for UnknownException', () {
        final Exception originalError = Exception('Original error');
        final AppException exception = AppException.unknown(
          translationKey: ErrorTranslationKeys.unknown,
          originalError: originalError,
        );

        expect(
            exception.when(
              network: (String translationKey, String? code, StackTrace? stackTrace) => null,
              storage: (String translationKey, String? code, StackTrace? stackTrace) => null,
              authentication: (String translationKey, String? code, StackTrace? stackTrace) => null,
              validation: (String translationKey, String? code, StackTrace? stackTrace) => null,
              unknown: (String translationKey, String? code, Object? error, StackTrace? stackTrace) => error,
            ),
            equals(originalError));
      });

      test('should allow null originalError for UnknownException', () {
        const AppException exception = AppException.unknown(
          translationKey: ErrorTranslationKeys.unknown,
        );

        expect(
            exception.when(
              network: (String translationKey, String? code, StackTrace? stackTrace) => null,
              storage: (String translationKey, String? code, StackTrace? stackTrace) => null,
              authentication: (String translationKey, String? code, StackTrace? stackTrace) => null,
              validation: (String translationKey, String? code, StackTrace? stackTrace) => null,
              unknown: (String translationKey, String? code, Object? error, StackTrace? stackTrace) => error,
            ),
            isNull);
      });
    });
  });
}
