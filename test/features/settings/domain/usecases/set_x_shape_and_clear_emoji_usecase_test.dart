import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/features/settings/domain/entities/settings.dart';
import 'package:tictac/features/settings/domain/repositories/settings_repository.dart';
import 'package:tictac/features/settings/domain/usecases/set_x_shape_and_clear_emoji_usecase.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(const Settings());
  });

  late SetXShapeAndClearEmojiUseCase useCase;
  late MockSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockSettingsRepository();
    useCase = SetXShapeAndClearEmojiUseCase(mockRepository);
  });

  group('SetXShapeAndClearEmojiUseCase', () {
    test('should set x shape and clear x emoji', () async {
      const Settings initialSettings = Settings(xEmoji: '😀');
      const String shape = 'rounded';
      const Settings expectedSettings = Settings(xShape: shape);

      when(() => mockRepository.getSettings())
          .thenAnswer((_) async => initialSettings);
      when(() => mockRepository.saveSettings(any()))
          .thenAnswer((_) async => Future<void>.value());

      await useCase.execute(shape);

      verify(() => mockRepository.saveSettings(expectedSettings)).called(1);
    });

    test('should preserve other settings', () async {
      const Settings initialSettings = Settings(
        isDarkMode: false,
        xEmoji: '😀',
        oEmoji: '😊',
      );
      const String shape = 'outline';
      const Settings expectedSettings = Settings(
        isDarkMode: false,
        xShape: shape,
        oEmoji: '😊',
      );

      when(() => mockRepository.getSettings())
          .thenAnswer((_) async => initialSettings);
      when(() => mockRepository.saveSettings(any()))
          .thenAnswer((_) async => Future<void>.value());

      await useCase.execute(shape);

      verify(() => mockRepository.saveSettings(expectedSettings)).called(1);
    });

    test('should propagate errors from repository', () async {
      when(() => mockRepository.getSettings())
          .thenThrow(Exception('Error getting settings'));

      expect(() => useCase.execute('rounded'), throwsException);
    });
  });
}

