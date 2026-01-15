import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/features/settings/domain/entities/settings.dart';
import 'package:tictac/features/settings/domain/repositories/settings_repository.dart';
import 'package:tictac/features/settings/domain/usecases/update_settings_usecase.dart';

import '../../../../helpers/test_setup.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(const Settings());
    setupTestGetIt();
  });

  tearDownAll(() {
    tearDownTestGetIt();
  });

  late MockSettingsRepository mockRepository;
  late UpdateSettingsUseCase useCase;

  setUp(() {
    mockRepository = MockSettingsRepository();
    useCase = UpdateSettingsUseCase(mockRepository);
  });

  group('UpdateSettingsUseCase', () {
    test('execute should transform and save settings', () async {
      const currentSettings = Settings();
      const expectedSettings = Settings(isDarkMode: false);

      when(() => mockRepository.getSettings()).thenAnswer((_) async => currentSettings);
      when(() => mockRepository.saveSettings(any())).thenAnswer((_) async {});

      await useCase.execute((s) => s.copyWith(isDarkMode: false));

      verify(() => mockRepository.getSettings()).called(1);
      verify(() => mockRepository.saveSettings(expectedSettings)).called(1);
    });

    test('toggleDarkMode should toggle from true to false', () async {
      const currentSettings = Settings();

      when(() => mockRepository.getSettings()).thenAnswer((_) async => currentSettings);
      when(() => mockRepository.saveSettings(any())).thenAnswer((_) async {});

      await useCase.toggleDarkMode();

      verify(() => mockRepository.saveSettings(const Settings(isDarkMode: false))).called(1);
    });

    test('toggleDarkMode should toggle from false to true', () async {
      const currentSettings = Settings(isDarkMode: false);

      when(() => mockRepository.getSettings()).thenAnswer((_) async => currentSettings);
      when(() => mockRepository.saveSettings(any())).thenAnswer((_) async {});

      await useCase.toggleDarkMode();

      verify(() => mockRepository.saveSettings(const Settings())).called(1);
    });

    test('toggleSoundFx should toggle sound fx', () async {
      const currentSettings = Settings();

      when(() => mockRepository.getSettings()).thenAnswer((_) async => currentSettings);
      when(() => mockRepository.saveSettings(any())).thenAnswer((_) async {});

      await useCase.toggleSoundFx();

      verify(() => mockRepository.saveSettings(const Settings(soundFxEnabled: false))).called(1);
    });

    test('toggleAnimations should toggle animations', () async {
      const currentSettings = Settings();

      when(() => mockRepository.getSettings()).thenAnswer((_) async => currentSettings);
      when(() => mockRepository.saveSettings(any())).thenAnswer((_) async {});

      await useCase.toggleAnimations();

      verify(() => mockRepository.saveSettings(const Settings(animationsEnabled: false))).called(1);
    });

    test('setLanguage should update language code', () async {
      const currentSettings = Settings();

      when(() => mockRepository.getSettings()).thenAnswer((_) async => currentSettings);
      when(() => mockRepository.saveSettings(any())).thenAnswer((_) async {});

      await useCase.setLanguage('fr');

      final captured = verify(() => mockRepository.saveSettings(captureAny())).captured;
      expect((captured.first as Settings).languageCode, equals('fr'));
    });

    test('setXShape should update x shape', () async {
      const currentSettings = Settings();

      when(() => mockRepository.getSettings()).thenAnswer((_) async => currentSettings);
      when(() => mockRepository.saveSettings(any())).thenAnswer((_) async {});

      await useCase.setXShape('star');

      final captured = verify(() => mockRepository.saveSettings(captureAny())).captured;
      expect((captured.first as Settings).xShape, equals('star'));
    });

    test('setOShape should update o shape', () async {
      const currentSettings = Settings();

      when(() => mockRepository.getSettings()).thenAnswer((_) async => currentSettings);
      when(() => mockRepository.saveSettings(any())).thenAnswer((_) async {});

      await useCase.setOShape('heart');

      final captured = verify(() => mockRepository.saveSettings(captureAny())).captured;
      expect((captured.first as Settings).oShape, equals('heart'));
    });

    test('setXShapeAndClearEmoji should update shape and clear emoji', () async {
      const currentSettings = Settings(xEmoji: '🎮');

      when(() => mockRepository.getSettings()).thenAnswer((_) async => currentSettings);
      when(() => mockRepository.saveSettings(any())).thenAnswer((_) async {});

      await useCase.setXShapeAndClearEmoji('star');

      final captured = verify(() => mockRepository.saveSettings(captureAny())).captured;
      final saved = captured.first as Settings;
      expect(saved.xShape, equals('star'));
      expect(saved.xEmoji, isNull);
    });

    test('setOShapeAndClearEmoji should update shape and clear emoji', () async {
      const currentSettings = Settings(oEmoji: '🎯');

      when(() => mockRepository.getSettings()).thenAnswer((_) async => currentSettings);
      when(() => mockRepository.saveSettings(any())).thenAnswer((_) async {});

      await useCase.setOShapeAndClearEmoji('heart');

      final captured = verify(() => mockRepository.saveSettings(captureAny())).captured;
      final saved = captured.first as Settings;
      expect(saved.oShape, equals('heart'));
      expect(saved.oEmoji, isNull);
    });

    test('setXEmoji should update x emoji', () async {
      const currentSettings = Settings();

      when(() => mockRepository.getSettings()).thenAnswer((_) async => currentSettings);
      when(() => mockRepository.saveSettings(any())).thenAnswer((_) async {});

      await useCase.setXEmoji('🎮');

      final captured = verify(() => mockRepository.saveSettings(captureAny())).captured;
      expect((captured.first as Settings).xEmoji, equals('🎮'));
    });

    test('setOEmoji should update o emoji', () async {
      const currentSettings = Settings();

      when(() => mockRepository.getSettings()).thenAnswer((_) async => currentSettings);
      when(() => mockRepository.saveSettings(any())).thenAnswer((_) async {});

      await useCase.setOEmoji('🎯');

      final captured = verify(() => mockRepository.saveSettings(captureAny())).captured;
      expect((captured.first as Settings).oEmoji, equals('🎯'));
    });

    test('setUseEmojis should update use emojis flag', () async {
      const currentSettings = Settings();

      when(() => mockRepository.getSettings()).thenAnswer((_) async => currentSettings);
      when(() => mockRepository.saveSettings(any())).thenAnswer((_) async {});

      await useCase.setUseEmojis(true);

      final captured = verify(() => mockRepository.saveSettings(captureAny())).captured;
      expect((captured.first as Settings).useEmojis, isTrue);
    });

    test('should propagate errors from repository', () async {
      when(() => mockRepository.getSettings()).thenThrow(Exception('Repository error'));

      expect(() => useCase.toggleDarkMode(), throwsException);
    });
  });
}
