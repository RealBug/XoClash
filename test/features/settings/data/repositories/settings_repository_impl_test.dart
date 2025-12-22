import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/features/settings/data/datasources/settings_datasource.dart';
import 'package:tictac/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:tictac/features/settings/domain/entities/settings.dart';

class MockSettingsDataSource extends Mock implements SettingsDataSource {}

void setUpAllFallbacks() {
  registerFallbackValue(const Settings());
}

void main() {
  setUpAll(() {
    setUpAllFallbacks();
  });
  late SettingsRepositoryImpl repository;
  late MockSettingsDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockSettingsDataSource();
    when(() => mockDataSource.getSettings()).thenAnswer((_) async => const Settings());
    repository = SettingsRepositoryImpl(dataSource: mockDataSource);
  });

  tearDown(() {
    repository.dispose();
  });

  group('SettingsRepositoryImpl', () {
    test('should get settings', () async {
      const Settings settings = Settings(
        isDarkMode: false,
        soundFxEnabled: false,
        languageCode: 'fr',
      );

      when(() => mockDataSource.getSettings()).thenAnswer((_) async => settings);

      final Settings result = await repository.getSettings();

      expect(result, settings);
      verify(() => mockDataSource.getSettings()).called(greaterThanOrEqualTo(1));
    });

    test('should save settings', () async {
      const Settings settings = Settings(
        
      );

      when(() => mockDataSource.saveSettings(settings)).thenAnswer((_) async => Future<void>.value());

      await repository.saveSettings(settings);

      verify(() => mockDataSource.saveSettings(settings)).called(1);
    });

    test('should watch settings stream', () async {
      const Settings initialSettings = Settings();
      const Settings updatedSettings = Settings(isDarkMode: false);

      when(() => mockDataSource.getSettings()).thenAnswer((_) async => initialSettings);
      when(() => mockDataSource.saveSettings(any(that: isA<Settings>()))).thenAnswer((_) async => Future<void>.value());

      await Future<void>.delayed(const Duration(milliseconds: 50));

      final Stream<Settings> stream = repository.watchSettings();
      final List<Settings> values = <Settings>[];
      final StreamSubscription<Settings> subscription = stream.listen((Settings value) {
        values.add(value);
      });

      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(values.length, greaterThanOrEqualTo(1));

      await repository.saveSettings(updatedSettings);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(values.last, updatedSettings);
      await subscription.cancel();
    });

    test('should dispose stream controller', () {
      expect(() => repository.dispose(), returnsNormally);
    });
  });
}
