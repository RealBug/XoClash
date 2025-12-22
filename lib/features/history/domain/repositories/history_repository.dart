import 'package:tictac/features/history/domain/entities/game_history.dart';

abstract class HistoryRepository {
  Future<void> saveGameHistory(GameHistory history);
  Future<List<GameHistory>> getGameHistory({int? limit});
  Future<void> clearHistory();
}



















