import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/core/constants/error_constants.dart';
import 'package:tictac/core/domain/errors/app_exception.dart';
import 'package:tictac/core/errors/error_handler.dart';
import 'package:tictac/core/services/logger_service.dart';

class MockLoggerService extends Mock implements LoggerService {}

void main() {
  group('ErrorHandler', () {
    late ErrorHandler errorHandler;
    late MockLoggerService mockLogger;

    setUp(() {
      mockLogger = MockLoggerService();
      errorHandler = ErrorHandler(mockLogger);
      when(() => mockLogger.error(any(), any(), any())).thenReturn(null);
    });

    group('handleError', () {
      test('should return AppException if error is already AppException', () {
        const AppException originalException = AppException.network(
          translationKey: ErrorTranslationKeys.networkTimeout,
        );
        final StackTrace stackTrace = StackTrace.current;

        final AppException result = errorHandler.handleError(
          originalException,
          stackTrace,
          context: 'Test context',
        );

        expect(result, equals(originalException));
        verify(() => mockLogger.error('Test context', originalException, stackTrace)).called(1);
      });

      test('should log error with default context if not provided', () {
        final Exception error = Exception('Test error');
        final StackTrace stackTrace = StackTrace.current;

        errorHandler.handleError(error, stackTrace);

        verify(() => mockLogger.error(ErrorMessages.defaultContext, error, stackTrace)).called(1);
      });

      test('should log error with custom context if provided', () {
        final Exception error = Exception('Test error');
        final StackTrace stackTrace = StackTrace.current;

        errorHandler.handleError(error, stackTrace, context: 'Custom context');

        verify(() => mockLogger.error('Custom context', error, stackTrace)).called(1);
      });
    });

    group('Network errors', () {
      test('should return NetworkException with timeout key for timeout errors', () {
        final Exception error = Exception('Connection timeout');
        final StackTrace stackTrace = StackTrace.current;

        final AppException result = errorHandler.handleError(error, stackTrace);

        expect(result, isA<NetworkException>());
        expect(result.translationKey, equals(ErrorTranslationKeys.networkTimeout));
      });

      test('should return NetworkException with connection key for connection errors', () {
        final Exception error = Exception('No connection available');
        final StackTrace stackTrace = StackTrace.current;

        final AppException result = errorHandler.handleError(error, stackTrace);

        expect(result, isA<NetworkException>());
        expect(result.translationKey, equals(ErrorTranslationKeys.networkConnection));
      });

      test('should return NetworkException with generic key for network errors', () {
        final Exception error = Exception('Network socket error');
        final StackTrace stackTrace = StackTrace.current;

        final AppException result = errorHandler.handleError(error, stackTrace);

        expect(result, isA<NetworkException>());
        expect(result.translationKey, equals(ErrorTranslationKeys.networkGeneric));
      });
    });

    group('Storage errors', () {
      test('should return StorageException with permission key for permission errors', () {
        final Exception error = Exception('Storage permission denied');
        final StackTrace stackTrace = StackTrace.current;

        final AppException result = errorHandler.handleError(error, stackTrace);

        expect(result, isA<StorageException>());
        expect(result.translationKey, equals(ErrorTranslationKeys.storagePermission));
      });

      test('should return StorageException with quota key for quota errors', () {
        final Exception error = Exception('Storage quota exceeded');
        final StackTrace stackTrace = StackTrace.current;

        final AppException result = errorHandler.handleError(error, stackTrace);

        expect(result, isA<StorageException>());
        expect(result.translationKey, equals(ErrorTranslationKeys.storageQuota));
      });

      test('should return StorageException with generic key for storage errors', () {
        final Exception error = Exception('Database error occurred');
        final StackTrace stackTrace = StackTrace.current;

        final AppException result = errorHandler.handleError(error, stackTrace);

        expect(result, isA<StorageException>());
        expect(result.translationKey, equals(ErrorTranslationKeys.storageGeneric));
      });

      test('should return StorageException for Firestore errors', () {
        final Exception error = Exception('Firestore database error');
        final StackTrace stackTrace = StackTrace.current;

        final AppException result = errorHandler.handleError(error, stackTrace);

        expect(result, isA<StorageException>());
        expect(result.translationKey, equals(ErrorTranslationKeys.storageGeneric));
      });
    });

    group('Authentication errors', () {
      test('should return AuthenticationException with cancelled key for cancelled errors', () {
        final Exception error = Exception('Auth signin cancelled');
        final StackTrace stackTrace = StackTrace.current;

        final AppException result = errorHandler.handleError(error, stackTrace);

        expect(result, isA<AuthenticationException>());
        expect(result.translationKey, equals(ErrorTranslationKeys.authCancelled));
      });

      test('should return AuthenticationException with invalid key for invalid credentials', () {
        final Exception error = Exception('Auth invalid credentials');
        final StackTrace stackTrace = StackTrace.current;

        final AppException result = errorHandler.handleError(error, stackTrace);

        expect(result, isA<AuthenticationException>());
        expect(result.translationKey, equals(ErrorTranslationKeys.authInvalid));
      });

      test('should return AuthenticationException with generic key for auth errors', () {
        final Exception error = Exception('Authentication failed');
        final StackTrace stackTrace = StackTrace.current;

        final AppException result = errorHandler.handleError(error, stackTrace);

        expect(result, isA<AuthenticationException>());
        expect(result.translationKey, equals(ErrorTranslationKeys.authGeneric));
      });

      test('should return AuthenticationException for signin errors', () {
        final Exception error = Exception('Signin error occurred');
        final StackTrace stackTrace = StackTrace.current;

        final AppException result = errorHandler.handleError(error, stackTrace);

        expect(result, isA<AuthenticationException>());
        expect(result.translationKey, equals(ErrorTranslationKeys.authGeneric));
      });
    });

    group('Unknown errors', () {
      test('should return UnknownException for unknown errors', () {
        final Exception error = Exception('Some random error');
        final StackTrace stackTrace = StackTrace.current;

        final AppException result = errorHandler.handleError(error, stackTrace);

        expect(result, isA<UnknownException>());
        expect(result.translationKey, equals(ErrorTranslationKeys.unknown));
      });

      test('should preserve original error in UnknownException', () {
        final Exception error = Exception('Some random error');
        final StackTrace stackTrace = StackTrace.current;

        final UnknownException result = errorHandler.handleError(error, stackTrace) as UnknownException;

        expect(result.originalError, equals(error));
      });
    });
  });
}
