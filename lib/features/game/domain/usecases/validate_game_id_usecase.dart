import 'package:tictac/core/constants/app_constants.dart';
import 'package:tictac/l10n/app_localizations.dart';

class ValidateGameIdUseCase {
  String? execute(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.enterGameCode;
    }
    final trimmed = value.trim().toUpperCase();
    if (trimmed.length != AppConstants.gameIdLength) {
      return l10n.invalidGameCode;
    }
    final isValid = trimmed.split('').every(
          (String char) => AppConstants.gameIdChars.contains(char),
        );
    if (!isValid) {
      return l10n.invalidGameCode;
    }
    return null;
  }
}

