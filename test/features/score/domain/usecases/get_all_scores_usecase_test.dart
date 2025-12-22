import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/features/score/domain/entities/player_score.dart';
import 'package:tictac/features/score/domain/repositories/score_repository.dart';
import 'package:tictac/features/score/domain/usecases/get_all_scores_usecase.dart';

class MockScoreRepository extends Mock implements ScoreRepository {}

void main() {
  late GetAllScoresUseCase useCase;
  late MockScoreRepository mockRepository;

  setUp(() {
    mockRepository = MockScoreRepository();
    useCase = GetAllScoresUseCase(mockRepository);
  });

  group('GetAllScoresUseCase', () {
    test('should return all scores from repository', () async {
      final List<PlayerScore> expectedScores = <PlayerScore>[
        const PlayerScore(playerName: 'player1', wins: 5, losses: 2, draws: 1, totalGames: 8),
        const PlayerScore(playerName: 'player2', wins: 3, losses: 4, draws: 1, totalGames: 8),
      ];

      when(() => mockRepository.getAllScores()).thenAnswer((_) async => expectedScores);

      final List<PlayerScore> result = await useCase.execute();

      expect(result, equals(expectedScores));
      expect(result.length, equals(2));
      verify(() => mockRepository.getAllScores()).called(1);
    });

    test('should return empty list when repository returns empty list', () async {
      when(() => mockRepository.getAllScores()).thenAnswer((_) async => <PlayerScore>[]);

      final List<PlayerScore> result = await useCase.execute();

      expect(result, isEmpty);
      verify(() => mockRepository.getAllScores()).called(1);
    });
  });
}
