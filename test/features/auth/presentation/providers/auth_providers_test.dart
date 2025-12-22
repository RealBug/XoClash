import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/features/auth/domain/usecases/validate_email_usecase.dart';
import 'package:tictac/features/auth/domain/usecases/validate_password_usecase.dart';
import 'package:tictac/features/auth/domain/usecases/validate_username_usecase.dart';
import 'package:tictac/features/auth/presentation/providers/auth_providers.dart';
import 'package:tictac/l10n/app_localizations_en.dart';

void main() {
  group('Auth Providers', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('validateUsernameUseCaseProvider', () {
      test('should provide ValidateUsernameUseCase instance', () {
        final useCase = container.read(validateUsernameUseCaseProvider);

        expect(useCase, isA<ValidateUsernameUseCase>());
        expect(useCase, isNotNull);
      });

      test('should provide same instance on multiple reads', () {
        final useCase1 = container.read(validateUsernameUseCaseProvider);
        final useCase2 = container.read(validateUsernameUseCaseProvider);

        expect(useCase1, same(useCase2));
      });

      test('should execute validation correctly', () {
        final useCase = container.read(validateUsernameUseCaseProvider);
        final l10n = AppLocalizationsEn();

        final result = useCase.execute('ValidUser', l10n);
        expect(result, isNull);
      });
    });

    group('validateEmailUseCaseProvider', () {
      test('should provide ValidateEmailUseCase instance', () {
        final useCase = container.read(validateEmailUseCaseProvider);

        expect(useCase, isA<ValidateEmailUseCase>());
        expect(useCase, isNotNull);
      });

      test('should provide same instance on multiple reads', () {
        final useCase1 = container.read(validateEmailUseCaseProvider);
        final useCase2 = container.read(validateEmailUseCaseProvider);

        expect(useCase1, same(useCase2));
      });

      test('should execute validation correctly', () {
        final useCase = container.read(validateEmailUseCaseProvider);
        final l10n = AppLocalizationsEn();

        final result = useCase.execute('test@example.com', l10n);
        expect(result, isNull);
      });
    });

    group('validatePasswordUseCaseProvider', () {
      test('should provide ValidatePasswordUseCase instance', () {
        final useCase = container.read(validatePasswordUseCaseProvider);

        expect(useCase, isA<ValidatePasswordUseCase>());
        expect(useCase, isNotNull);
      });

      test('should provide same instance on multiple reads', () {
        final useCase1 = container.read(validatePasswordUseCaseProvider);
        final useCase2 = container.read(validatePasswordUseCaseProvider);

        expect(useCase1, same(useCase2));
      });

      test('should execute validation correctly', () {
        final useCase = container.read(validatePasswordUseCaseProvider);
        final l10n = AppLocalizationsEn();

        final result = useCase.execute('password123', l10n);
        expect(result, isNull);
      });
    });
  });
}

