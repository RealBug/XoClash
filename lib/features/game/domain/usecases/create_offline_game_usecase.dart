import 'package:tictac/core/constants/app_constants.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/entities/game_state_extensions.dart';

/// Use case for creating an offline game
/// 
/// This use case handles the business logic for creating an offline game,
/// including generating a unique game ID and creating the initial GameState.
class CreateOfflineGameUseCase {
  /// Creates an offline game with the specified parameters
  /// 
  /// [boardSize] - The size of the game board (e.g., 3 for 3x3)
  /// [mode] - The game mode (offlineFriend or offlineComputer)
  /// [difficulty] - Optional difficulty level for computer games (1-3)
  /// [playerXName] - Optional name for player X
  /// [playerOName] - Optional name for player O
  /// 
  /// Returns the created GameState
  GameState execute({
    required int boardSize,
    required GameModeType mode,
    int? difficulty,
    String? playerXName,
    String? playerOName,
  }) {
    final String gameId = _generateOfflineGameId(mode);
    
    return GameState(
      board: boardSize.createEmptyBoard(),
      status: GameStatus.playing,
      gameId: gameId,
      gameMode: mode,
      computerDifficulty: difficulty,
      playerXName: playerXName,
      playerOName: playerOName,
    );
  }

  String _generateOfflineGameId(GameModeType mode) {
    return '${AppConstants.offlineGameIdPrefix}${mode.toString()}_${DateTime.now().millisecondsSinceEpoch}';
  }
}

