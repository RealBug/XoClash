import 'package:tictac/features/settings/domain/entities/settings.dart';
import 'package:tictac/features/settings/domain/repositories/settings_repository.dart';

class SetOEmojiUseCase {

  SetOEmojiUseCase(this._repository);
  final SettingsRepository _repository;

  Future<void> execute(String? emoji) async {
    final Settings currentSettings = await _repository.getSettings();
    final Settings updatedSettings = currentSettings.copyWith(oEmoji: emoji);
    await _repository.saveSettings(updatedSettings);
  }
}

