import 'package:tictac/features/score/domain/entities/player_score.dart';
import 'package:tictac/features/score/domain/repositories/score_repository.dart';

class UpdatePlayerScoreUseCase {

  UpdatePlayerScoreUseCase(this.repository);
  final ScoreRepository repository;

  Future<void> execute(PlayerScore score) async {
    await repository.updatePlayerScore(score);
  }
}



















