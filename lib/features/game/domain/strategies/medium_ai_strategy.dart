import 'dart:math' as math;

import 'package:tictac/core/constants/game_constants.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/entities/game_state_extensions.dart';
import 'package:tictac/features/game/domain/strategies/ai_strategy.dart';
import 'package:tictac/features/game/domain/strategies/easy_ai_strategy.dart';
import 'package:tictac/features/game/domain/usecases/check_has_winning_move_usecase.dart';
import 'package:tictac/features/game/domain/usecases/check_move_leads_to_draw_usecase.dart';

class MediumAIStrategy implements AIStrategy {
  MediumAIStrategy({
    math.Random? random,
    CheckHasWinningMoveUseCase? checkHasWinningMoveUseCase,
    CheckMoveLeadsToDrawUseCase? checkMoveLeadsToDrawUseCase,
  })  : _random = random ?? math.Random(),
        _checkHasWinningMoveUseCase = checkHasWinningMoveUseCase ?? CheckHasWinningMoveUseCase(),
        _checkMoveLeadsToDrawUseCase = checkMoveLeadsToDrawUseCase ?? CheckMoveLeadsToDrawUseCase();

  final math.Random _random;
  final CheckHasWinningMoveUseCase _checkHasWinningMoveUseCase;
  final CheckMoveLeadsToDrawUseCase _checkMoveLeadsToDrawUseCase;

  @override
  List<int> selectMove(GameState gameState, List<List<int>> availableMoves) {
    final board = gameState.board;
    final opponent = gameState.currentPlayer == Player.x ? Player.o : Player.x;

    for (final move in availableMoves) {
      final testBoard = board.deepCopy();
      testBoard[move[0]][move[1]] = opponent;

      if (_checkHasWinningMoveUseCase.execute(testBoard, opponent)) {
        return move;
      }
    }

    if (_random.nextDouble() < GameConstants.aiMediumWinProbability) {
      for (final move in availableMoves) {
        final testBoard = board.deepCopy();
        testBoard[move[0]][move[1]] = gameState.currentPlayer;

        if (_checkHasWinningMoveUseCase.execute(testBoard, gameState.currentPlayer)) {
          return move;
        }
      }

      for (final move in availableMoves) {
        if (_checkMoveLeadsToDrawUseCase.execute(gameState, move)) {
          return move;
        }
      }
    }

    return EasyAIStrategy(random: _random).selectMove(gameState, availableMoves);
  }
}

