import 'package:tictac/features/score/domain/repositories/score_repository.dart';

class ResetScoresUseCase {

  ResetScoresUseCase(this._repository);
  final ScoreRepository _repository;

  Future<void> execute() async {
    await _repository.resetScores();
  }
}

