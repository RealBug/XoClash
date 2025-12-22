import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/features/settings/domain/entities/settings.dart';
import 'package:tictac/features/settings/domain/repositories/settings_repository.dart';
import 'package:tictac/features/settings/domain/usecases/get_settings_usecase.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late GetSettingsUseCase useCase;
  late MockSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockSettingsRepository();
    useCase = GetSettingsUseCase(mockRepository);
  });

  test('should return settings', () async {
    const Settings expectedSettings = Settings(
      
    );

    when(() => mockRepository.getSettings())
        .thenAnswer((_) async => expectedSettings);

    final Settings result = await useCase.execute();

    expect(result, equals(expectedSettings));
    verify(() => mockRepository.getSettings()).called(1);
  });

  test('should propagate errors from repository', () async {
    when(() => mockRepository.getSettings())
        .thenThrow(Exception('Error getting settings'));

    expect(() => useCase.execute(), throwsException);
    verify(() => mockRepository.getSettings()).called(1);
  });
}




















