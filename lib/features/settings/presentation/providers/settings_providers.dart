import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictac/core/di/injection.dart';
import 'package:tictac/core/providers/service_providers.dart';
import 'package:tictac/core/services/audio_service.dart';
import 'package:tictac/core/services/logger_service.dart';
import 'package:tictac/features/settings/data/datasources/settings_datasource.dart';
import 'package:tictac/features/settings/domain/entities/settings.dart';
import 'package:tictac/features/settings/domain/repositories/settings_repository.dart';
import 'package:tictac/features/settings/domain/usecases/get_app_version_usecase.dart';
import 'package:tictac/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:tictac/features/settings/domain/usecases/save_settings_usecase.dart';
import 'package:tictac/features/settings/domain/usecases/set_language_usecase.dart';
import 'package:tictac/features/settings/domain/usecases/set_o_emoji_usecase.dart';
import 'package:tictac/features/settings/domain/usecases/set_o_shape_and_clear_emoji_usecase.dart';
import 'package:tictac/features/settings/domain/usecases/set_o_shape_usecase.dart';
import 'package:tictac/features/settings/domain/usecases/set_use_emojis_usecase.dart';
import 'package:tictac/features/settings/domain/usecases/set_x_emoji_usecase.dart';
import 'package:tictac/features/settings/domain/usecases/set_x_shape_and_clear_emoji_usecase.dart';
import 'package:tictac/features/settings/domain/usecases/set_x_shape_usecase.dart';
import 'package:tictac/features/settings/domain/usecases/toggle_animations_usecase.dart';
import 'package:tictac/features/settings/domain/usecases/toggle_dark_mode_usecase.dart';
import 'package:tictac/features/settings/domain/usecases/toggle_sound_fx_usecase.dart';

final Provider<SettingsDataSource> settingsDataSourceProvider = Provider<SettingsDataSource>((Ref ref) => getIt<SettingsDataSource>());

final Provider<SettingsRepository> settingsRepositoryProvider = Provider<SettingsRepository>((Ref ref) => getIt<SettingsRepository>());

final Provider<GetSettingsUseCase> getSettingsUseCaseProvider = Provider<GetSettingsUseCase>((Ref ref) => GetSettingsUseCase(ref.watch(settingsRepositoryProvider)));

final Provider<SaveSettingsUseCase> saveSettingsUseCaseProvider = Provider<SaveSettingsUseCase>((Ref ref) => SaveSettingsUseCase(ref.watch(settingsRepositoryProvider)));

final Provider<GetAppVersionUseCase> getAppVersionUseCaseProvider = Provider<GetAppVersionUseCase>((Ref ref) => GetAppVersionUseCase(ref.watch(appInfoServiceProvider)));

final Provider<SetLanguageUseCase> setLanguageUseCaseProvider = Provider<SetLanguageUseCase>((Ref ref) => SetLanguageUseCase(ref.watch(settingsRepositoryProvider)));

final Provider<ToggleDarkModeUseCase> toggleDarkModeUseCaseProvider = Provider<ToggleDarkModeUseCase>(
  (Ref ref) => ToggleDarkModeUseCase(ref.watch(settingsRepositoryProvider)),
);

final Provider<ToggleSoundFxUseCase> toggleSoundFxUseCaseProvider = Provider<ToggleSoundFxUseCase>((Ref ref) => ToggleSoundFxUseCase(ref.watch(settingsRepositoryProvider)));

final Provider<ToggleAnimationsUseCase> toggleAnimationsUseCaseProvider = Provider<ToggleAnimationsUseCase>(
  (Ref ref) => ToggleAnimationsUseCase(ref.watch(settingsRepositoryProvider)),
);

final Provider<SetXShapeUseCase> setXShapeUseCaseProvider = Provider<SetXShapeUseCase>((Ref ref) => SetXShapeUseCase(ref.watch(settingsRepositoryProvider)));

final Provider<SetOShapeUseCase> setOShapeUseCaseProvider = Provider<SetOShapeUseCase>((Ref ref) => SetOShapeUseCase(ref.watch(settingsRepositoryProvider)));

final Provider<SetXShapeAndClearEmojiUseCase> setXShapeAndClearEmojiUseCaseProvider = Provider<SetXShapeAndClearEmojiUseCase>(
  (Ref ref) => SetXShapeAndClearEmojiUseCase(ref.watch(settingsRepositoryProvider)),
);

final Provider<SetOShapeAndClearEmojiUseCase> setOShapeAndClearEmojiUseCaseProvider = Provider<SetOShapeAndClearEmojiUseCase>(
  (Ref ref) => SetOShapeAndClearEmojiUseCase(ref.watch(settingsRepositoryProvider)),
);

final Provider<SetXEmojiUseCase> setXEmojiUseCaseProvider = Provider<SetXEmojiUseCase>((Ref ref) => SetXEmojiUseCase(ref.watch(settingsRepositoryProvider)));

final Provider<SetOEmojiUseCase> setOEmojiUseCaseProvider = Provider<SetOEmojiUseCase>((Ref ref) => SetOEmojiUseCase(ref.watch(settingsRepositoryProvider)));

final Provider<SetUseEmojisUseCase> setUseEmojisUseCaseProvider = Provider<SetUseEmojisUseCase>((Ref ref) => SetUseEmojisUseCase(ref.watch(settingsRepositoryProvider)));

final FutureProvider<String> appVersionProvider = FutureProvider<String>((Ref ref) async {
  final useCase = ref.read(getAppVersionUseCaseProvider);
  return await useCase.execute();
});

final AsyncNotifierProvider<SettingsNotifier, Settings> settingsProvider = AsyncNotifierProvider<SettingsNotifier, Settings>(SettingsNotifier.new);

final Provider<Settings> settingsValueProvider = Provider<Settings>((Ref ref) {
  return ref.watch(settingsProvider).value ?? const Settings();
});

// Derived providers - optimized with select, recommended by Riverpod docs
final Provider<bool> isDarkModeProvider = Provider<bool>((Ref ref) {
  return ref.watch(settingsValueProvider.select((Settings s) => s.isDarkMode));
});

final Provider<String> languageCodeProvider = Provider<String>((Ref ref) {
  return ref.watch(settingsValueProvider.select((Settings s) => s.languageCode));
});

final Provider<bool> soundFxEnabledProvider = Provider<bool>((Ref ref) {
  return ref.watch(settingsValueProvider.select((Settings s) => s.soundFxEnabled));
});

final Provider<bool> animationsEnabledProvider = Provider<bool>((Ref ref) {
  return ref.watch(settingsValueProvider.select((Settings s) => s.animationsEnabled));
});

final Provider<String?> xEmojiProvider = Provider<String?>((Ref ref) {
  return ref.watch(settingsValueProvider.select((Settings s) => s.xEmoji));
});

final Provider<String?> oEmojiProvider = Provider<String?>((Ref ref) {
  return ref.watch(settingsValueProvider.select((Settings s) => s.oEmoji));
});

final Provider<String> xShapeProvider = Provider<String>((Ref ref) {
  return ref.watch(settingsValueProvider.select((Settings s) => s.xShape));
});

final Provider<String> oShapeProvider = Provider<String>((Ref ref) {
  return ref.watch(settingsValueProvider.select((Settings s) => s.oShape));
});

final Provider<bool> useEmojisProvider = Provider<bool>((Ref ref) {
  return ref.watch(settingsValueProvider.select((Settings s) => s.useEmojis));
});

class SettingsNotifier extends AsyncNotifier<Settings> {
  @override
  Future<Settings> build() async {
    return await _loadSettings();
  }

  Future<Settings> _loadSettings() async {
    try {
      final GetSettingsUseCase getSettingsUseCase = ref.read(getSettingsUseCaseProvider);
      final Settings settings = await getSettingsUseCase.execute();

      final AudioService audioService = ref.read(audioServiceProvider);
      audioService.setFxEnabled(settings.soundFxEnabled);

      return settings;
    } catch (e, stackTrace) {
      final LoggerService logger = ref.read(loggerServiceProvider);
      logger.error('Failed to load settings', e, stackTrace);
      rethrow;
    }
  }

  GetSettingsUseCase get getSettingsUseCase => ref.read(getSettingsUseCaseProvider);
  SaveSettingsUseCase get saveSettingsUseCase => ref.read(saveSettingsUseCaseProvider);
  SetLanguageUseCase get setLanguageUseCase => ref.read(setLanguageUseCaseProvider);
  ToggleDarkModeUseCase get toggleDarkModeUseCase => ref.read(toggleDarkModeUseCaseProvider);
  ToggleSoundFxUseCase get toggleSoundFxUseCase => ref.read(toggleSoundFxUseCaseProvider);
  ToggleAnimationsUseCase get toggleAnimationsUseCase => ref.read(toggleAnimationsUseCaseProvider);
  SetXShapeUseCase get setXShapeUseCase => ref.read(setXShapeUseCaseProvider);
  SetOShapeUseCase get setOShapeUseCase => ref.read(setOShapeUseCaseProvider);
  SetXShapeAndClearEmojiUseCase get setXShapeAndClearEmojiUseCase => ref.read(setXShapeAndClearEmojiUseCaseProvider);
  SetOShapeAndClearEmojiUseCase get setOShapeAndClearEmojiUseCase => ref.read(setOShapeAndClearEmojiUseCaseProvider);
  SetXEmojiUseCase get setXEmojiUseCase => ref.read(setXEmojiUseCaseProvider);
  SetOEmojiUseCase get setOEmojiUseCase => ref.read(setOEmojiUseCaseProvider);
  SetUseEmojisUseCase get setUseEmojisUseCase => ref.read(setUseEmojisUseCaseProvider);

  Future<void> toggleDarkMode() async {
    await toggleDarkModeUseCase.execute();
    final settings = await _loadSettings();
    state = AsyncData<Settings>(settings);
  }

  Future<void> toggleSoundFx() async {
    await toggleSoundFxUseCase.execute();
    final settings = await _loadSettings();
    state = AsyncData<Settings>(settings);
  }

  Future<void> toggleAnimations() async {
    await toggleAnimationsUseCase.execute();
    final settings = await _loadSettings();
    state = AsyncData<Settings>(settings);
  }

  Future<void> updateSettings(Settings settings) async {
    await saveSettingsUseCase.execute(settings);
    state = AsyncData<Settings>(settings);
  }

  Future<void> setLanguage(String languageCode) async {
    await setLanguageUseCase.execute(languageCode);
    final settings = await _loadSettings();
    state = AsyncData<Settings>(settings);
  }

  Future<void> setXShape(String shape) async {
    await setXShapeUseCase.execute(shape);
    final settings = await _loadSettings();
    state = AsyncData<Settings>(settings);
  }

  Future<void> setOShape(String shape) async {
    await setOShapeUseCase.execute(shape);
    final settings = await _loadSettings();
    state = AsyncData<Settings>(settings);
  }

  Future<void> setXShapeAndClearEmoji(String shape) async {
    await setXShapeAndClearEmojiUseCase.execute(shape);
    final settings = await _loadSettings();
    state = AsyncData<Settings>(settings);
  }

  Future<void> setOShapeAndClearEmoji(String shape) async {
    await setOShapeAndClearEmojiUseCase.execute(shape);
    final settings = await _loadSettings();
    state = AsyncData<Settings>(settings);
  }

  Future<void> setXEmoji(String? emoji) async {
    await setXEmojiUseCase.execute(emoji);
    final settings = await _loadSettings();
    state = AsyncData<Settings>(settings);
  }

  Future<void> setOEmoji(String? emoji) async {
    await setOEmojiUseCase.execute(emoji);
    final settings = await _loadSettings();
    state = AsyncData<Settings>(settings);
  }

  Future<void> setUseEmojis(bool useEmojis) async {
    await setUseEmojisUseCase.execute(useEmojis);
    final settings = await _loadSettings();
    state = AsyncData<Settings>(settings);
  }
}
