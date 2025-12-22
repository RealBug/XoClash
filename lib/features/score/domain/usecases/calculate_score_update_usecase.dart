import 'package:tictac/features/score/domain/entities/player_score.dart';

class CalculateScoreUpdateUseCase {
  PlayerScore execute(PlayerScore? currentScore, String playerName, bool isWin, bool isDraw) {
    if (currentScore != null) {
      return currentScore.copyWith(
        wins: isWin ? currentScore.wins + 1 : currentScore.wins,
        losses: !isWin && !isDraw ? currentScore.losses + 1 : currentScore.losses,
        draws: isDraw ? currentScore.draws + 1 : currentScore.draws,
        totalGames: currentScore.totalGames + 1,
      );
    }

    return PlayerScore(
      playerName: playerName,
      wins: isWin ? 1 : 0,
      losses: !isWin && !isDraw ? 1 : 0,
      draws: isDraw ? 1 : 0,
      totalGames: 1,
    );
  }
}

