import 'package:tictac/features/settings/domain/entities/settings.dart';
import 'package:tictac/features/settings/domain/repositories/settings_repository.dart';

class ToggleSoundFxUseCase {

  ToggleSoundFxUseCase(this._repository);
  final SettingsRepository _repository;

  Future<void> execute() async {
    final Settings currentSettings = await _repository.getSettings();
    final Settings updatedSettings = currentSettings.copyWith(soundFxEnabled: !currentSettings.soundFxEnabled);
    await _repository.saveSettings(updatedSettings);
  }
}

