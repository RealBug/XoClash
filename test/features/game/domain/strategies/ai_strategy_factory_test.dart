import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/core/constants/game_constants.dart';
import 'package:tictac/features/game/domain/strategies/ai_strategy_factory.dart';
import 'package:tictac/features/game/domain/strategies/easy_ai_strategy.dart';
import 'package:tictac/features/game/domain/strategies/hard_ai_strategy.dart';
import 'package:tictac/features/game/domain/strategies/medium_ai_strategy.dart';
import 'package:tictac/features/game/domain/usecases/check_can_force_draw_usecase.dart';
import 'package:tictac/features/game/domain/usecases/check_has_winning_move_usecase.dart';
import 'package:tictac/features/game/domain/usecases/check_move_leads_to_draw_usecase.dart';
import 'package:tictac/features/game/domain/usecases/check_winner_usecase.dart';
import 'package:tictac/features/game/domain/usecases/count_remaining_moves_usecase.dart';
import 'package:tictac/features/game/domain/usecases/get_available_moves_usecase.dart';

void main() {
  group('AIStrategyFactory', () {
    late CheckHasWinningMoveUseCase checkHasWinningMoveUseCase;
    late CheckMoveLeadsToDrawUseCase checkMoveLeadsToDrawUseCase;

    setUp(() {
      final checkWinnerUseCase = CheckWinnerUseCase();
      checkHasWinningMoveUseCase = CheckHasWinningMoveUseCase(checkWinnerUseCase);
      checkMoveLeadsToDrawUseCase = CheckMoveLeadsToDrawUseCase(
        checkWinnerUseCase: checkWinnerUseCase,
        countRemainingMovesUseCase: CountRemainingMovesUseCase(),
        checkCanForceDrawUseCase: CheckCanForceDrawUseCase(
          checkWinnerUseCase: checkWinnerUseCase,
          countRemainingMovesUseCase: CountRemainingMovesUseCase(),
          getAvailableMovesUseCase: GetAvailableMovesUseCase(),
          checkHasWinningMoveUseCase: checkHasWinningMoveUseCase,
        ),
        checkHasWinningMoveUseCase: checkHasWinningMoveUseCase,
      );
    });

    test('should create EasyAIStrategy for easy difficulty', () {
      final strategy = AIStrategyFactory.create(GameConstants.aiEasyDifficulty);
      expect(strategy, isA<EasyAIStrategy>());
    });

    test('should create MediumAIStrategy for medium difficulty', () {
      final strategy = AIStrategyFactory.create(
        GameConstants.aiMediumDifficulty,
        checkHasWinningMoveUseCase: checkHasWinningMoveUseCase,
        checkMoveLeadsToDrawUseCase: checkMoveLeadsToDrawUseCase,
      );
      expect(strategy, isA<MediumAIStrategy>());
    });

    test('should create HardAIStrategy for hard difficulty', () {
      final strategy = AIStrategyFactory.create(
        GameConstants.aiHardDifficulty,
        checkHasWinningMoveUseCase: checkHasWinningMoveUseCase,
        checkMoveLeadsToDrawUseCase: checkMoveLeadsToDrawUseCase,
      );
      expect(strategy, isA<HardAIStrategy>());
    });

    test('should create EasyAIStrategy for unknown difficulty', () {
      final strategy = AIStrategyFactory.create(999);
      expect(strategy, isA<EasyAIStrategy>());
    });

    test('should accept optional random parameter', () {
      final strategy = AIStrategyFactory.create(
        GameConstants.aiEasyDifficulty,
      );
      expect(strategy, isA<EasyAIStrategy>());
    });
  });
}
