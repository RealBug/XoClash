import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/features/settings/domain/entities/settings.dart';
import 'package:tictac/features/settings/domain/repositories/settings_repository.dart';
import 'package:tictac/features/settings/domain/usecases/toggle_sound_fx_usecase.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(const Settings());
  });

  late ToggleSoundFxUseCase useCase;
  late MockSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockSettingsRepository();
    useCase = ToggleSoundFxUseCase(mockRepository);
  });

  group('ToggleSoundFxUseCase', () {
    test('should toggle sound fx from true to false', () async {
      const Settings initialSettings = Settings();
      const Settings expectedSettings = Settings(soundFxEnabled: false);

      when(() => mockRepository.getSettings())
          .thenAnswer((_) async => initialSettings);
      when(() => mockRepository.saveSettings(any()))
          .thenAnswer((_) async => Future<void>.value());

      await useCase.execute();

      verify(() => mockRepository.saveSettings(expectedSettings)).called(1);
    });

    test('should toggle sound fx from false to true', () async {
      const Settings initialSettings = Settings(soundFxEnabled: false);
      const Settings expectedSettings = Settings();

      when(() => mockRepository.getSettings())
          .thenAnswer((_) async => initialSettings);
      when(() => mockRepository.saveSettings(any()))
          .thenAnswer((_) async => Future<void>.value());

      await useCase.execute();

      verify(() => mockRepository.saveSettings(expectedSettings)).called(1);
    });

    test('should preserve other settings when toggling', () async {
      const Settings initialSettings = Settings(
        isDarkMode: false,
      );
      const Settings expectedSettings = Settings(
        soundFxEnabled: false,
        isDarkMode: false,
      );

      when(() => mockRepository.getSettings())
          .thenAnswer((_) async => initialSettings);
      when(() => mockRepository.saveSettings(any()))
          .thenAnswer((_) async => Future<void>.value());

      await useCase.execute();

      verify(() => mockRepository.saveSettings(expectedSettings)).called(1);
    });

    test('should propagate errors from repository', () async {
      when(() => mockRepository.getSettings())
          .thenThrow(Exception('Error getting settings'));

      expect(() => useCase.execute(), throwsException);
    });
  });
}

