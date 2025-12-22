import 'package:tictac/features/game/domain/entities/game_state.dart';

abstract class GameRepository {
  Future<GameState> createGame();
  Future<GameState> joinGame(String gameId);
  Future<GameState> makeMove(GameState gameState, int row, int col);
  Future<GameState> getGameState(String gameId);
  Stream<GameState> watchGame(String gameId);
  Future<void> leaveGame(String gameId);
}



















