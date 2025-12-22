import 'package:tictac/features/game/domain/entities/game_state.dart';

abstract class AIStrategy {
  List<int> selectMove(GameState gameState, List<List<int>> availableMoves);
}

