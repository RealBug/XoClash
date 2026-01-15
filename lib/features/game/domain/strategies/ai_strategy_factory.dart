import 'dart:math' as math;

import 'package:tictac/core/constants/game_constants.dart';
import 'package:tictac/features/game/domain/strategies/ai_strategy.dart';
import 'package:tictac/features/game/domain/strategies/easy_ai_strategy.dart';
import 'package:tictac/features/game/domain/strategies/hard_ai_strategy.dart';
import 'package:tictac/features/game/domain/strategies/medium_ai_strategy.dart';
import 'package:tictac/features/game/domain/usecases/check_has_winning_move_usecase.dart';
import 'package:tictac/features/game/domain/usecases/check_move_leads_to_draw_usecase.dart';

class AIStrategyFactory {
  AIStrategyFactory._();

  static AIStrategy create(
    int difficulty, {
    CheckHasWinningMoveUseCase? checkHasWinningMoveUseCase,
    CheckMoveLeadsToDrawUseCase? checkMoveLeadsToDrawUseCase,
    math.Random? random,
  }) {
    return switch (difficulty) {
      GameConstants.aiEasyDifficulty => EasyAIStrategy(random: random),
      GameConstants.aiMediumDifficulty => MediumAIStrategy(
          checkHasWinningMoveUseCase: checkHasWinningMoveUseCase!,
          checkMoveLeadsToDrawUseCase: checkMoveLeadsToDrawUseCase!,
          random: random,
        ),
      GameConstants.aiHardDifficulty => HardAIStrategy(
          checkHasWinningMoveUseCase: checkHasWinningMoveUseCase!,
          checkMoveLeadsToDrawUseCase: checkMoveLeadsToDrawUseCase!,
          random: random,
        ),
      _ => EasyAIStrategy(random: random),
    };
  }
}
