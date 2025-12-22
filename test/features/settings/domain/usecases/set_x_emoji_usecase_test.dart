import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/features/settings/domain/entities/settings.dart';
import 'package:tictac/features/settings/domain/repositories/settings_repository.dart';
import 'package:tictac/features/settings/domain/usecases/set_x_emoji_usecase.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(const Settings());
  });

  late SetXEmojiUseCase useCase;
  late MockSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockSettingsRepository();
    useCase = SetXEmojiUseCase(mockRepository);
  });

  group('SetXEmojiUseCase', () {
    test('should set x emoji and save', () async {
      const Settings initialSettings = Settings();
      const String emoji = '😀';
      const Settings expectedSettings = Settings(xEmoji: emoji);

      when(() => mockRepository.getSettings())
          .thenAnswer((_) async => initialSettings);
      when(() => mockRepository.saveSettings(any()))
          .thenAnswer((_) async => Future<void>.value());

      await useCase.execute(emoji);

      verify(() => mockRepository.saveSettings(expectedSettings)).called(1);
    });

    test('should clear x emoji when null', () async {
      const Settings initialSettings = Settings(xEmoji: '😀');
      const Settings expectedSettings = Settings();

      when(() => mockRepository.getSettings())
          .thenAnswer((_) async => initialSettings);
      when(() => mockRepository.saveSettings(any()))
          .thenAnswer((_) async => Future<void>.value());

      await useCase.execute(null);

      verify(() => mockRepository.saveSettings(expectedSettings)).called(1);
    });

    test('should preserve other settings', () async {
      const Settings initialSettings = Settings(
        isDarkMode: false,
        xEmoji: '😀',
      );
      const String emoji = '🎮';
      const Settings expectedSettings = Settings(
        isDarkMode: false,
        xEmoji: emoji,
      );

      when(() => mockRepository.getSettings())
          .thenAnswer((_) async => initialSettings);
      when(() => mockRepository.saveSettings(any()))
          .thenAnswer((_) async => Future<void>.value());

      await useCase.execute(emoji);

      verify(() => mockRepository.saveSettings(expectedSettings)).called(1);
    });

    test('should propagate errors from repository', () async {
      when(() => mockRepository.getSettings())
          .thenThrow(Exception('Error getting settings'));

      expect(() => useCase.execute('😀'), throwsException);
    });
  });
}

