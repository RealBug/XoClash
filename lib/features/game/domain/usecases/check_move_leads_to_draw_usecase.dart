import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/entities/game_state_extensions.dart';
import 'package:tictac/features/game/domain/usecases/check_can_force_draw_usecase.dart';
import 'package:tictac/features/game/domain/usecases/check_has_winning_move_usecase.dart';
import 'package:tictac/features/game/domain/usecases/check_winner_usecase.dart';
import 'package:tictac/features/game/domain/usecases/count_remaining_moves_usecase.dart';

class CheckMoveLeadsToDrawUseCase {
  CheckMoveLeadsToDrawUseCase({
    CheckWinnerUseCase? checkWinnerUseCase,
    CountRemainingMovesUseCase? countRemainingMovesUseCase,
    CheckCanForceDrawUseCase? checkCanForceDrawUseCase,
    CheckHasWinningMoveUseCase? checkHasWinningMoveUseCase,
  })  : _checkWinnerUseCase = checkWinnerUseCase ?? CheckWinnerUseCase(),
        _countRemainingMovesUseCase = countRemainingMovesUseCase ?? CountRemainingMovesUseCase(),
        _checkCanForceDrawUseCase = checkCanForceDrawUseCase ?? CheckCanForceDrawUseCase(),
        _checkHasWinningMoveUseCase = checkHasWinningMoveUseCase ?? CheckHasWinningMoveUseCase();

  final CheckWinnerUseCase _checkWinnerUseCase;
  final CountRemainingMovesUseCase _countRemainingMovesUseCase;
  final CheckCanForceDrawUseCase _checkCanForceDrawUseCase;
  final CheckHasWinningMoveUseCase _checkHasWinningMoveUseCase;

  bool execute(GameState gameState, List<int> move) {
    final board = gameState.board.deepCopy();
    board[move[0]][move[1]] = gameState.currentPlayer;

    final opponent = gameState.currentPlayer == Player.x ? Player.o : Player.x;
    final testGameState = GameState(board: board, currentPlayer: opponent, status: GameStatus.playing);
    final result = _checkWinnerUseCase.execute(testGameState);

    if (result.status == GameStatus.xWon || result.status == GameStatus.oWon) {
      return false;
    }

    if (result.status == GameStatus.draw) {
      return true;
    }

    final remainingMoves = _countRemainingMovesUseCase.execute(board);
    if (remainingMoves <= 1) {
      return true;
    }

    final opponentCanWinNext = _checkHasWinningMoveUseCase.execute(board, opponent);
    if (opponentCanWinNext) {
      return false;
    }

    return _checkCanForceDrawUseCase.execute(testGameState);
  }
}

