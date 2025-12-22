import 'package:tictac/features/settings/domain/entities/settings.dart';

abstract class SettingsRepository {
  Future<Settings> getSettings();
  Future<void> saveSettings(Settings settings);
  Stream<Settings> watchSettings();
}


















