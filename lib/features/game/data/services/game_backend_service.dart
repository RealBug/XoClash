import 'package:tictac/features/game/domain/entities/game_state.dart';

/// Abstract interface for game backend operations
///
/// This allows easy replacement of the backend implementation
/// (Firebase, Supabase, custom API, etc.) without affecting the datasource.
abstract class GameBackendService {
  /// Join a game by ID and return its current state
  Future<GameState> joinGame(String gameId);

  /// Make a move in the game and return the updated state
  Future<GameState> makeMove(
    String gameId,
    int row,
    int col,
    Player player,
  );

  /// Get the current state of a game
  Future<GameState> getGameState(String gameId);

  /// Watch a game for real-time updates
  Stream<GameState> watchGame(String gameId);

  /// Leave a game and cleanup resources
  Future<void> leaveGame(String gameId);
}
