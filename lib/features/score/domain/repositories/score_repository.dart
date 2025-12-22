import 'package:tictac/features/score/domain/entities/player_score.dart';

abstract class ScoreRepository {
  Future<PlayerScore?> getPlayerScore(String playerName);
  Future<void> updatePlayerScore(PlayerScore score);
  Future<List<PlayerScore>> getAllScores();
  Future<void> resetScores();
}



















