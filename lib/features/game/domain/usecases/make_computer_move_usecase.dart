import 'package:tictac/core/constants/game_constants.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/usecases/check_winner_usecase.dart';
import 'package:tictac/features/game/domain/usecases/select_ai_move_usecase.dart';

class MakeComputerMoveUseCase {
  MakeComputerMoveUseCase({
    SelectAIMoveUseCase? selectAIMoveUseCase,
    CheckWinnerUseCase? checkWinnerUseCase,
  })  : _selectAIMoveUseCase = selectAIMoveUseCase ?? SelectAIMoveUseCase(),
        _checkWinnerUseCase = checkWinnerUseCase ?? CheckWinnerUseCase();

  final SelectAIMoveUseCase _selectAIMoveUseCase;
  final CheckWinnerUseCase _checkWinnerUseCase;

  Future<GameState> execute(GameState gameState, int difficulty) async {
    if (gameState.isGameOver) {
      return gameState;
    }

    final delay = switch (difficulty) {
      GameConstants.aiEasyDifficulty => GameConstants.aiEasyMoveDelay,
      GameConstants.aiMediumDifficulty => GameConstants.aiMediumMoveDelay,
      GameConstants.aiHardDifficulty => GameConstants.aiHardMoveDelay,
      _ => GameConstants.aiEasyMoveDelay,
    };
    await Future<void>.delayed(delay);

    final updatedState = _selectAIMoveUseCase.execute(gameState, difficulty);
    final finalState = _checkWinnerUseCase.execute(updatedState);

    return finalState;
  }
}
