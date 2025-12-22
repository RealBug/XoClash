import 'package:tictac/features/game/domain/entities/game_state.dart';

extension BoardSizeExtension on int {
  /// Creates an empty board of this size
  List<List<Player>> createEmptyBoard() {
    return List<List<Player>>.generate(
      this,
      (int _) => List<Player>.generate(this, (int _) => Player.none),
    );
  }

  /// Gets the win condition for this board size
  int getWinCondition() {
    switch (this) {
      case 3:
        return 3;
      case 4:
        return 4;
      case 5:
        return 4;
      default:
        return 3;
    }
  }
}

extension BoardExtension on List<List<Player>> {
  /// Checks if the board is completely empty
  bool get isBoardEmpty {
    return every((List<Player> row) => row.every((Player cell) => cell == Player.none));
  }

  /// Creates a deep copy of the board
  List<List<Player>> deepCopy() {
    return map((List<Player> row) => row.toList()).toList();
  }
}
