import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictac/core/di/injection.dart';
import 'package:tictac/features/history/data/datasources/history_datasource.dart';
import 'package:tictac/features/history/domain/entities/game_history.dart';
import 'package:tictac/features/history/domain/repositories/history_repository.dart';
import 'package:tictac/features/history/domain/usecases/clear_history_usecase.dart';
import 'package:tictac/features/history/domain/usecases/get_game_history_usecase.dart';
import 'package:tictac/features/history/domain/usecases/save_game_history_usecase.dart';

final Provider<HistoryDataSource> historyDataSourceProvider = Provider<HistoryDataSource>(
  (Ref ref) => getIt<HistoryDataSource>(),
);

final Provider<HistoryRepository> historyRepositoryProvider = Provider<HistoryRepository>(
  (Ref ref) => getIt<HistoryRepository>(),
);

final Provider<SaveGameHistoryUseCase> saveGameHistoryUseCaseProvider = Provider<SaveGameHistoryUseCase>(
  (Ref ref) => SaveGameHistoryUseCase(ref.watch(historyRepositoryProvider)),
);

final Provider<GetGameHistoryUseCase> getGameHistoryUseCaseProvider = Provider<GetGameHistoryUseCase>(
  (Ref ref) => GetGameHistoryUseCase(ref.watch(historyRepositoryProvider)),
);

final Provider<ClearHistoryUseCase> clearHistoryUseCaseProvider = Provider<ClearHistoryUseCase>(
  (Ref ref) => ClearHistoryUseCase(ref.watch(historyRepositoryProvider)),
);

final AsyncNotifierProvider<GameHistoryNotifier, List<GameHistory>> gameHistoryProvider = AsyncNotifierProvider<GameHistoryNotifier, List<GameHistory>>(
  GameHistoryNotifier.new,
);

class GameHistoryNotifier extends AsyncNotifier<List<GameHistory>> {
  @override
  Future<List<GameHistory>> build() async {
    return await _loadHistory();
  }

  GetGameHistoryUseCase get getGameHistoryUseCase => ref.read(getGameHistoryUseCaseProvider);
  SaveGameHistoryUseCase get saveGameHistoryUseCase => ref.read(saveGameHistoryUseCaseProvider);
  ClearHistoryUseCase get clearHistoryUseCase => ref.read(clearHistoryUseCaseProvider);

  Future<List<GameHistory>> _loadHistory({int? limit}) async {
    return await getGameHistoryUseCase.execute(limit: limit);
  }

  Future<void> addGameHistory(GameHistory history) async {
    try {
      await saveGameHistoryUseCase.execute(history);
      final List<GameHistory> updatedHistory = await _loadHistory();
      state = AsyncData<List<GameHistory>>(updatedHistory);
    } catch (e, stackTrace) {
      state = AsyncError<List<GameHistory>>(e, stackTrace);
      rethrow;
    }
  }

  Future<void> refreshHistory({int? limit}) async {
    try {
      final List<GameHistory> history = await _loadHistory(limit: limit);
      state = AsyncData<List<GameHistory>>(history);
    } catch (e, stackTrace) {
      state = AsyncError<List<GameHistory>>(e, stackTrace);
      rethrow;
    }
  }

  Future<void> clearHistory() async {
    try {
      await clearHistoryUseCase.execute();
      state = const AsyncData<List<GameHistory>>(<GameHistory>[]);
    } catch (e, stackTrace) {
      state = AsyncError<List<GameHistory>>(e, stackTrace);
      rethrow;
    }
  }
}

