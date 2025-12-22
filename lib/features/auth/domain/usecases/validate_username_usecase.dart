import 'package:tictac/core/constants/app_constants.dart';
import 'package:tictac/l10n/app_localizations.dart';

class ValidateUsernameUseCase {
  String? execute(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.pleaseEnterUsername;
    }
    final trimmed = value.trim();
    if (trimmed.length < AppConstants.minUsernameLength) {
      return l10n.usernameMinLength;
    }
    if (trimmed.length > AppConstants.maxUsernameLength) {
      return l10n.usernameMaxLength;
    }
    return null;
  }
}

