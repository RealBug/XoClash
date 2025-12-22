import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/core/constants/language_codes.dart';
import 'package:tictac/features/settings/domain/entities/settings.dart';
import 'package:tictac/features/settings/domain/repositories/settings_repository.dart';
import 'package:tictac/features/settings/domain/usecases/set_language_usecase.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(const Settings());
  });

  late SetLanguageUseCase useCase;
  late MockSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockSettingsRepository();
    useCase = SetLanguageUseCase(mockRepository);
  });

  group('SetLanguageUseCase', () {
    test('should set language and save', () async {
      const Settings initialSettings = Settings();
      const Settings updatedSettings = Settings(languageCode: LanguageCodes.french);

      when(() => mockRepository.getSettings())
          .thenAnswer((_) async => initialSettings);
      when(() => mockRepository.saveSettings(any()))
          .thenAnswer((_) async => Future<void>.value());

      await useCase.execute(LanguageCodes.french);

      verify(() => mockRepository.getSettings()).called(1);
      verify(() => mockRepository.saveSettings(updatedSettings)).called(1);
    });

    test('should preserve other settings when changing language', () async {
      const Settings initialSettings = Settings(
        isDarkMode: false,
        soundFxEnabled: false,
      );
      const Settings expectedSettings = Settings(
        isDarkMode: false,
        soundFxEnabled: false,
        languageCode: LanguageCodes.french,
      );

      when(() => mockRepository.getSettings())
          .thenAnswer((_) async => initialSettings);
      when(() => mockRepository.saveSettings(any()))
          .thenAnswer((_) async => Future<void>.value());

      await useCase.execute(LanguageCodes.french);

      verify(() => mockRepository.saveSettings(expectedSettings)).called(1);
    });

    test('should propagate errors from repository', () async {
      when(() => mockRepository.getSettings())
          .thenThrow(Exception('Error getting settings'));

      expect(() => useCase.execute(LanguageCodes.french), throwsException);
    });
  });
}

