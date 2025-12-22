import 'package:tictac/core/constants/error_constants.dart';
import 'package:tictac/core/domain/errors/app_exception.dart';
import 'package:tictac/l10n/app_localizations.dart';

extension AppExceptionLocalizationsExtension on AppException {
  String getUserMessage(AppLocalizations l10n) {
    return when(
      network: (String translationKey, String? code, StackTrace? stackTrace) => _getMessage(l10n, translationKey),
      storage: (String translationKey, String? code, StackTrace? stackTrace) => _getMessage(l10n, translationKey),
      authentication: (String translationKey, String? code, StackTrace? stackTrace) => _getMessage(l10n, translationKey),
      validation: (String translationKey, String? code, StackTrace? stackTrace) => _getMessage(l10n, translationKey),
      unknown: (String translationKey, String? code, Object? originalError, StackTrace? stackTrace) => _getMessage(l10n, translationKey),
    );
  }

  String _getMessage(AppLocalizations l10n, String key) {
    switch (key) {
      case ErrorTranslationKeys.networkTimeout:
        return l10n.errorNetworkTimeout;
      case ErrorTranslationKeys.networkConnection:
        return l10n.errorNetworkConnection;
      case ErrorTranslationKeys.networkGeneric:
        return l10n.errorNetworkGeneric;
      case ErrorTranslationKeys.storagePermission:
        return l10n.errorStoragePermission;
      case ErrorTranslationKeys.storageQuota:
        return l10n.errorStorageQuota;
      case ErrorTranslationKeys.storageGeneric:
        return l10n.errorStorageGeneric;
      case ErrorTranslationKeys.authCancelled:
        return l10n.errorAuthCancelled;
      case ErrorTranslationKeys.authInvalid:
        return l10n.errorAuthInvalid;
      case ErrorTranslationKeys.authGeneric:
        return l10n.errorAuthGeneric;
      case ErrorTranslationKeys.unknown:
        return l10n.errorUnknown;
      default:
        return l10n.errorUnknown;
    }
  }
}
