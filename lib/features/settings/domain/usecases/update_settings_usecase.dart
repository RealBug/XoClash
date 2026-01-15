import 'package:tictac/features/settings/domain/entities/settings.dart';
import 'package:tictac/features/settings/domain/repositories/settings_repository.dart';

class UpdateSettingsUseCase {
  UpdateSettingsUseCase(this._repository);

  final SettingsRepository _repository;

  Future<void> execute(Settings Function(Settings current) transform) async {
    final currentSettings = await _repository.getSettings();
    final updatedSettings = transform(currentSettings);
    await _repository.saveSettings(updatedSettings);
  }

  Future<void> toggleDarkMode() => execute((s) => s.copyWith(isDarkMode: !s.isDarkMode));

  Future<void> toggleSoundFx() => execute((s) => s.copyWith(soundFxEnabled: !s.soundFxEnabled));

  Future<void> toggleAnimations() => execute((s) => s.copyWith(animationsEnabled: !s.animationsEnabled));

  Future<void> setLanguage(String languageCode) => execute((s) => s.copyWith(languageCode: languageCode));

  Future<void> setXShape(String shape) => execute((s) => s.copyWith(xShape: shape));

  Future<void> setOShape(String shape) => execute((s) => s.copyWith(oShape: shape));

  Future<void> setXShapeAndClearEmoji(String shape) => execute((s) => s.copyWith(xShape: shape, xEmoji: null));

  Future<void> setOShapeAndClearEmoji(String shape) => execute((s) => s.copyWith(oShape: shape, oEmoji: null));

  Future<void> setXEmoji(String? emoji) => execute((s) => s.copyWith(xEmoji: emoji));

  Future<void> setOEmoji(String? emoji) => execute((s) => s.copyWith(oEmoji: emoji));

  Future<void> setUseEmojis(bool useEmojis) => execute((s) => s.copyWith(useEmojis: useEmojis));
}
