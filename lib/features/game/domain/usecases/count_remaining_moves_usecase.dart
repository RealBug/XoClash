import 'package:tictac/features/game/domain/entities/game_state.dart';

class CountRemainingMovesUseCase {
  int execute(List<List<Player>> board) {
    int count = 0;
    for (final row in board) {
      for (final cell in row) {
        if (cell == Player.none) {
          count++;
        }
      }
    }
    return count;
  }
}

