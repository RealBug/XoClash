import 'dart:math' as math;

import 'package:tictac/core/constants/game_constants.dart';
import 'package:tictac/features/game/domain/strategies/ai_strategy.dart';
import 'package:tictac/features/game/domain/strategies/easy_ai_strategy.dart';
import 'package:tictac/features/game/domain/strategies/hard_ai_strategy.dart';
import 'package:tictac/features/game/domain/strategies/medium_ai_strategy.dart';

class AIStrategyFactory {
  AIStrategyFactory._();

  static AIStrategy create(int difficulty, {math.Random? random}) {
    return switch (difficulty) {
      GameConstants.aiEasyDifficulty => EasyAIStrategy(random: random),
      GameConstants.aiMediumDifficulty => MediumAIStrategy(random: random),
      GameConstants.aiHardDifficulty => HardAIStrategy(),
      _ => EasyAIStrategy(random: random),
    };
  }
}

