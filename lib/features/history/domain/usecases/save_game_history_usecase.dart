import 'package:tictac/features/history/domain/entities/game_history.dart';
import 'package:tictac/features/history/domain/repositories/history_repository.dart';

class SaveGameHistoryUseCase {

  SaveGameHistoryUseCase(this.repository);
  final HistoryRepository repository;

  Future<void> execute(GameHistory history) async {
    await repository.saveGameHistory(history);
  }
}



















