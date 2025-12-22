import 'package:injectable/injectable.dart';
import 'package:tictac/features/score/data/datasources/score_datasource.dart';
import 'package:tictac/features/score/domain/entities/player_score.dart';
import 'package:tictac/features/score/domain/repositories/score_repository.dart';

@Injectable(as: ScoreRepository)
class ScoreRepositoryImpl implements ScoreRepository {

  ScoreRepositoryImpl({
    required this.dataSource,
  });
  final ScoreDataSource dataSource;

  @override
  Future<PlayerScore?> getPlayerScore(String playerName) async {
    return await dataSource.getPlayerScore(playerName);
  }

  @override
  Future<void> updatePlayerScore(PlayerScore score) async {
    await dataSource.savePlayerScore(score);
  }

  @override
  Future<List<PlayerScore>> getAllScores() async {
    return await dataSource.getAllScores();
  }

  @override
  Future<void> resetScores() async {
    await dataSource.resetScores();
  }
}



















