import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:tictac/features/settings/data/datasources/settings_datasource.dart';
import 'package:tictac/features/settings/domain/entities/settings.dart';
import 'package:tictac/features/settings/domain/repositories/settings_repository.dart';

@Injectable(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {

  SettingsRepositoryImpl({required this.dataSource}) {
    _loadAndEmitSettings();
  }
  final SettingsDataSource dataSource;
  final StreamController<Settings> _settingsController =
      StreamController<Settings>.broadcast();

  @override
  Future<Settings> getSettings() async {
    return await dataSource.getSettings();
  }

  @override
  Future<void> saveSettings(Settings settings) async {
    await dataSource.saveSettings(settings);
    _settingsController.add(settings);
  }

  @override
  Stream<Settings> watchSettings() async* {
    yield await getSettings();
    yield* _settingsController.stream;
  }

  Future<void> _loadAndEmitSettings() async {
    final Settings settings = await getSettings();
    _settingsController.add(settings);
  }

  void dispose() {
    _settingsController.close();
  }
}



















