import 'package:tictac/features/settings/domain/entities/settings.dart';
import 'package:tictac/features/settings/domain/repositories/settings_repository.dart';

class ToggleAnimationsUseCase {

  ToggleAnimationsUseCase(this._repository);
  final SettingsRepository _repository;

  Future<void> execute() async {
    final Settings currentSettings = await _repository.getSettings();
    final Settings updatedSettings = currentSettings.copyWith(animationsEnabled: !currentSettings.animationsEnabled);
    await _repository.saveSettings(updatedSettings);
  }
}

