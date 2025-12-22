import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/features/settings/domain/entities/settings.dart';
import 'package:tictac/features/settings/domain/repositories/settings_repository.dart';
import 'package:tictac/features/settings/domain/usecases/set_use_emojis_usecase.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(const Settings());
  });

  late SetUseEmojisUseCase useCase;
  late MockSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockSettingsRepository();
    useCase = SetUseEmojisUseCase(mockRepository);
  });

  group('SetUseEmojisUseCase', () {
    test('should set useEmojis to true and save', () async {
      const Settings initialSettings = Settings();
      const Settings expectedSettings = Settings(useEmojis: true);

      when(() => mockRepository.getSettings())
          .thenAnswer((_) async => initialSettings);
      when(() => mockRepository.saveSettings(any()))
          .thenAnswer((_) async => Future<void>.value());

      await useCase.execute(true);

      verify(() => mockRepository.saveSettings(expectedSettings)).called(1);
    });

    test('should set useEmojis to false and save', () async {
      const Settings initialSettings = Settings(useEmojis: true);
      const Settings expectedSettings = Settings();

      when(() => mockRepository.getSettings())
          .thenAnswer((_) async => initialSettings);
      when(() => mockRepository.saveSettings(any()))
          .thenAnswer((_) async => Future<void>.value());

      await useCase.execute(false);

      verify(() => mockRepository.saveSettings(expectedSettings)).called(1);
    });

    test('should preserve other settings', () async {
      const Settings initialSettings = Settings(
        isDarkMode: false,
        xEmoji: '😀',
        oEmoji: '😊',
      );
      const Settings expectedSettings = Settings(
        isDarkMode: false,
        xEmoji: '😀',
        oEmoji: '😊',
        useEmojis: true,
      );

      when(() => mockRepository.getSettings())
          .thenAnswer((_) async => initialSettings);
      when(() => mockRepository.saveSettings(any()))
          .thenAnswer((_) async => Future<void>.value());

      await useCase.execute(true);

      verify(() => mockRepository.saveSettings(expectedSettings)).called(1);
    });

    test('should propagate errors from repository', () async {
      when(() => mockRepository.getSettings())
          .thenThrow(Exception('Error getting settings'));

      expect(() => useCase.execute(true), throwsException);
    });
  });
}

