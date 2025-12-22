import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/core/constants/error_constants.dart';
import 'package:tictac/core/domain/errors/app_exception.dart';
import 'package:tictac/core/presentation/errors/app_exception_localizations.dart';
import 'package:tictac/l10n/app_localizations_en.dart';

void main() {
  group('AppExceptionLocalizationsExtension', () {
    late AppLocalizationsEn l10n;

    setUp(() {
      l10n = AppLocalizationsEn();
    });

    group('getUserMessage', () {
      test('should return translated message for NetworkException', () {
        const AppException exception = AppException.network(
          translationKey: ErrorTranslationKeys.networkTimeout,
        );

        final String message = exception.getUserMessage(l10n);

        expect(message, equals(l10n.errorNetworkTimeout));
        expect(message, isNotEmpty);
      });

      test('should return translated message for StorageException', () {
        const AppException exception = AppException.storage(
          translationKey: ErrorTranslationKeys.storagePermission,
        );

        final String message = exception.getUserMessage(l10n);

        expect(message, equals(l10n.errorStoragePermission));
        expect(message, isNotEmpty);
      });

      test('should return translated message for AuthenticationException', () {
        const AppException exception = AppException.authentication(
          translationKey: ErrorTranslationKeys.authCancelled,
        );

        final String message = exception.getUserMessage(l10n);

        expect(message, equals(l10n.errorAuthCancelled));
        expect(message, isNotEmpty);
      });

      test('should return translated message for ValidationException', () {
        const AppException exception = AppException.validation(
          translationKey: ErrorTranslationKeys.unknown,
        );

        final String message = exception.getUserMessage(l10n);

        expect(message, equals(l10n.errorUnknown));
      });

      test('should return translated message for UnknownException', () {
        const AppException exception = AppException.unknown(
          translationKey: ErrorTranslationKeys.unknown,
        );

        final String message = exception.getUserMessage(l10n);

        expect(message, equals(l10n.errorUnknown));
        expect(message, isNotEmpty);
      });

      test('should return errorUnknown for unknown translationKey', () {
        const AppException exception = AppException.network(
          translationKey: 'unknownKey',
        );

        final String message = exception.getUserMessage(l10n);

        expect(message, equals(l10n.errorUnknown));
      });
    });

    group('all translation keys', () {
      test('should handle errorNetworkTimeout', () {
        const AppException exception = AppException.network(
          translationKey: ErrorTranslationKeys.networkTimeout,
        );
        expect(exception.getUserMessage(l10n), equals(l10n.errorNetworkTimeout));
      });

      test('should handle errorNetworkConnection', () {
        const AppException exception = AppException.network(
          translationKey: ErrorTranslationKeys.networkConnection,
        );
        expect(exception.getUserMessage(l10n), equals(l10n.errorNetworkConnection));
      });

      test('should handle errorNetworkGeneric', () {
        const AppException exception = AppException.network(
          translationKey: ErrorTranslationKeys.networkGeneric,
        );
        expect(exception.getUserMessage(l10n), equals(l10n.errorNetworkGeneric));
      });

      test('should handle errorStoragePermission', () {
        const AppException exception = AppException.storage(
          translationKey: ErrorTranslationKeys.storagePermission,
        );
        expect(exception.getUserMessage(l10n), equals(l10n.errorStoragePermission));
      });

      test('should handle errorStorageQuota', () {
        const AppException exception = AppException.storage(
          translationKey: ErrorTranslationKeys.storageQuota,
        );
        expect(exception.getUserMessage(l10n), equals(l10n.errorStorageQuota));
      });

      test('should handle errorStorageGeneric', () {
        const AppException exception = AppException.storage(
          translationKey: ErrorTranslationKeys.storageGeneric,
        );
        expect(exception.getUserMessage(l10n), equals(l10n.errorStorageGeneric));
      });

      test('should handle errorAuthCancelled', () {
        const AppException exception = AppException.authentication(
          translationKey: ErrorTranslationKeys.authCancelled,
        );
        expect(exception.getUserMessage(l10n), equals(l10n.errorAuthCancelled));
      });

      test('should handle errorAuthInvalid', () {
        const AppException exception = AppException.authentication(
          translationKey: ErrorTranslationKeys.authInvalid,
        );
        expect(exception.getUserMessage(l10n), equals(l10n.errorAuthInvalid));
      });

      test('should handle errorAuthGeneric', () {
        const AppException exception = AppException.authentication(
          translationKey: ErrorTranslationKeys.authGeneric,
        );
        expect(exception.getUserMessage(l10n), equals(l10n.errorAuthGeneric));
      });

      test('should handle errorUnknown', () {
        const AppException exception = AppException.unknown(
          translationKey: ErrorTranslationKeys.unknown,
        );
        expect(exception.getUserMessage(l10n), equals(l10n.errorUnknown));
      });
    });
  });
}

