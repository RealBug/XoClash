import 'dart:math' as math;

import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/entities/game_state_extensions.dart';
import 'package:tictac/features/game/domain/strategies/ai_strategy_factory.dart';
import 'package:tictac/features/game/domain/usecases/check_has_winning_move_usecase.dart';
import 'package:tictac/features/game/domain/usecases/check_move_leads_to_draw_usecase.dart';
import 'package:tictac/features/game/domain/usecases/get_available_moves_usecase.dart';

class SelectAIMoveUseCase {
  SelectAIMoveUseCase({
    GetAvailableMovesUseCase? getAvailableMovesUseCase,
    required CheckHasWinningMoveUseCase checkHasWinningMoveUseCase,
    required CheckMoveLeadsToDrawUseCase checkMoveLeadsToDrawUseCase,
    math.Random? random,
  })  : _getAvailableMovesUseCase = getAvailableMovesUseCase ?? GetAvailableMovesUseCase(),
        _checkHasWinningMoveUseCase = checkHasWinningMoveUseCase,
        _checkMoveLeadsToDrawUseCase = checkMoveLeadsToDrawUseCase,
        _random = random ?? math.Random();

  final GetAvailableMovesUseCase _getAvailableMovesUseCase;
  final CheckHasWinningMoveUseCase _checkHasWinningMoveUseCase;
  final CheckMoveLeadsToDrawUseCase _checkMoveLeadsToDrawUseCase;
  final math.Random _random;

  GameState execute(GameState gameState, int difficulty) {
    final availableMoves = _getAvailableMovesUseCase.execute(gameState.board);

    if (availableMoves.isEmpty) {
      return gameState;
    }

    final strategy = AIStrategyFactory.create(
      difficulty,
      checkHasWinningMoveUseCase: _checkHasWinningMoveUseCase,
      checkMoveLeadsToDrawUseCase: _checkMoveLeadsToDrawUseCase,
      random: _random,
    );
    final move = strategy.selectMove(gameState, availableMoves);

    final newBoard = gameState.board.deepCopy();
    newBoard[move[0]][move[1]] = gameState.currentPlayer;

    return gameState.copyWith(board: newBoard);
  }
}
