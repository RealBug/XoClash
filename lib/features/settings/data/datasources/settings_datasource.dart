import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictac/core/constants/app_constants.dart';
import 'package:tictac/features/settings/domain/entities/settings.dart';

abstract class SettingsDataSource {
  Future<Settings> getSettings();
  Future<void> saveSettings(Settings settings);
}

class SettingsDataSourceImpl implements SettingsDataSource {
  static const String _settingsKey = AppConstants.storageKeySettings;

  @override
  Future<Settings> getSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? settingsJson = prefs.getString(_settingsKey);

    if (settingsJson == null) {
      return const Settings();
    }

    final Map<String, dynamic> settingsMap = jsonDecode(settingsJson) as Map<String, dynamic>;
    return Settings.fromJson(settingsMap);
  }

  @override
  Future<void> saveSettings(Settings settings) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, jsonEncode(settings.toJson()));
  }
}
