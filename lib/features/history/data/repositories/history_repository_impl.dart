import 'package:injectable/injectable.dart';
import 'package:tictac/features/history/data/datasources/history_datasource.dart';
import 'package:tictac/features/history/domain/entities/game_history.dart';
import 'package:tictac/features/history/domain/repositories/history_repository.dart';

@Injectable(as: HistoryRepository)
class HistoryRepositoryImpl implements HistoryRepository {

  HistoryRepositoryImpl({
    required this.dataSource,
  });
  final HistoryDataSource dataSource;

  @override
  Future<void> saveGameHistory(GameHistory history) async {
    await dataSource.saveGameHistory(history);
  }

  @override
  Future<List<GameHistory>> getGameHistory({int? limit}) async {
    return await dataSource.getGameHistory(limit: limit);
  }

  @override
  Future<void> clearHistory() async {
    await dataSource.clearHistory();
  }
}



















