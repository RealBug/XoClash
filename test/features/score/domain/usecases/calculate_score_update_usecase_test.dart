import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/features/score/domain/entities/player_score.dart';
import 'package:tictac/features/score/domain/usecases/calculate_score_update_usecase.dart';

void main() {
  group('CalculateScoreUpdateUseCase', () {
    late CalculateScoreUpdateUseCase useCase;

    setUp(() {
      useCase = CalculateScoreUpdateUseCase();
    });

    test('should create new score with win when currentScore is null', () {
      final PlayerScore result = useCase.execute(null, 'Player1', true, false);

      expect(result.playerName, 'Player1');
      expect(result.wins, 1);
      expect(result.losses, 0);
      expect(result.draws, 0);
      expect(result.totalGames, 1);
    });

    test('should create new score with loss when currentScore is null', () {
      final PlayerScore result = useCase.execute(null, 'Player1', false, false);

      expect(result.playerName, 'Player1');
      expect(result.wins, 0);
      expect(result.losses, 1);
      expect(result.draws, 0);
      expect(result.totalGames, 1);
    });

    test('should create new score with draw when currentScore is null', () {
      final PlayerScore result = useCase.execute(null, 'Player1', false, true);

      expect(result.playerName, 'Player1');
      expect(result.wins, 0);
      expect(result.losses, 0);
      expect(result.draws, 1);
      expect(result.totalGames, 1);
    });

    test('should increment wins when player wins', () {
      const PlayerScore currentScore = PlayerScore(
        playerName: 'Player1',
        wins: 5,
        losses: 3,
        draws: 2,
        totalGames: 10,
      );

      final PlayerScore result = useCase.execute(currentScore, 'Player1', true, false);

      expect(result.playerName, 'Player1');
      expect(result.wins, 6);
      expect(result.losses, 3);
      expect(result.draws, 2);
      expect(result.totalGames, 11);
    });

    test('should increment losses when player loses', () {
      const PlayerScore currentScore = PlayerScore(
        playerName: 'Player1',
        wins: 5,
        losses: 3,
        draws: 2,
        totalGames: 10,
      );

      final PlayerScore result = useCase.execute(currentScore, 'Player1', false, false);

      expect(result.playerName, 'Player1');
      expect(result.wins, 5);
      expect(result.losses, 4);
      expect(result.draws, 2);
      expect(result.totalGames, 11);
    });

    test('should increment draws when game is draw', () {
      const PlayerScore currentScore = PlayerScore(
        playerName: 'Player1',
        wins: 5,
        losses: 3,
        draws: 2,
        totalGames: 10,
      );

      final PlayerScore result = useCase.execute(currentScore, 'Player1', false, true);

      expect(result.playerName, 'Player1');
      expect(result.wins, 5);
      expect(result.losses, 3);
      expect(result.draws, 3);
      expect(result.totalGames, 11);
    });

    test('should not increment losses when game is draw', () {
      const PlayerScore currentScore = PlayerScore(
        playerName: 'Player1',
        wins: 5,
        losses: 3,
        draws: 2,
        totalGames: 10,
      );

      final PlayerScore result = useCase.execute(currentScore, 'Player1', false, true);

      expect(result.losses, 3);
    });
  });
}


