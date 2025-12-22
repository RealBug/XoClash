import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/features/settings/domain/entities/settings.dart';
import 'package:tictac/features/settings/domain/repositories/settings_repository.dart';
import 'package:tictac/features/settings/domain/usecases/set_o_shape_usecase.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(const Settings());
  });

  late SetOShapeUseCase useCase;
  late MockSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockSettingsRepository();
    useCase = SetOShapeUseCase(mockRepository);
  });

  group('SetOShapeUseCase', () {
    test('should set o shape and save', () async {
      const Settings initialSettings = Settings();
      const String shape = 'rounded';
      const Settings expectedSettings = Settings(oShape: shape);

      when(() => mockRepository.getSettings())
          .thenAnswer((_) async => initialSettings);
      when(() => mockRepository.saveSettings(any()))
          .thenAnswer((_) async => Future<void>.value());

      await useCase.execute(shape);

      verify(() => mockRepository.saveSettings(expectedSettings)).called(1);
    });

    test('should preserve other settings when setting o shape', () async {
      const Settings initialSettings = Settings(
        isDarkMode: false,
      );
      const String shape = 'outline';
      const Settings expectedSettings = Settings(
        isDarkMode: false,
        oShape: shape,
      );

      when(() => mockRepository.getSettings())
          .thenAnswer((_) async => initialSettings);
      when(() => mockRepository.saveSettings(any()))
          .thenAnswer((_) async => Future<void>.value());

      await useCase.execute(shape);

      verify(() => mockRepository.saveSettings(expectedSettings)).called(1);
    });

    test('should propagate errors from repository', () async {
      when(() => mockRepository.getSettings())
          .thenThrow(Exception('Error getting settings'));

      expect(() => useCase.execute('rounded'), throwsException);
    });
  });
}

