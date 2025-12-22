import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/repositories/game_repository.dart';

class MakeMoveUseCase {

  MakeMoveUseCase(this.repository);
  final GameRepository repository;

  Future<GameState> execute(GameState gameState, int row, int col) async {
    if (gameState.board[row][col] != Player.none) {
      return gameState;
    }

    if (gameState.isGameOver) {
      return gameState;
    }

    return await repository.makeMove(gameState, row, col);
  }
}
