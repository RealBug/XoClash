import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/features/score/domain/entities/player_score.dart';
import 'package:tictac/features/score/domain/repositories/score_repository.dart';
import 'package:tictac/features/score/domain/usecases/update_player_score_usecase.dart';

class MockScoreRepository extends Mock implements ScoreRepository {}

void main() {
  late UpdatePlayerScoreUseCase useCase;
  late MockScoreRepository mockRepository;

  setUp(() {
    mockRepository = MockScoreRepository();
    useCase = UpdatePlayerScoreUseCase(mockRepository);
  });

  group('UpdatePlayerScoreUseCase', () {
    test('should update player score successfully', () async {
      const PlayerScore score = PlayerScore(
        playerName: 'testPlayer',
        wins: 5,
        losses: 3,
        draws: 2,
        totalGames: 10,
      );

      when(() => mockRepository.updatePlayerScore(score)).thenAnswer((_) async => Future<void>.value());

      await useCase.execute(score);

      verify(() => mockRepository.updatePlayerScore(score)).called(1);
    });
  });
}
