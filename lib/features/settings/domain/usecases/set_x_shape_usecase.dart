import 'package:tictac/features/settings/domain/entities/settings.dart';
import 'package:tictac/features/settings/domain/repositories/settings_repository.dart';

class SetXShapeUseCase {

  SetXShapeUseCase(this._repository);
  final SettingsRepository _repository;

  Future<void> execute(String shape) async {
    final Settings currentSettings = await _repository.getSettings();
    final Settings updatedSettings = currentSettings.copyWith(xShape: shape);
    await _repository.saveSettings(updatedSettings);
  }
}

