import 'package:tictac/features/settings/domain/entities/settings.dart';
import 'package:tictac/features/settings/domain/repositories/settings_repository.dart';

class GetSettingsUseCase {

  GetSettingsUseCase(this.repository);
  final SettingsRepository repository;

  Future<Settings> execute() async {
    return await repository.getSettings();
  }
}


















