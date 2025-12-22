import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/features/score/domain/repositories/score_repository.dart';
import 'package:tictac/features/score/domain/usecases/reset_scores_usecase.dart';

class MockScoreRepository extends Mock implements ScoreRepository {}

void main() {
  late ResetScoresUseCase useCase;
  late MockScoreRepository mockRepository;

  setUp(() {
    mockRepository = MockScoreRepository();
    useCase = ResetScoresUseCase(mockRepository);
  });

  group('ResetScoresUseCase', () {
    test('should reset scores', () async {
      when(() => mockRepository.resetScores())
          .thenAnswer((_) async => Future<void>.value());

      await useCase.execute();

      verify(() => mockRepository.resetScores()).called(1);
    });

    test('should propagate errors from repository', () async {
      when(() => mockRepository.resetScores())
          .thenThrow(Exception('Error resetting scores'));

      expect(() => useCase.execute(), throwsException);
    });
  });
}

