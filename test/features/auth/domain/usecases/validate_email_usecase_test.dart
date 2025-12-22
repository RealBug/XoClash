import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/features/auth/domain/usecases/validate_email_usecase.dart';
import 'package:tictac/l10n/app_localizations.dart';
import 'package:tictac/l10n/app_localizations_en.dart';

void main() {
  group('ValidateEmailUseCase', () {
    late ValidateEmailUseCase useCase;
    late AppLocalizations l10n;

    setUp(() {
      useCase = ValidateEmailUseCase();
      l10n = AppLocalizationsEn();
    });

    test('should return null for valid email', () {
      final result = useCase.execute('test@example.com', l10n);
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

    test('should return error for email without @', () {
      final result = useCase.execute('invalidemail.com', l10n);
      expect(result, isNotNull);
    });
  });
}

