import 'package:tictac/l10n/app_localizations.dart';

class ValidatePasswordUseCase {
  String? execute(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.pleaseEnterPassword;
    }
    if (value.length < 6) {
      return l10n.passwordMinLength;
    }
    return null;
  }
}

