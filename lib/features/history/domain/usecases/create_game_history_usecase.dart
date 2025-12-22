import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/history/domain/entities/game_history.dart';

class CreateGameHistoryUseCase {
  GameHistory execute(GameState gameState) {
    return GameHistory(
      id: gameState.gameId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      playerXName: gameState.playerXName,
      playerOName: gameState.playerOName,
      result: gameState.status,
      gameMode: gameState.gameMode,
      boardSize: gameState.board.length,
      computerDifficulty: gameState.computerDifficulty,
    );
  }
}

