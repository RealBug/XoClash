import 'package:tictac/features/game/domain/entities/game_state.dart';

class GetAvailableMovesUseCase {
  List<List<int>> execute(List<List<Player>> board) {
    final size = board.length;
    final availableMoves = <List<int>>[];
    for (var i = 0; i < size; i++) {
      for (var j = 0; j < size; j++) {
        if (board[i][j] == Player.none) {
          availableMoves.add(<int>[i, j]);
        }
      }
    }
    return availableMoves;
  }
}

