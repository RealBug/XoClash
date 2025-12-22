import 'package:tictac/features/history/domain/entities/game_history.dart';
import 'package:tictac/features/history/domain/repositories/history_repository.dart';

class GetGameHistoryUseCase {

  GetGameHistoryUseCase(this.repository);
  final HistoryRepository repository;

  Future<List<GameHistory>> execute({int? limit}) async {
    return await repository.getGameHistory(limit: limit);
  }
}



















