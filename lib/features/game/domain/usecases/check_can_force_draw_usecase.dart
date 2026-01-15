import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/entities/game_state_extensions.dart';
import 'package:tictac/features/game/domain/usecases/check_has_winning_move_usecase.dart';
import 'package:tictac/features/game/domain/usecases/check_winner_usecase.dart';
import 'package:tictac/features/game/domain/usecases/count_remaining_moves_usecase.dart';
import 'package:tictac/features/game/domain/usecases/get_available_moves_usecase.dart';

class CheckCanForceDrawUseCase {
  CheckCanForceDrawUseCase({
    required CheckWinnerUseCase checkWinnerUseCase,
    required CountRemainingMovesUseCase countRemainingMovesUseCase,
    required GetAvailableMovesUseCase getAvailableMovesUseCase,
    required CheckHasWinningMoveUseCase checkHasWinningMoveUseCase,
  }) : _checkWinnerUseCase = checkWinnerUseCase,
       _countRemainingMovesUseCase = countRemainingMovesUseCase,
       _getAvailableMovesUseCase = getAvailableMovesUseCase,
       _checkHasWinningMoveUseCase = checkHasWinningMoveUseCase;

  final CheckWinnerUseCase _checkWinnerUseCase;
  final CountRemainingMovesUseCase _countRemainingMovesUseCase;
  final GetAvailableMovesUseCase _getAvailableMovesUseCase;
  final CheckHasWinningMoveUseCase _checkHasWinningMoveUseCase;

  bool execute(GameState gameState) {
    final board = gameState.board;
    final remainingMoves = _countRemainingMovesUseCase.execute(board);

    if (remainingMoves == 0) {
      return true;
    }

    if (remainingMoves <= 2) {
      final currentPlayer = gameState.currentPlayer;
      final opponent = currentPlayer == Player.x ? Player.o : Player.x;

      for (final move in _getAvailableMovesUseCase.execute(board)) {
        final testBoard = board.deepCopy();
        testBoard[move[0]][move[1]] = currentPlayer;

        final testGameState = GameState(
          board: testBoard,
          currentPlayer: opponent,
          status: GameStatus.playing,
        );
        final result = _checkWinnerUseCase.execute(testGameState);

        if (result.status == GameStatus.xWon && currentPlayer == Player.x ||
            result.status == GameStatus.oWon && currentPlayer == Player.o) {
          continue;
        }

        if (result.status == GameStatus.draw) {
          return true;
        }

        if (result.status == GameStatus.playing) {
          final opponentCanWin = _checkHasWinningMoveUseCase.execute(
            testBoard,
            opponent,
          );
          if (!opponentCanWin) {
            return true;
          }
        }
      }
    }

    return false;
  }
}
