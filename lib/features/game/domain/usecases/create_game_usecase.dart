import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/repositories/game_repository.dart';

class CreateGameUseCase {

  CreateGameUseCase(this.repository);
  final GameRepository repository;

  Future<GameState> execute() async {
    return await repository.createGame();
  }
}


















