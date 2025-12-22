import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';

part 'get_game_result_info_usecase.freezed.dart';

@freezed
abstract class GameResultInfo with _$GameResultInfo {
  const factory GameResultInfo({
    required bool isCurrentPlayerWin,
    required bool isLocalFriendWin,
    required bool shouldShowConfetti,
    String? winningPlayerName,
  }) = _GameResultInfo;
}

class GetGameResultInfoUseCase {
  GameResultInfo execute(GameState gameState, String? currentUsername) {
    if (!gameState.isGameOver) {
      return const GameResultInfo(
        isCurrentPlayerWin: false,
        isLocalFriendWin: false,
        shouldShowConfetti: false,
      );
    }

    final bool isVictory = gameState.status == GameStatus.xWon ||
        gameState.status == GameStatus.oWon;

    if (!isVictory) {
      return const GameResultInfo(
        isCurrentPlayerWin: false,
        isLocalFriendWin: false,
        shouldShowConfetti: false,
      );
    }

    final bool isCurrentPlayerWin = _isCurrentPlayerWin(gameState, currentUsername);
    final bool isLocalFriendWin = _isLocalFriendWin(gameState, currentUsername);
    final bool shouldShowConfetti = isCurrentPlayerWin || isLocalFriendWin;
    final String? winningPlayerName = _getWinningPlayerName(gameState);

    return GameResultInfo(
      isCurrentPlayerWin: isCurrentPlayerWin,
      isLocalFriendWin: isLocalFriendWin,
      shouldShowConfetti: shouldShowConfetti,
      winningPlayerName: winningPlayerName,
    );
  }

  bool _isCurrentPlayerWin(GameState gameState, String? currentUsername) {
    if (gameState.status == GameStatus.xWon) {
      final bool isOfflineGame = gameState.gameMode != null && !gameState.isOnline;
      return gameState.playerXName == currentUsername ||
          (isOfflineGame && currentUsername != null);
    }

    if (gameState.status == GameStatus.oWon) {
      return gameState.playerOName == currentUsername;
    }

    return false;
  }

  bool _isLocalFriendWin(GameState gameState, String? currentUsername) {
    final bool isVictory = gameState.status == GameStatus.xWon ||
        gameState.status == GameStatus.oWon;
    if (!isVictory) {
      return false;
    }

    final bool isCurrentPlayerWin = _isCurrentPlayerWin(gameState, currentUsername);
    return gameState.gameMode == GameModeType.offlineFriend &&
        !isCurrentPlayerWin;
  }

  String? _getWinningPlayerName(GameState gameState) {
    if (gameState.status == GameStatus.xWon) {
      return gameState.playerXName;
    }
    if (gameState.status == GameStatus.oWon) {
      return gameState.playerOName;
    }
    return null;
  }
}
