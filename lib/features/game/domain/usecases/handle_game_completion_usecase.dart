import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/usecases/get_player_name_usecase.dart';
import 'package:tictac/features/history/domain/entities/game_history.dart';
import 'package:tictac/features/history/domain/usecases/create_game_history_usecase.dart';

part 'handle_game_completion_usecase.freezed.dart';

@freezed
abstract class GameCompletionData with _$GameCompletionData {
  const factory GameCompletionData({
    required GameHistory history,
    required String? playerXName,
    required String? playerOName,
    required bool isXWin,
    required bool isOWin,
    required bool isDraw,
  }) = _GameCompletionData;
}

class HandleGameCompletionUseCase {

  HandleGameCompletionUseCase({
    required this.createGameHistoryUseCase,
    required this.getPlayerNameUseCase,
  });
  final CreateGameHistoryUseCase createGameHistoryUseCase;
  final GetPlayerNameUseCase getPlayerNameUseCase;

  GameCompletionData execute(GameState gameState, int? computerDifficulty) {
    final GameHistory history = createGameHistoryUseCase.execute(gameState);

    final String? playerXName = gameState.playerXName;
    final String? playerOName = gameState.playerOName ??
        (gameState.gameMode == GameModeType.offlineComputer &&
                computerDifficulty != null
            ? getPlayerNameUseCase.getPlayerOName(gameState, computerDifficulty)
            : null);

    final bool isXWin = gameState.status == GameStatus.xWon;
    final bool isOWin = gameState.status == GameStatus.oWon;
    final bool isDraw = gameState.status == GameStatus.draw;

    return GameCompletionData(
      history: history,
      playerXName: playerXName,
      playerOName: playerOName,
      isXWin: isXWin,
      isOWin: isOWin,
      isDraw: isDraw,
    );
  }
}
