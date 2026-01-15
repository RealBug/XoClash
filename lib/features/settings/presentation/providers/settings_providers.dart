import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictac/core/providers/service_providers.dart';
import 'package:tictac/features/settings/domain/entities/settings.dart';
import 'package:tictac/features/settings/domain/usecases/get_app_version_usecase.dart';
import 'package:tictac/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:tictac/features/settings/domain/usecases/update_settings_usecase.dart';

final Provider<GetSettingsUseCase> getSettingsUseCaseProvider =
    Provider<GetSettingsUseCase>((Ref ref) => GetSettingsUseCase(ref.watch(settingsRepositoryProvider)));

final Provider<UpdateSettingsUseCase> updateSettingsUseCaseProvider =
    Provider<UpdateSettingsUseCase>((Ref ref) => UpdateSettingsUseCase(ref.watch(settingsRepositoryProvider)));

final Provider<GetAppVersionUseCase> getAppVersionUseCaseProvider =
    Provider<GetAppVersionUseCase>((Ref ref) => GetAppVersionUseCase(ref.watch(appInfoServiceProvider)));

final FutureProvider<String> appVersionProvider = FutureProvider<String>((Ref ref) async {
  return await ref.read(getAppVersionUseCaseProvider).execute();
});

final AsyncNotifierProvider<SettingsNotifier, Settings> settingsProvider =
    AsyncNotifierProvider<SettingsNotifier, Settings>(SettingsNotifier.new);

final Provider<Settings> settingsValueProvider = Provider<Settings>((Ref ref) {
  return ref.watch(settingsProvider).value ?? const Settings();
});

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
  UpdateSettingsUseCase get _updateUseCase => ref.read(updateSettingsUseCaseProvider);

  @override
  Future<Settings> build() async {
    return await _loadSettings();
  }

  Future<Settings> _loadSettings() async {
    try {
      final settings = await ref.read(getSettingsUseCaseProvider).execute();
      ref.read(audioServiceProvider).setFxEnabled(settings.soundFxEnabled);
      return settings;
    } catch (e, stackTrace) {
      ref.read(loggerServiceProvider).error('Failed to load settings', e, stackTrace);
      rethrow;
    }
  }

  Future<void> _executeAndReload(Future<void> Function() action) async {
    await action();
    state = AsyncData(await _loadSettings());
  }

  Future<void> toggleDarkMode() => _executeAndReload(_updateUseCase.toggleDarkMode);

  Future<void> toggleSoundFx() => _executeAndReload(_updateUseCase.toggleSoundFx);

  Future<void> toggleAnimations() => _executeAndReload(_updateUseCase.toggleAnimations);

  Future<void> updateSettings(Settings settings) async {
    await _updateUseCase.execute((_) => settings);
    state = AsyncData(settings);
  }

  Future<void> setLanguage(String languageCode) =>
      _executeAndReload(() => _updateUseCase.setLanguage(languageCode));

  Future<void> setXShape(String shape) =>
      _executeAndReload(() => _updateUseCase.setXShape(shape));

  Future<void> setOShape(String shape) =>
      _executeAndReload(() => _updateUseCase.setOShape(shape));

  Future<void> setXShapeAndClearEmoji(String shape) =>
      _executeAndReload(() => _updateUseCase.setXShapeAndClearEmoji(shape));

  Future<void> setOShapeAndClearEmoji(String shape) =>
      _executeAndReload(() => _updateUseCase.setOShapeAndClearEmoji(shape));

  Future<void> setXEmoji(String? emoji) =>
      _executeAndReload(() => _updateUseCase.setXEmoji(emoji));

  Future<void> setOEmoji(String? emoji) =>
      _executeAndReload(() => _updateUseCase.setOEmoji(emoji));

  Future<void> setUseEmojis(bool useEmojis) =>
      _executeAndReload(() => _updateUseCase.setUseEmojis(useEmojis));
}
