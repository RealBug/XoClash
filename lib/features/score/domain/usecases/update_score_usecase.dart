import 'package:tictac/features/score/domain/entities/player_score.dart';
import 'package:tictac/features/score/domain/usecases/calculate_score_update_usecase.dart';
import 'package:tictac/features/score/domain/usecases/get_player_score_usecase.dart';
import 'package:tictac/features/score/domain/usecases/update_player_score_usecase.dart';

class UpdateScoreUseCase {

  UpdateScoreUseCase(
    this._getPlayerScoreUseCase,
    this._calculateScoreUpdateUseCase,
    this._updatePlayerScoreUseCase,
  );
  final GetPlayerScoreUseCase _getPlayerScoreUseCase;
  final CalculateScoreUpdateUseCase _calculateScoreUpdateUseCase;
  final UpdatePlayerScoreUseCase _updatePlayerScoreUseCase;

  Future<void> execute(String playerName, bool isWin, bool isDraw) async {
    final PlayerScore? currentScore = await _getPlayerScoreUseCase.execute(playerName);
    final PlayerScore updatedScore = _calculateScoreUpdateUseCase.execute(
      currentScore,
      playerName,
      isWin,
      isDraw,
    );
    await _updatePlayerScoreUseCase.execute(updatedScore);
  }
}

