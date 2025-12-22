import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictac/features/settings/data/datasources/settings_datasource.dart';
import 'package:tictac/features/settings/domain/entities/settings.dart';

void main() {
  late SettingsDataSourceImpl dataSource;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    dataSource = SettingsDataSourceImpl();
  });

  group('SettingsDataSourceImpl', () {
    test('should return default settings when no settings exist', () async {
      final Settings result = await dataSource.getSettings();

      expect(result.isDarkMode, true);
      expect(result.soundFxEnabled, true);
      expect(result.animationsEnabled, true);
      expect(result.languageCode, 'en');
      expect(result.xShape, 'classic');
      expect(result.oShape, 'classic');
      expect(result.useEmojis, false);
    });

    test('should save and retrieve settings', () async {
      const Settings settings = Settings(
        isDarkMode: false,
        soundFxEnabled: false,
        animationsEnabled: false,
        languageCode: 'fr',
        xShape: 'circle',
        oShape: 'square',
        xEmoji: '😀',
        oEmoji: '😊',
        useEmojis: true,
      );

      await dataSource.saveSettings(settings);
      final Settings result = await dataSource.getSettings();

      expect(result.isDarkMode, settings.isDarkMode);
      expect(result.soundFxEnabled, settings.soundFxEnabled);
      expect(result.animationsEnabled, settings.animationsEnabled);
      expect(result.languageCode, settings.languageCode);
      expect(result.xShape, settings.xShape);
      expect(result.oShape, settings.oShape);
      expect(result.xEmoji, settings.xEmoji);
      expect(result.oEmoji, settings.oEmoji);
      expect(result.useEmojis, settings.useEmojis);
    });

    test('should migrate old soundEnabled to soundFxEnabled', () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('app_settings', '{"soundEnabled": false, "isDarkMode": true}');

      final Settings result = await dataSource.getSettings();

      expect(result.soundFxEnabled, false);
    });

    test('should handle null emojis', () async {
      const Settings settings = Settings(
        
      );

      await dataSource.saveSettings(settings);
      final Settings result = await dataSource.getSettings();

      expect(result.xEmoji, null);
      expect(result.oEmoji, null);
    });
  });
}


