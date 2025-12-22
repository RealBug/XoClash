import 'package:tictac/features/settings/domain/entities/settings.dart';
import 'package:tictac/features/settings/domain/repositories/settings_repository.dart';

class SaveSettingsUseCase {

  SaveSettingsUseCase(this.repository);
  final SettingsRepository repository;

  Future<void> execute(Settings settings) async {
    await repository.saveSettings(settings);
  }
}


















