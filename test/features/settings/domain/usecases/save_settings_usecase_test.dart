import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/features/settings/domain/entities/settings.dart';
import 'package:tictac/features/settings/domain/repositories/settings_repository.dart';
import 'package:tictac/features/settings/domain/usecases/save_settings_usecase.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late SaveSettingsUseCase useCase;
  late MockSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockSettingsRepository();
    useCase = SaveSettingsUseCase(mockRepository);
  });

  test('should save settings', () async {
    const Settings settings = Settings(
      languageCode: 'fr',
    );

    when(() => mockRepository.saveSettings(settings))
        .thenAnswer((_) async => Future<void>.value());

    await useCase.execute(settings);

    verify(() => mockRepository.saveSettings(settings)).called(1);
  });

  test('should propagate errors from repository', () async {
    const Settings settings = Settings();

    when(() => mockRepository.saveSettings(settings))
        .thenThrow(Exception('Error saving settings'));

    expect(() => useCase.execute(settings), throwsException);
    verify(() => mockRepository.saveSettings(settings)).called(1);
  });
}




















