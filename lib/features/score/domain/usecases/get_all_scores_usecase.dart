import 'package:tictac/features/score/domain/entities/player_score.dart';
import 'package:tictac/features/score/domain/repositories/score_repository.dart';

class GetAllScoresUseCase {

  GetAllScoresUseCase(this.repository);
  final ScoreRepository repository;

  Future<List<PlayerScore>> execute() async {
    return await repository.getAllScores();
  }
}



















