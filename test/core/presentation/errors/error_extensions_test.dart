import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/core/constants/error_constants.dart';
import 'package:tictac/core/domain/errors/app_exception.dart';
import 'package:tictac/core/presentation/errors/error_extensions.dart';

void main() {
  group('AsyncValueErrorExtension', () {
    group('appException', () {
      test('should return AppException when error is AppException', () {
        const AppException exception = AppException.network(
          translationKey: ErrorTranslationKeys.networkTimeout,
        );
        final AsyncValue<dynamic> asyncValue = AsyncValue<dynamic>.error(exception, StackTrace.current);

        expect(asyncValue.appException, equals(exception));
      });

      test('should return null when error is not AppException', () {
        final AsyncValue<dynamic> asyncValue = AsyncValue<dynamic>.error(
          Exception('Regular exception'),
          StackTrace.current,
        );

        expect(asyncValue.appException, isNull);
      });

      test('should return null when no error', () {
        const AsyncValue<String> asyncValue = AsyncValue<String>.data('test');

        expect(asyncValue.appException, isNull);
      });

      test('should return null when loading', () {
        const AsyncValue<dynamic> asyncValue = AsyncValue<dynamic>.loading();

        expect(asyncValue.appException, isNull);
      });
    });

    group('isRetryable', () {
      test('should return true for retryable NetworkException', () {
        const AppException exception = AppException.network(
          translationKey: ErrorTranslationKeys.networkTimeout,
        );
        final AsyncValue<dynamic> asyncValue = AsyncValue<dynamic>.error(exception, StackTrace.current);

        expect(asyncValue.isRetryable, isTrue);
      });

      test('should return true for retryable AuthenticationException', () {
        const AppException exception = AppException.authentication(
          translationKey: ErrorTranslationKeys.authCancelled,
        );
        final AsyncValue<dynamic> asyncValue = AsyncValue<dynamic>.error(exception, StackTrace.current);

        expect(asyncValue.isRetryable, isTrue);
      });

      test('should return false for non-retryable StorageException', () {
        const AppException exception = AppException.storage(
          translationKey: ErrorTranslationKeys.storagePermission,
        );
        final AsyncValue<dynamic> asyncValue = AsyncValue<dynamic>.error(exception, StackTrace.current);

        expect(asyncValue.isRetryable, isFalse);
      });

      test('should return false for non-retryable ValidationException', () {
        const AppException exception = AppException.validation(
          translationKey: 'errorValidation',
        );
        final AsyncValue<dynamic> asyncValue = AsyncValue<dynamic>.error(exception, StackTrace.current);

        expect(asyncValue.isRetryable, isFalse);
      });

      test('should return false for non-retryable UnknownException', () {
        const AppException exception = AppException.unknown(
          translationKey: ErrorTranslationKeys.unknown,
        );
        final AsyncValue<dynamic> asyncValue = AsyncValue<dynamic>.error(exception, StackTrace.current);

        expect(asyncValue.isRetryable, isFalse);
      });

      test('should return false when error is not AppException', () {
        final AsyncValue<dynamic> asyncValue = AsyncValue<dynamic>.error(
          Exception('Regular exception'),
          StackTrace.current,
        );

        expect(asyncValue.isRetryable, isFalse);
      });

      test('should return false when no error', () {
        const AsyncValue<String> asyncValue = AsyncValue<String>.data('test');

        expect(asyncValue.isRetryable, isFalse);
      });
    });
  });
}

