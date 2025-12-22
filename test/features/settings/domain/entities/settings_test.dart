import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/features/settings/domain/entities/settings.dart';

void main() {
  group('Settings', () {
    test('should create Settings with default values', () {
      const Settings settings = Settings();

      expect(settings.isDarkMode, true);
      expect(settings.soundFxEnabled, true);
      expect(settings.animationsEnabled, true);
      expect(settings.languageCode, 'en');
      expect(settings.xShape, 'classic');
      expect(settings.oShape, 'classic');
      expect(settings.xEmoji, null);
      expect(settings.oEmoji, null);
      expect(settings.useEmojis, false);
    });

    test('should create Settings with custom values', () {
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

      expect(settings.isDarkMode, false);
      expect(settings.soundFxEnabled, false);
      expect(settings.animationsEnabled, false);
      expect(settings.languageCode, 'fr');
      expect(settings.xShape, 'circle');
      expect(settings.oShape, 'square');
      expect(settings.xEmoji, '😀');
      expect(settings.oEmoji, '😊');
      expect(settings.useEmojis, true);
    });

    test('copyWith should update properties', () {
      const Settings settings = Settings(
        
      );

      final Settings updated = settings.copyWith(
        isDarkMode: false,
        languageCode: 'fr',
      );

      expect(updated.isDarkMode, false);
      expect(updated.soundFxEnabled, true);
      expect(updated.languageCode, 'fr');
    });

    test('copyWith should set emoji to null when explicitly set', () {
      const Settings settings = Settings(
        xEmoji: '😀',
        oEmoji: '😊',
      );

      final Settings updated = settings.copyWith(
        xEmoji: null,
        oEmoji: null,
      );

      expect(updated.xEmoji, null);
      expect(updated.oEmoji, null);
    });

    test('copyWith should keep original emoji when not specified', () {
      const Settings settings = Settings(
        xEmoji: '😀',
        oEmoji: '😊',
      );

      final Settings updated = settings.copyWith(
        isDarkMode: false,
      );

      expect(updated.xEmoji, '😀');
      expect(updated.oEmoji, '😊');
    });

    test('should be equal when properties are equal', () {
      const Settings settings1 = Settings(
        xEmoji: '😀',
        oEmoji: '😊',
      );

      const Settings settings2 = Settings(
        xEmoji: '😀',
        oEmoji: '😊',
      );

      expect(settings1, settings2);
    });
  });
}


