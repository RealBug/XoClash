import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/features/auth/domain/usecases/validate_password_usecase.dart';
import 'package:tictac/l10n/app_localizations.dart';
import 'package:tictac/l10n/app_localizations_en.dart';

void main() {
  group('ValidatePasswordUseCase', () {
    late ValidatePasswordUseCase useCase;
    late AppLocalizations l10n;

    setUp(() {
      useCase = ValidatePasswordUseCase();
      l10n = AppLocalizationsEn();
    });

    test('should return null for valid password', () {
      final result = useCase.execute('password123', l10n);
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

    test('should return error for password too short', () {
      final result = useCase.execute('12345', l10n);
      expect(result, isNotNull);
    });
  });
}

