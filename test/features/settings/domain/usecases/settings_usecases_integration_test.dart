import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/core/constants/language_codes.dart';
import 'package:tictac/features/settings/domain/entities/settings.dart';
import 'package:tictac/features/settings/domain/repositories/settings_repository.dart';
import 'package:tictac/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:tictac/features/settings/domain/usecases/save_settings_usecase.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late MockSettingsRepository mockRepository;
  late GetSettingsUseCase getSettingsUseCase;
  late SaveSettingsUseCase saveSettingsUseCase;

  setUp(() {
    mockRepository = MockSettingsRepository();
    getSettingsUseCase = GetSettingsUseCase(mockRepository);
    saveSettingsUseCase = SaveSettingsUseCase(mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(const Settings());
  });

  group('Settings Integration Tests', () {
    test('should handle complete settings lifecycle', () async {
      const Settings defaultSettings = Settings();
      const Settings updatedSettings = Settings(
        isDarkMode: false,
        soundFxEnabled: false,
        languageCode: LanguageCodes.french,
      );

      when(() => mockRepository.getSettings())
          .thenAnswer((_) async => defaultSettings);
      when(() => mockRepository.saveSettings(any())).thenAnswer((_) async {});

      final Settings initial = await getSettingsUseCase.execute();
      expect(initial.isDarkMode, isTrue);
      expect(initial.languageCode, equals(LanguageCodes.defaultLanguage));

      await saveSettingsUseCase.execute(updatedSettings);

      when(() => mockRepository.getSettings())
          .thenAnswer((_) async => updatedSettings);
      final Settings updated = await getSettingsUseCase.execute();
      expect(updated.isDarkMode, isFalse);
      expect(updated.soundFxEnabled, isFalse);
      expect(updated.languageCode, equals(LanguageCodes.french));
    });

    test('should handle partial settings updates', () async {
      const Settings settings1 = Settings(isDarkMode: false);
      const Settings settings2 = Settings(isDarkMode: false, soundFxEnabled: false);

      when(() => mockRepository.saveSettings(any())).thenAnswer((_) async {});

      await saveSettingsUseCase.execute(settings1);
      await saveSettingsUseCase.execute(settings2);

      verify(() => mockRepository.saveSettings(settings1)).called(1);
      verify(() => mockRepository.saveSettings(settings2)).called(1);
    });

    test('should preserve unchanged settings fields', () async {
      const Settings settings = Settings(
        isDarkMode: false,
        languageCode: LanguageCodes.french,
        xShape: 'circle',
        oShape: 'square',
        useEmojis: true,
      );

      when(() => mockRepository.saveSettings(any())).thenAnswer((_) async {});
      when(() => mockRepository.getSettings())
          .thenAnswer((_) async => settings);

      await saveSettingsUseCase.execute(settings);
      final Settings retrieved = await getSettingsUseCase.execute();

      expect(retrieved.isDarkMode, equals(settings.isDarkMode));
      expect(retrieved.soundFxEnabled, equals(settings.soundFxEnabled));
      expect(retrieved.animationsEnabled, equals(settings.animationsEnabled));
      expect(retrieved.languageCode, equals(settings.languageCode));
      expect(retrieved.xShape, equals(settings.xShape));
      expect(retrieved.oShape, equals(settings.oShape));
      expect(retrieved.useEmojis, equals(settings.useEmojis));
    });
  });

  group('Settings Edge Cases', () {
    test('should handle emoji settings with custom shapes', () async {
      const Settings settings = Settings(
        useEmojis: true,
        xEmoji: '❌',
        oEmoji: '⭕',
        xShape: 'emoji',
        oShape: 'emoji',
      );

      when(() => mockRepository.saveSettings(any())).thenAnswer((_) async {});
      when(() => mockRepository.getSettings())
          .thenAnswer((_) async => settings);

      await saveSettingsUseCase.execute(settings);
      final Settings retrieved = await getSettingsUseCase.execute();

      expect(retrieved.useEmojis, isTrue);
      expect(retrieved.xEmoji, equals('❌'));
      expect(retrieved.oEmoji, equals('⭕'));
    });

    test('should handle null emoji values', () async {
      const Settings settings = Settings(
        
      );

      when(() => mockRepository.saveSettings(any())).thenAnswer((_) async {});
      when(() => mockRepository.getSettings())
          .thenAnswer((_) async => settings);

      await saveSettingsUseCase.execute(settings);
      final Settings retrieved = await getSettingsUseCase.execute();

      expect(retrieved.xEmoji, isNull);
      expect(retrieved.oEmoji, isNull);
    });

    test('should handle invalid language code', () async {
      const Settings settings = Settings(languageCode: 'invalid');

      when(() => mockRepository.saveSettings(any())).thenAnswer((_) async {});
      when(() => mockRepository.getSettings())
          .thenAnswer((_) async => settings);

      await saveSettingsUseCase.execute(settings);
      final Settings retrieved = await getSettingsUseCase.execute();

      expect(retrieved.languageCode, equals('invalid'));
    });

    test('should handle empty shape strings', () async {
      const Settings settings = Settings(xShape: '', oShape: '');

      when(() => mockRepository.saveSettings(any())).thenAnswer((_) async {});
      when(() => mockRepository.getSettings())
          .thenAnswer((_) async => settings);

      await saveSettingsUseCase.execute(settings);
      final Settings retrieved = await getSettingsUseCase.execute();

      expect(retrieved.xShape, equals(''));
      expect(retrieved.oShape, equals(''));
    });

    test('should handle all booleans false', () async {
      const Settings settings = Settings(
        isDarkMode: false,
        soundFxEnabled: false,
        animationsEnabled: false,
      );

      when(() => mockRepository.saveSettings(any())).thenAnswer((_) async {});
      when(() => mockRepository.getSettings())
          .thenAnswer((_) async => settings);

      await saveSettingsUseCase.execute(settings);
      final Settings retrieved = await getSettingsUseCase.execute();

      expect(retrieved.isDarkMode, isFalse);
      expect(retrieved.soundFxEnabled, isFalse);
      expect(retrieved.animationsEnabled, isFalse);
      expect(retrieved.useEmojis, isFalse);
    });

    test('should handle all booleans true', () async {
      const Settings settings = Settings(
        useEmojis: true,
      );

      when(() => mockRepository.saveSettings(any())).thenAnswer((_) async {});
      when(() => mockRepository.getSettings())
          .thenAnswer((_) async => settings);

      await saveSettingsUseCase.execute(settings);
      final Settings retrieved = await getSettingsUseCase.execute();

      expect(retrieved.isDarkMode, isTrue);
      expect(retrieved.soundFxEnabled, isTrue);
      expect(retrieved.animationsEnabled, isTrue);
      expect(retrieved.useEmojis, isTrue);
    });
  });

  group('Settings Error Handling', () {
    test('should throw when repository get fails', () async {
      when(() => mockRepository.getSettings())
          .thenThrow(Exception('Storage error'));

      expect(
        () => getSettingsUseCase.execute(),
        throwsA(isA<Exception>()),
      );
    });

    test('should throw when repository save fails', () async {
      const Settings settings = Settings();

      when(() => mockRepository.saveSettings(any()))
          .thenThrow(Exception('Storage full'));

      expect(
        () => saveSettingsUseCase.execute(settings),
        throwsA(isA<Exception>()),
      );
    });

    test('should handle timeout in get operation', () async {
      when(() => mockRepository.getSettings()).thenAnswer(
        (_) =>
            Future<Settings>.delayed(const Duration(seconds: 10), () => const Settings()),
      );

      final Future<Settings> future = getSettingsUseCase.execute().timeout(
            const Duration(milliseconds: 100),
            onTimeout: () => const Settings(),
          );

      final Settings result = await future;
      expect(result, isNotNull);
    });

    test('should handle timeout in save operation', () async {
      const Settings settings = Settings();

      when(() => mockRepository.saveSettings(any())).thenAnswer(
        (_) => Future<void>.delayed(const Duration(seconds: 10)),
      );

      final Future<void> future = saveSettingsUseCase.execute(settings).timeout(
            const Duration(milliseconds: 100),
          );

      await expectLater(future, throwsA(isA<TimeoutException>()));
    });
  });

  group('Settings Concurrent Operations', () {
    test('should handle rapid successive saves', () async {
      const Settings settings1 = Settings();
      const Settings settings2 = Settings(isDarkMode: false);
      const Settings settings3 = Settings(soundFxEnabled: false);

      when(() => mockRepository.saveSettings(any())).thenAnswer((_) async {});

      await Future.wait(<Future<void>>[
        saveSettingsUseCase.execute(settings1),
        saveSettingsUseCase.execute(settings2),
        saveSettingsUseCase.execute(settings3),
      ]);

      verify(() => mockRepository.saveSettings(any())).called(3);
    });

    test('should handle concurrent get operations', () async {
      const Settings settings = Settings();

      when(() => mockRepository.getSettings())
          .thenAnswer((_) async => settings);

      final List<Future<Settings>> futures = List<Future<Settings>>.generate(5, (int _) => getSettingsUseCase.execute());
      final List<Settings> results = await Future.wait(futures);

      expect(results.length, equals(5));
      expect(results.every((Settings s) => s == settings), isTrue);
    });

    test('should handle interleaved get and save operations', () async {
      const Settings settings1 = Settings();
      const Settings settings2 = Settings(isDarkMode: false);

      when(() => mockRepository.getSettings())
          .thenAnswer((_) async => settings1);
      when(() => mockRepository.saveSettings(any())).thenAnswer((_) async {});

      final List<Future<void>> futures = <Future<void>>[
        getSettingsUseCase.execute(),
        saveSettingsUseCase.execute(settings2),
        getSettingsUseCase.execute(),
        saveSettingsUseCase.execute(settings1),
        getSettingsUseCase.execute(),
      ];

      await Future.wait(futures);

      verify(() => mockRepository.getSettings()).called(3);
      verify(() => mockRepository.saveSettings(any())).called(2);
    });
  });

  group('Settings Language Switching', () {
    test('should switch from English to French', () async {
      const Settings englishSettings = Settings(
        
      );
      const Settings frenchSettings = Settings(
        languageCode: LanguageCodes.french,
      );

      when(() => mockRepository.saveSettings(any())).thenAnswer((_) async {});
      when(() => mockRepository.getSettings())
          .thenAnswer((_) async => englishSettings);

      await saveSettingsUseCase.execute(englishSettings);
      final Settings before = await getSettingsUseCase.execute();
      expect(before.languageCode, equals(LanguageCodes.defaultLanguage));

      when(() => mockRepository.getSettings())
          .thenAnswer((_) async => frenchSettings);

      await saveSettingsUseCase.execute(frenchSettings);
      final Settings after = await getSettingsUseCase.execute();
      expect(after.languageCode, equals(LanguageCodes.french));
    });

    test('should maintain other settings during language switch', () async {
      const Settings beforeSettings = Settings(
        isDarkMode: false,
      );
      const Settings afterSettings = Settings(
        languageCode: LanguageCodes.french,
        isDarkMode: false,
      );

      when(() => mockRepository.saveSettings(any())).thenAnswer((_) async {});

      await saveSettingsUseCase.execute(beforeSettings);
      await saveSettingsUseCase.execute(afterSettings);

      final List<dynamic> captured =
          verify(() => mockRepository.saveSettings(captureAny())).captured;

      expect((captured[0] as Settings).isDarkMode, isFalse);
      expect((captured[0] as Settings).soundFxEnabled, isTrue);
      expect((captured[1] as Settings).isDarkMode, isFalse);
      expect((captured[1] as Settings).soundFxEnabled, isTrue);
    });
  });

  group('Settings Theme Switching', () {
    test('should toggle dark mode', () async {
      const Settings darkSettings = Settings();
      const Settings lightSettings = Settings(isDarkMode: false);

      when(() => mockRepository.saveSettings(any())).thenAnswer((_) async {});

      await saveSettingsUseCase.execute(darkSettings);
      await saveSettingsUseCase.execute(lightSettings);
      await saveSettingsUseCase.execute(darkSettings);

      verify(() => mockRepository.saveSettings(any())).called(3);
    });

    test('should handle theme toggle with other settings', () async {
      const Settings settings = Settings(
        soundFxEnabled: false,
        languageCode: LanguageCodes.french,
      );

      when(() => mockRepository.saveSettings(any())).thenAnswer((_) async {});
      when(() => mockRepository.getSettings())
          .thenAnswer((_) async => settings);

      await saveSettingsUseCase.execute(settings);
      final Settings retrieved = await getSettingsUseCase.execute();

      expect(retrieved.isDarkMode, isTrue);
      expect(retrieved.soundFxEnabled, isFalse);
      expect(retrieved.animationsEnabled, isTrue);
      expect(retrieved.languageCode, equals(LanguageCodes.french));
    });
  });
}
