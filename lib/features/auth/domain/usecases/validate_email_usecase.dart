import 'package:tictac/l10n/app_localizations.dart';

class ValidateEmailUseCase {
  String? execute(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.pleaseEnterEmail;
    }
    if (!value.contains('@')) {
      return l10n.invalidEmail;
    }
    return null;
  }
}

