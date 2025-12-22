import 'package:tictac/core/constants/app_constants.dart';
import 'package:tictac/core/constants/game_constants.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';

class GetPlayerNameUseCase {
  String getPlayerXName(GameState gameState, String? currentUsername) {
    if (gameState.playerXName != null && gameState.playerXName != currentUsername) {
      return gameState.playerXName!;
    }
    return currentUsername ?? '';
  }

  String getPlayerOName(GameState gameState, int? computerDifficulty) {
    if (gameState.playerOName != null) {
      return gameState.playerOName!;
    }
    if (gameState.gameMode == GameModeType.offlineComputer && computerDifficulty != null) {
      return _getComputerPlayerName(computerDifficulty);
    }
    return '';
  }

  String _getComputerPlayerName(int difficulty) {
    return switch (difficulty) {
      GameConstants.aiEasyDifficulty => AppConstants.aiPlayerNameEasy,
      GameConstants.aiMediumDifficulty => AppConstants.aiPlayerNameMedium,
      GameConstants.aiHardDifficulty => AppConstants.aiPlayerNameHard,
      _ => AppConstants.aiPlayerNameEasy,
    };
  }
}

