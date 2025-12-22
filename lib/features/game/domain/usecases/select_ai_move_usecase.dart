import 'dart:math' as math;

import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/entities/game_state_extensions.dart';
import 'package:tictac/features/game/domain/strategies/ai_strategy_factory.dart';
import 'package:tictac/features/game/domain/usecases/get_available_moves_usecase.dart';

class SelectAIMoveUseCase {
  SelectAIMoveUseCase({
    GetAvailableMovesUseCase? getAvailableMovesUseCase,
    math.Random? random,
  })  : _getAvailableMovesUseCase = getAvailableMovesUseCase ?? GetAvailableMovesUseCase(),
        _random = random ?? math.Random();

  final GetAvailableMovesUseCase _getAvailableMovesUseCase;
  final math.Random _random;

  GameState execute(GameState gameState, int difficulty) {
    final availableMoves = _getAvailableMovesUseCase.execute(gameState.board);

    if (availableMoves.isEmpty) {
      return gameState;
    }

    final strategy = AIStrategyFactory.create(difficulty, random: _random);
    final move = strategy.selectMove(gameState, availableMoves);

    final newBoard = gameState.board.deepCopy();
    newBoard[move[0]][move[1]] = gameState.currentPlayer;

    return gameState.copyWith(board: newBoard);
  }
}

