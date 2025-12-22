import 'package:tictac/features/score/domain/entities/player_score.dart';
import 'package:tictac/features/score/domain/repositories/score_repository.dart';

class GetPlayerScoreUseCase {

  GetPlayerScoreUseCase(this.repository);
  final ScoreRepository repository;

  Future<PlayerScore?> execute(String playerName) async {
    return await repository.getPlayerScore(playerName);
  }
}



















