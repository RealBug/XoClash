import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/core/constants/app_constants.dart';
import 'package:tictac/features/game/domain/usecases/validate_game_id_usecase.dart';
import 'package:tictac/l10n/app_localizations.dart';
import 'package:tictac/l10n/app_localizations_en.dart';

void main() {
  group('ValidateGameIdUseCase', () {
    late ValidateGameIdUseCase useCase;
    late AppLocalizations l10n;

    setUp(() {
      useCase = ValidateGameIdUseCase();
      l10n = AppLocalizationsEn();
    });

    test('should return null for valid game ID', () {
      final validGameId = 'A' * AppConstants.gameIdLength;
      final result = useCase.execute(validGameId, l10n);
      expect(result, isNull);
    });

    test('should return error for null value', () {
      final result = useCase.execute(null, l10n);
      expect(result, isNotNull);
    });

    test('should return error for empty value', () {
      final result = useCase.execute('', l10n);
      expect(result, isNotNull);
    });

    test('should return error for game ID too short', () {
      final shortGameId = 'A' * (AppConstants.gameIdLength - 1);
      final result = useCase.execute(shortGameId, l10n);
      expect(result, isNotNull);
    });

    test('should return error for game ID too long', () {
      final longGameId = 'A' * (AppConstants.gameIdLength + 1);
      final result = useCase.execute(longGameId, l10n);
      expect(result, isNotNull);
    });

    test('should convert to uppercase and validate', () {
      final lowercaseGameId = 'a' * AppConstants.gameIdLength;
      final result = useCase.execute(lowercaseGameId, l10n);
      expect(result, isNull);
    });

    test('should return error for invalid characters', () {
      final invalidGameId = 'A' * (AppConstants.gameIdLength - 1) + '!';
      final result = useCase.execute(invalidGameId, l10n);
      expect(result, isNotNull);
    });
  });
}

