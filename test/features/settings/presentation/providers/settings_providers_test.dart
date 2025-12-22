import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/core/providers/service_providers.dart';
import 'package:tictac/core/services/audio_service.dart';
import 'package:tictac/features/settings/domain/entities/settings.dart';
import 'package:tictac/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:tictac/features/settings/domain/usecases/save_settings_usecase.dart';
import 'package:tictac/features/settings/domain/usecases/set_language_usecase.dart';
import 'package:tictac/features/settings/domain/usecases/toggle_animations_usecase.dart';
import 'package:tictac/features/settings/domain/usecases/toggle_dark_mode_usecase.dart';
import 'package:tictac/features/settings/domain/usecases/toggle_sound_fx_usecase.dart';
import 'package:tictac/features/settings/presentation/providers/settings_providers.dart';

import '../../../../helpers/test_setup.dart';

class MockGetSettingsUseCase extends Mock implements GetSettingsUseCase {}

class MockSaveSettingsUseCase extends Mock implements SaveSettingsUseCase {}

class MockSetLanguageUseCase extends Mock implements SetLanguageUseCase {}

class MockToggleDarkModeUseCase extends Mock implements ToggleDarkModeUseCase {}

class MockToggleSoundFxUseCase extends Mock implements ToggleSoundFxUseCase {}

class MockToggleAnimationsUseCase extends Mock implements ToggleAnimationsUseCase {}

class MockAudioService extends Mock implements AudioService {}

void setUpAllFallbacks() {
  registerFallbackValue(const Settings());
}

void main() {
  setUpAll(() {
    setUpAllFallbacks();
    setupTestGetIt();
  });

  tearDownAll(() {
    tearDownTestGetIt();
  });
  late MockGetSettingsUseCase mockGetSettingsUseCase;
  late MockSaveSettingsUseCase mockSaveSettingsUseCase;
  late MockSetLanguageUseCase mockSetLanguageUseCase;
  late MockToggleDarkModeUseCase mockToggleDarkModeUseCase;
  late MockToggleSoundFxUseCase mockToggleSoundFxUseCase;
  late MockToggleAnimationsUseCase mockToggleAnimationsUseCase;
  late MockAudioService mockAudioService;
  late ProviderContainer container;

  setUp(() {
    mockGetSettingsUseCase = MockGetSettingsUseCase();
    mockSaveSettingsUseCase = MockSaveSettingsUseCase();
    mockSetLanguageUseCase = MockSetLanguageUseCase();
    mockToggleDarkModeUseCase = MockToggleDarkModeUseCase();
    mockToggleSoundFxUseCase = MockToggleSoundFxUseCase();
    mockToggleAnimationsUseCase = MockToggleAnimationsUseCase();
    mockAudioService = MockAudioService();

    when(() => mockGetSettingsUseCase.execute()).thenAnswer((_) async => const Settings());
    when(() => mockSetLanguageUseCase.execute(any())).thenAnswer((_) async => Future<void>.value());
    when(() => mockToggleDarkModeUseCase.execute()).thenAnswer((_) async => Future<void>.value());
    when(() => mockToggleSoundFxUseCase.execute()).thenAnswer((_) async => Future<void>.value());
    when(() => mockToggleAnimationsUseCase.execute()).thenAnswer((_) async => Future<void>.value());
    when(() => mockAudioService.setFxEnabled(any())).thenReturn(null);

    container = ProviderContainer(
      overrides: [
        getSettingsUseCaseProvider.overrideWithValue(mockGetSettingsUseCase),
        saveSettingsUseCaseProvider.overrideWithValue(mockSaveSettingsUseCase),
        setLanguageUseCaseProvider.overrideWithValue(mockSetLanguageUseCase),
        toggleDarkModeUseCaseProvider.overrideWithValue(mockToggleDarkModeUseCase),
        toggleSoundFxUseCaseProvider.overrideWithValue(mockToggleSoundFxUseCase),
        toggleAnimationsUseCaseProvider.overrideWithValue(mockToggleAnimationsUseCase),
        audioServiceProvider.overrideWithValue(mockAudioService),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  SettingsNotifier createNotifier() {
    return container.read(settingsProvider.notifier);
  }

  group('initial state', () {
    test('should load settings on initialization', () async {
      const Settings settings = Settings(languageCode: 'fr');

      when(() => mockGetSettingsUseCase.execute()).thenAnswer((_) async => settings);

      final SettingsNotifier testNotifier = createNotifier();
      await Future<void>.microtask(() {});
      await Future<void>.microtask(() {});

      verify(() => mockGetSettingsUseCase.execute()).called(1);
      expect(testNotifier.state.value, equals(settings));
    });

    test('should have default settings initially', () async {
      final SettingsNotifier testNotifier = createNotifier();
      await container.read(settingsProvider.future);
      expect(testNotifier.state.value, isA<Settings>());
    });
  });

  group('toggleDarkMode', () {
    test('should toggle dark mode and save', () async {
      const Settings initialSettings = Settings(isDarkMode: false);
      const Settings updatedSettings = Settings();
      final SettingsNotifier testNotifier = createNotifier();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      testNotifier.state = const AsyncData<Settings>(initialSettings);

      clearInteractions(mockGetSettingsUseCase);
      when(() => mockGetSettingsUseCase.execute()).thenAnswer((_) async => updatedSettings);

      await testNotifier.toggleDarkMode();

      verify(() => mockToggleDarkModeUseCase.execute()).called(1);
      verify(() => mockGetSettingsUseCase.execute()).called(1);
    });

    test('should toggle from true to false', () async {
      const Settings initialSettings = Settings();
      const Settings updatedSettings = Settings(isDarkMode: false);
      final SettingsNotifier testNotifier = createNotifier();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      testNotifier.state = const AsyncData<Settings>(initialSettings);

      clearInteractions(mockGetSettingsUseCase);
      when(() => mockGetSettingsUseCase.execute()).thenAnswer((_) async => updatedSettings);

      await testNotifier.toggleDarkMode();

      verify(() => mockToggleDarkModeUseCase.execute()).called(1);
    });
  });

  group('toggleSoundFx', () {
    test('should toggle sound fx and update audio service', () async {
      const Settings initialSettings = Settings(soundFxEnabled: false);
      const Settings updatedSettings = Settings();
      final SettingsNotifier testNotifier = createNotifier();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      testNotifier.state = const AsyncData<Settings>(initialSettings);

      clearInteractions(mockGetSettingsUseCase);
      when(() => mockGetSettingsUseCase.execute()).thenAnswer((_) async => updatedSettings);

      await testNotifier.toggleSoundFx();

      verify(() => mockToggleSoundFxUseCase.execute()).called(1);
      verify(() => mockGetSettingsUseCase.execute()).called(greaterThanOrEqualTo(1));
      verify(() => mockAudioService.setFxEnabled(true)).called(greaterThanOrEqualTo(1));
    });
  });

  group('toggleAnimations', () {
    test('should toggle animations and save', () async {
      const Settings initialSettings = Settings(animationsEnabled: false);
      const Settings updatedSettings = Settings();
      final SettingsNotifier testNotifier = createNotifier();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      testNotifier.state = const AsyncData<Settings>(initialSettings);

      clearInteractions(mockGetSettingsUseCase);
      when(() => mockGetSettingsUseCase.execute()).thenAnswer((_) async => updatedSettings);

      await testNotifier.toggleAnimations();

      verify(() => mockToggleAnimationsUseCase.execute()).called(1);
      verify(() => mockGetSettingsUseCase.execute()).called(1);
    });
  });

  group('updateSettings', () {
    test('should update settings and save', () async {
      const Settings newSettings = Settings(soundFxEnabled: false, languageCode: 'fr');

      final SettingsNotifier testNotifier = createNotifier();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      when(() => mockSaveSettingsUseCase.execute(newSettings)).thenAnswer((_) async => Future<void>.value());

      await testNotifier.updateSettings(newSettings);

      expect(testNotifier.state.value, equals(newSettings));
      verify(() => mockSaveSettingsUseCase.execute(newSettings)).called(1);
    });
  });

  group('setLanguage', () {
    test('should call setLanguageUseCase and reload settings', () async {
      const String languageCode = 'fr';
      const Settings initialSettings = Settings();
      final SettingsNotifier testNotifier = createNotifier();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      testNotifier.state = const AsyncData<Settings>(initialSettings);

      clearInteractions(mockGetSettingsUseCase);
      when(() => mockSetLanguageUseCase.execute(languageCode)).thenAnswer((_) async => Future<void>.value());
      when(() => mockGetSettingsUseCase.execute()).thenAnswer((_) async => initialSettings);

      await testNotifier.setLanguage(languageCode);

      verify(() => mockSetLanguageUseCase.execute(languageCode)).called(1);
      verify(() => mockGetSettingsUseCase.execute()).called(1);
    });
  });
}
