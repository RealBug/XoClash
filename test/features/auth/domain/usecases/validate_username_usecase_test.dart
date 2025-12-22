import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/core/constants/app_constants.dart';
import 'package:tictac/features/auth/domain/usecases/validate_username_usecase.dart';
import 'package:tictac/l10n/app_localizations.dart';
import 'package:tictac/l10n/app_localizations_en.dart';

void main() {
  group('ValidateUsernameUseCase', () {
    late ValidateUsernameUseCase useCase;
    late AppLocalizations l10n;

    setUp(() {
      useCase = ValidateUsernameUseCase();
      l10n = AppLocalizationsEn();
    });

    test('should return null for valid username', () {
      final result = useCase.execute('ValidUser', l10n);
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

    test('should return error for username too short', () {
      final shortUsername = 'a' * (AppConstants.minUsernameLength - 1);
      final result = useCase.execute(shortUsername, l10n);
      expect(result, isNotNull);
    });

    test('should return error for username too long', () {
      final longUsername = 'a' * (AppConstants.maxUsernameLength + 1);
      final result = useCase.execute(longUsername, l10n);
      expect(result, isNotNull);
    });

    test('should trim whitespace before validation', () {
      final result = useCase.execute('  ValidUser  ', l10n);
      expect(result, isNull);
    });
  });
}

