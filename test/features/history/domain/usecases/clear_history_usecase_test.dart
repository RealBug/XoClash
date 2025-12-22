import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/features/history/domain/repositories/history_repository.dart';
import 'package:tictac/features/history/domain/usecases/clear_history_usecase.dart';

class MockHistoryRepository extends Mock implements HistoryRepository {}

void main() {
  late ClearHistoryUseCase useCase;
  late MockHistoryRepository mockRepository;

  setUp(() {
    mockRepository = MockHistoryRepository();
    useCase = ClearHistoryUseCase(mockRepository);
  });

  group('ClearHistoryUseCase', () {
    test('should clear history', () async {
      when(() => mockRepository.clearHistory())
          .thenAnswer((_) async => Future<void>.value());

      await useCase.execute();

      verify(() => mockRepository.clearHistory()).called(1);
    });

    test('should propagate errors from repository', () async {
      when(() => mockRepository.clearHistory())
          .thenThrow(Exception('Error clearing history'));

      expect(() => useCase.execute(), throwsException);
    });
  });
}

