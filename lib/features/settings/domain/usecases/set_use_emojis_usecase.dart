import 'package:tictac/features/settings/domain/entities/settings.dart';
import 'package:tictac/features/settings/domain/repositories/settings_repository.dart';

class SetUseEmojisUseCase {

  SetUseEmojisUseCase(this._repository);
  final SettingsRepository _repository;

  Future<void> execute(bool useEmojis) async {
    final Settings currentSettings = await _repository.getSettings();
    final Settings updatedSettings = currentSettings.copyWith(useEmojis: useEmojis);
    await _repository.saveSettings(updatedSettings);
  }
}

