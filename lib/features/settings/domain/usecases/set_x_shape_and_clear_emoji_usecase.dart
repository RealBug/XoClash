import 'package:tictac/features/settings/domain/entities/settings.dart';
import 'package:tictac/features/settings/domain/repositories/settings_repository.dart';

class SetXShapeAndClearEmojiUseCase {

  SetXShapeAndClearEmojiUseCase(this._repository);
  final SettingsRepository _repository;

  Future<void> execute(String shape) async {
    final Settings currentSettings = await _repository.getSettings();
    final Settings updatedSettings = currentSettings.copyWith(xShape: shape, xEmoji: null);
    await _repository.saveSettings(updatedSettings);
  }
}

