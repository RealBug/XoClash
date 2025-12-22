import 'dart:math' as math;

import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/strategies/ai_strategy.dart';

class EasyAIStrategy implements AIStrategy {
  EasyAIStrategy({math.Random? random}) : _random = random ?? math.Random();

  final math.Random _random;

  @override
  List<int> selectMove(GameState gameState, List<List<int>> availableMoves) {
    return availableMoves[_random.nextInt(availableMoves.length)];
  }
}

