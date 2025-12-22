import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/repositories/game_repository.dart';

class JoinGameUseCase {

  JoinGameUseCase(this.repository);
  final GameRepository repository;

  Future<GameState> execute(String gameId) async {
    return await repository.joinGame(gameId);
  }
}


















