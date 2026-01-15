import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/core/providers/service_providers.dart';
import 'package:tictac/core/services/audio_service.dart';
import 'package:tictac/features/settings/domain/entities/settings.dart';
import 'package:tictac/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:tictac/features/settings/domain/usecases/update_settings_usecase.dart';
import 'package:tictac/features/settings/presentation/providers/settings_providers.dart';


class MockGetSettingsUseCase extends Mock implements GetSettingsUseCase {}

class MockUpdateSettingsUseCase extends Mock implements UpdateSettingsUseCase {}

class MockAudioService extends Mock implements AudioService {}

void setUpAllFallbacks() {
  registerFallbackValue(const Settings());
  registerFallbackValue((Settings s) => s);
}

void main() {
  setUpAll(() {
    setUpAllFallbacks();
  });
  late MockGetSettingsUseCase mockGetSettingsUseCase;
  late MockUpdateSettingsUseCase mockUpdateSettingsUseCase;
  late MockAudioService mockAudioService;
  late ProviderContainer container;

  setUp(() {
    mockGetSettingsUseCase = MockGetSettingsUseCase();
    mockUpdateSettingsUseCase = MockUpdateSettingsUseCase();
    mockAudioService = MockAudioService();

    when(() => mockGetSettingsUseCase.execute()).thenAnswer((_) async => const Settings());
    when(() => mockUpdateSettingsUseCase.execute(any())).thenAnswer((_) async => Future<void>.value());
    when(() => mockUpdateSettingsUseCase.toggleDarkMode()).thenAnswer((_) async => Future<void>.value());
    when(() => mockUpdateSettingsUseCase.toggleSoundFx()).thenAnswer((_) async => Future<void>.value());
    when(() => mockUpdateSettingsUseCase.toggleAnimations()).thenAnswer((_) async => Future<void>.value());
    when(() => mockUpdateSettingsUseCase.setLanguage(any())).thenAnswer((_) async => Future<void>.value());
    when(() => mockUpdateSettingsUseCase.setXShape(any())).thenAnswer((_) async => Future<void>.value());
    when(() => mockUpdateSettingsUseCase.setOShape(any())).thenAnswer((_) async => Future<void>.value());
    when(() => mockUpdateSettingsUseCase.setXEmoji(any())).thenAnswer((_) async => Future<void>.value());
    when(() => mockUpdateSettingsUseCase.setOEmoji(any())).thenAnswer((_) async => Future<void>.value());
    when(() => mockUpdateSettingsUseCase.setUseEmojis(any())).thenAnswer((_) async => Future<void>.value());
    when(() => mockUpdateSettingsUseCase.setXShapeAndClearEmoji(any())).thenAnswer((_) async => Future<void>.value());
    when(() => mockUpdateSettingsUseCase.setOShapeAndClearEmoji(any())).thenAnswer((_) async => Future<void>.value());
    when(() => mockAudioService.setFxEnabled(any())).thenReturn(null);

    container = ProviderContainer(
      overrides: [
        getSettingsUseCaseProvider.overrideWithValue(mockGetSettingsUseCase),
        updateSettingsUseCaseProvider.overrideWithValue(mockUpdateSettingsUseCase),
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

      verify(() => mockUpdateSettingsUseCase.toggleDarkMode()).called(1);
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

      verify(() => mockUpdateSettingsUseCase.toggleDarkMode()).called(1);
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

      verify(() => mockUpdateSettingsUseCase.toggleSoundFx()).called(1);
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

      verify(() => mockUpdateSettingsUseCase.toggleAnimations()).called(1);
      verify(() => mockGetSettingsUseCase.execute()).called(1);
    });
  });

  group('updateSettings', () {
    test('should update settings and save', () async {
      const Settings newSettings = Settings(soundFxEnabled: false, languageCode: 'fr');

      final SettingsNotifier testNotifier = createNotifier();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      await testNotifier.updateSettings(newSettings);

      expect(testNotifier.state.value, equals(newSettings));
      verify(() => mockUpdateSettingsUseCase.execute(any())).called(1);
    });
  });

  group('setLanguage', () {
    test('should call setLanguage and reload settings', () async {
      const String languageCode = 'fr';
      const Settings initialSettings = Settings();
      final SettingsNotifier testNotifier = createNotifier();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      testNotifier.state = const AsyncData<Settings>(initialSettings);

      clearInteractions(mockGetSettingsUseCase);
      when(() => mockGetSettingsUseCase.execute()).thenAnswer((_) async => initialSettings);

      await testNotifier.setLanguage(languageCode);

      verify(() => mockUpdateSettingsUseCase.setLanguage(languageCode)).called(1);
      verify(() => mockGetSettingsUseCase.execute()).called(1);
    });
  });

  group('shape and emoji settings', () {
    test('should set X shape', () async {
      const Settings initialSettings = Settings();
      final SettingsNotifier testNotifier = createNotifier();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      testNotifier.state = const AsyncData<Settings>(initialSettings);

      clearInteractions(mockGetSettingsUseCase);
      when(() => mockGetSettingsUseCase.execute()).thenAnswer((_) async => initialSettings);

      await testNotifier.setXShape('star');

      verify(() => mockUpdateSettingsUseCase.setXShape('star')).called(1);
    });

    test('should set O shape', () async {
      const Settings initialSettings = Settings();
      final SettingsNotifier testNotifier = createNotifier();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      testNotifier.state = const AsyncData<Settings>(initialSettings);

      clearInteractions(mockGetSettingsUseCase);
      when(() => mockGetSettingsUseCase.execute()).thenAnswer((_) async => initialSettings);

      await testNotifier.setOShape('heart');

      verify(() => mockUpdateSettingsUseCase.setOShape('heart')).called(1);
    });

    test('should set X emoji', () async {
      const Settings initialSettings = Settings();
      final SettingsNotifier testNotifier = createNotifier();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      testNotifier.state = const AsyncData<Settings>(initialSettings);

      clearInteractions(mockGetSettingsUseCase);
      when(() => mockGetSettingsUseCase.execute()).thenAnswer((_) async => initialSettings);

      await testNotifier.setXEmoji('🎮');

      verify(() => mockUpdateSettingsUseCase.setXEmoji('🎮')).called(1);
    });

    test('should set O emoji', () async {
      const Settings initialSettings = Settings();
      final SettingsNotifier testNotifier = createNotifier();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      testNotifier.state = const AsyncData<Settings>(initialSettings);

      clearInteractions(mockGetSettingsUseCase);
      when(() => mockGetSettingsUseCase.execute()).thenAnswer((_) async => initialSettings);

      await testNotifier.setOEmoji('🎯');

      verify(() => mockUpdateSettingsUseCase.setOEmoji('🎯')).called(1);
    });

    test('should set use emojis', () async {
      const Settings initialSettings = Settings();
      final SettingsNotifier testNotifier = createNotifier();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      testNotifier.state = const AsyncData<Settings>(initialSettings);

      clearInteractions(mockGetSettingsUseCase);
      when(() => mockGetSettingsUseCase.execute()).thenAnswer((_) async => initialSettings);

      await testNotifier.setUseEmojis(true);

      verify(() => mockUpdateSettingsUseCase.setUseEmojis(true)).called(1);
    });
  });
}
