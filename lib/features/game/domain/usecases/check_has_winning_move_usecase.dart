import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/usecases/check_winner_usecase.dart';

class CheckHasWinningMoveUseCase {
  CheckHasWinningMoveUseCase(this._checkWinnerUseCase);

  final CheckWinnerUseCase _checkWinnerUseCase;

  bool execute(List<List<Player>> board, Player player) {
    final testGameState = GameState(
      board: board,
      currentPlayer: player,
      status: GameStatus.playing,
    );
    final result = _checkWinnerUseCase.execute(testGameState);
    return result.status == GameStatus.xWon && player == Player.x ||
        result.status == GameStatus.oWon && player == Player.o;
  }
}
