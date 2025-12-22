class GameConstants {
  GameConstants._();

  static const Duration websocketTimeout = Duration(seconds: 5);
  static const Duration fontsLoadingTimeout = Duration(seconds: 5);
  static const Duration snackBarDuration = Duration(seconds: 5);
  static const Duration gameResultDelay = Duration(milliseconds: 500);

  static const int aiEasyDifficulty = 1;
  static const int aiMediumDifficulty = 2;
  static const int aiHardDifficulty = 3;

  static const Duration aiEasyMoveDelay = Duration(milliseconds: 800);
  static const Duration aiMediumMoveDelay = Duration(milliseconds: 500);
  static const Duration aiHardMoveDelay = Duration(milliseconds: 300);

  static const double aiMediumWinProbability = 0.7;

  static const int defaultBoardSize = 3;
  static const int minBoardSize = 3;
  static const int maxBoardSize = 5;

  static const int winCondition3x3 = 3;
  static const int winCondition4x4 = 4;
  static const int winCondition5x5 = 4;

  static int getWinCondition(int boardSize) {
    switch (boardSize) {
      case 3:
        return winCondition3x3;
      case 4:
        return winCondition4x4;
      case 5:
        return winCondition5x5;
      default:
        return winCondition3x3;
    }
  }
}

