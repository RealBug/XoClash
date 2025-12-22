import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictac/core/di/injection.dart';
import 'package:tictac/features/score/data/datasources/score_datasource.dart';
import 'package:tictac/features/score/domain/entities/player_score.dart';
import 'package:tictac/features/score/domain/repositories/score_repository.dart';
import 'package:tictac/features/score/domain/usecases/calculate_score_update_usecase.dart';
import 'package:tictac/features/score/domain/usecases/get_all_scores_usecase.dart';
import 'package:tictac/features/score/domain/usecases/get_player_score_usecase.dart';
import 'package:tictac/features/score/domain/usecases/reset_scores_usecase.dart';
import 'package:tictac/features/score/domain/usecases/update_player_score_usecase.dart';
import 'package:tictac/features/score/domain/usecases/update_score_usecase.dart';

final Provider<ScoreDataSource> scoreDataSourceProvider = Provider<ScoreDataSource>(
  (Ref ref) => getIt<ScoreDataSource>(),
);

final Provider<ScoreRepository> scoreRepositoryProvider = Provider<ScoreRepository>(
  (Ref ref) => getIt<ScoreRepository>(),
);

final Provider<GetPlayerScoreUseCase> getPlayerScoreUseCaseProvider = Provider<GetPlayerScoreUseCase>(
  (Ref ref) => GetPlayerScoreUseCase(ref.watch(scoreRepositoryProvider)),
);

final Provider<UpdatePlayerScoreUseCase> updatePlayerScoreUseCaseProvider = Provider<UpdatePlayerScoreUseCase>(
  (Ref ref) => UpdatePlayerScoreUseCase(ref.watch(scoreRepositoryProvider)),
);

final Provider<GetAllScoresUseCase> getAllScoresUseCaseProvider = Provider<GetAllScoresUseCase>(
  (Ref ref) => GetAllScoresUseCase(ref.watch(scoreRepositoryProvider)),
);

final Provider<CalculateScoreUpdateUseCase> calculateScoreUpdateUseCaseProvider = Provider<CalculateScoreUpdateUseCase>(
  (Ref ref) => CalculateScoreUpdateUseCase(),
);

final Provider<ResetScoresUseCase> resetScoresUseCaseProvider = Provider<ResetScoresUseCase>(
  (Ref ref) => ResetScoresUseCase(ref.watch(scoreRepositoryProvider)),
);

final Provider<UpdateScoreUseCase> updateScoreUseCaseProvider = Provider<UpdateScoreUseCase>(
  (Ref ref) => UpdateScoreUseCase(
    ref.watch(getPlayerScoreUseCaseProvider),
    ref.watch(calculateScoreUpdateUseCaseProvider),
    ref.watch(updatePlayerScoreUseCaseProvider),
  ),
);

final AsyncNotifierProvider<ScoresNotifier, List<PlayerScore>> scoresProvider = AsyncNotifierProvider<ScoresNotifier, List<PlayerScore>>(
  ScoresNotifier.new,
);

class ScoresNotifier extends AsyncNotifier<List<PlayerScore>> {
  @override
  Future<List<PlayerScore>> build() async {
    return await _loadScores();
  }

  GetAllScoresUseCase get getAllScoresUseCase => ref.read(getAllScoresUseCaseProvider);
  GetPlayerScoreUseCase get getPlayerScoreUseCase => ref.read(getPlayerScoreUseCaseProvider);
  UpdatePlayerScoreUseCase get updatePlayerScoreUseCase => ref.read(updatePlayerScoreUseCaseProvider);
  CalculateScoreUpdateUseCase get calculateScoreUpdateUseCase => ref.read(calculateScoreUpdateUseCaseProvider);
  ResetScoresUseCase get resetScoresUseCase => ref.read(resetScoresUseCaseProvider);
  UpdateScoreUseCase get updateScoreUseCase => ref.read(updateScoreUseCaseProvider);

  Future<List<PlayerScore>> _loadScores() async {
    return await getAllScoresUseCase.execute();
  }

  Future<void> updateScore(String playerName, bool isWin, bool isDraw) async {
    try {
      await updateScoreUseCase.execute(playerName, isWin, isDraw);
      final List<PlayerScore> scores = await _loadScores();
      state = AsyncData<List<PlayerScore>>(scores);
    } catch (e, stackTrace) {
      state = AsyncError<List<PlayerScore>>(e, stackTrace);
      rethrow;
    }
  }

  Future<PlayerScore?> getPlayerScore(String playerName) async {
    return await getPlayerScoreUseCase.execute(playerName);
  }

  Future<void> refreshScores() async {
    try {
      final List<PlayerScore> scores = await _loadScores();
      state = AsyncData<List<PlayerScore>>(scores);
    } catch (e, stackTrace) {
      state = AsyncError<List<PlayerScore>>(e, stackTrace);
      rethrow;
    }
  }

  Future<void> resetScores() async {
    try {
      await resetScoresUseCase.execute();
      state = const AsyncData<List<PlayerScore>>(<PlayerScore>[]);
    } catch (e, stackTrace) {
      state = AsyncError<List<PlayerScore>>(e, stackTrace);
      rethrow;
    }
  }
}
