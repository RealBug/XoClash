import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictac/core/providers/service_providers.dart';
import 'package:tictac/core/services/logger_service.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/entities/game_state_extensions.dart';
import 'package:tictac/features/game/domain/usecases/check_winner_usecase.dart';
import 'package:tictac/features/game/domain/usecases/create_game_usecase.dart';
import 'package:tictac/features/game/domain/usecases/create_offline_game_usecase.dart';
import 'package:tictac/features/game/domain/usecases/get_game_result_info_usecase.dart';
import 'package:tictac/features/game/domain/usecases/get_player_name_usecase.dart';
import 'package:tictac/features/game/domain/usecases/get_win_message_usecase.dart';
import 'package:tictac/features/game/domain/usecases/handle_game_completion_usecase.dart';
import 'package:tictac/features/game/domain/usecases/join_game_usecase.dart';
import 'package:tictac/features/game/domain/usecases/make_computer_move_usecase.dart';
import 'package:tictac/features/game/domain/usecases/make_move_usecase.dart';
import 'package:tictac/features/game/domain/usecases/validate_game_id_usecase.dart';
import 'package:tictac/features/game/presentation/entities/join_game_ui_state.dart';
import 'package:tictac/features/history/domain/usecases/create_game_history_usecase.dart';
import 'package:tictac/features/history/presentation/providers/history_providers.dart';
import 'package:tictac/features/score/domain/usecases/calculate_score_update_usecase.dart';
import 'package:tictac/features/score/presentation/providers/score_providers.dart';
import 'package:tictac/features/score/presentation/providers/session_scores_provider.dart';
import 'package:tictac/features/user/presentation/providers/user_providers.dart';

final Provider<CreateGameUseCase> createGameUseCaseProvider = Provider<CreateGameUseCase>(
  (Ref ref) => CreateGameUseCase(ref.watch(gameRepositoryProvider)),
);

final Provider<JoinGameUseCase> joinGameUseCaseProvider = Provider<JoinGameUseCase>(
  (Ref ref) => JoinGameUseCase(ref.watch(gameRepositoryProvider)),
);

final Provider<MakeMoveUseCase> makeMoveUseCaseProvider = Provider<MakeMoveUseCase>(
  (Ref ref) => MakeMoveUseCase(ref.watch(gameRepositoryProvider)),
);

final Provider<CheckWinnerUseCase> checkWinnerUseCaseProvider = Provider<CheckWinnerUseCase>((Ref ref) => CheckWinnerUseCase());

final Provider<GetGameResultInfoUseCase> getGameResultInfoUseCaseProvider = Provider<GetGameResultInfoUseCase>(
  (Ref ref) => GetGameResultInfoUseCase(),
);

final Provider<CreateGameHistoryUseCase> createGameHistoryUseCaseProvider = Provider<CreateGameHistoryUseCase>(
  (Ref ref) => CreateGameHistoryUseCase(),
);

final Provider<GetPlayerNameUseCase> getPlayerNameUseCaseProvider = Provider<GetPlayerNameUseCase>((Ref ref) => GetPlayerNameUseCase());

final Provider<GetWinMessageUseCase> getWinMessageUseCaseProvider = Provider<GetWinMessageUseCase>((Ref ref) => GetWinMessageUseCase());

final Provider<HandleGameCompletionUseCase> handleGameCompletionUseCaseProvider = Provider<HandleGameCompletionUseCase>(
  (Ref ref) => HandleGameCompletionUseCase(
    createGameHistoryUseCase: ref.watch(createGameHistoryUseCaseProvider),
    getPlayerNameUseCase: ref.watch(getPlayerNameUseCaseProvider),
  ),
);

final Provider<CalculateScoreUpdateUseCase> calculateScoreUpdateUseCaseProvider = Provider<CalculateScoreUpdateUseCase>(
  (Ref ref) => CalculateScoreUpdateUseCase(),
);

final Provider<CreateOfflineGameUseCase> createOfflineGameUseCaseProvider = Provider<CreateOfflineGameUseCase>(
  (Ref ref) => CreateOfflineGameUseCase(),
);

final Provider<MakeComputerMoveUseCase> makeComputerMoveUseCaseProvider = Provider<MakeComputerMoveUseCase>(
  (Ref ref) => MakeComputerMoveUseCase(),
);

final Provider<ValidateGameIdUseCase> validateGameIdUseCaseProvider = Provider<ValidateGameIdUseCase>((Ref ref) => ValidateGameIdUseCase());

final NotifierProvider<GameStateNotifier, GameState> gameStateProvider = NotifierProvider<GameStateNotifier, GameState>(
  GameStateNotifier.new,
);

class GameStateNotifier extends Notifier<GameState> {
  @override
  GameState build() {
    return GameState(board: 3.createEmptyBoard(), status: GameStatus.playing);
  }

  CreateGameUseCase get createGameUseCase => ref.read(createGameUseCaseProvider);
  CreateOfflineGameUseCase get createOfflineGameUseCase => ref.read(createOfflineGameUseCaseProvider);
  JoinGameUseCase get joinGameUseCase => ref.read(joinGameUseCaseProvider);
  MakeMoveUseCase get makeMoveUseCase => ref.read(makeMoveUseCaseProvider);
  CheckWinnerUseCase get checkWinnerUseCase => ref.read(checkWinnerUseCaseProvider);
  GetGameResultInfoUseCase get getGameResultInfoUseCase => ref.read(getGameResultInfoUseCaseProvider);
  HandleGameCompletionUseCase get handleGameCompletionUseCase => ref.read(handleGameCompletionUseCaseProvider);
  LoggerService get _logger => ref.read(loggerServiceProvider);

  Future<void> createGame({int boardSize = 3}) async {
    _logger.info('Creating online game with board size: $boardSize');
    try {
      final gameState = await createGameUseCase.execute();
      state = GameState(
        board: boardSize.createEmptyBoard(),
        status: GameStatus.playing,
        gameId: gameState.gameId,
        playerId: gameState.playerId,
        isOnline: gameState.isOnline,
        gameMode: GameModeType.online,
      );
      _logger.debug('Online game created: ${gameState.gameId}');
    } catch (e, stackTrace) {
      _logger.error('Failed to create online game', e, stackTrace);
      state = GameState(board: boardSize.createEmptyBoard(), status: GameStatus.playing, gameMode: GameModeType.online);
    }
  }

  Future<void> createOfflineGame({
    required int boardSize,
    required GameModeType mode,
    int? difficulty,
    String? playerXName,
    String? playerOName,
  }) async {
    _logger.info('Creating offline game: mode=$mode, boardSize=$boardSize, difficulty=$difficulty');
    final gameState = createOfflineGameUseCase.execute(
      boardSize: boardSize,
      mode: mode,
      difficulty: difficulty,
      playerXName: playerXName,
      playerOName: playerOName,
    );
    state = gameState;
    _logger.debug('Offline game created: ${gameState.gameId}');
  }

  Future<void> joinGame(String gameId) async {
    _logger.info('Attempting to join game: $gameId');
    try {
      final gameState = await joinGameUseCase.execute(gameId);
      state = gameState;
      _logger.debug('Successfully joined game: $gameId');
    } catch (e, stackTrace) {
      _logger.error('Join game error details', e, stackTrace);
      state = state.copyWith(status: GameStatus.waiting);
      rethrow;
    }
  }

  Future<void> makeMove(int row, int col) async {
    if (state.gameMode == GameModeType.offlineComputer && state.currentPlayer == Player.o) {
      _logger.debug('Skipping move: computer turn');
      return;
    }
    if (state.isGameOver) {
      _logger.debug('Skipping move: game is over');
      return;
    }
    if (state.board[row][col] != Player.none) {
      _logger.debug('Invalid move attempt: cell already occupied at row=$row, col=$col');
      final audioService = ref.read(audioServiceProvider);
      await audioService.playErrorSound();
      return;
    }

    _logger.info('Player move: gameId=${state.gameId}, player=${state.currentPlayer}, row=$row, col=$col');
    final audioService = ref.read(audioServiceProvider);
    await audioService.playMoveSound();

    final updatedState = await makeMoveUseCase.execute(state, row, col);
    final finalState = checkWinnerUseCase.execute(updatedState);
    state = finalState;

    if (finalState.isGameOver) {
      _logger.info('Game over: status=${finalState.status}, gameId=${finalState.gameId}');
      await _handleGameOver(finalState);
      return;
    }

    if (finalState.gameMode == GameModeType.offlineComputer &&
        finalState.currentPlayer == Player.o &&
        finalState.computerDifficulty != null) {
      state = finalState.copyWith(isComputerThinking: true);
      await _makeComputerMove();
    }
  }

  Future<void> _makeComputerMove() async {
    if (state.isGameOver) {
      state = state.copyWith(isComputerThinking: false);
      return;
    }

    _logger.debug('Computer making move: difficulty=${state.computerDifficulty}');
    final makeComputerMoveUseCase = ref.read(makeComputerMoveUseCaseProvider);
    final finalState = await makeComputerMoveUseCase.execute(state, state.computerDifficulty!);
    state = finalState.copyWith(isComputerThinking: false);

    final audioService = ref.read(audioServiceProvider);
    if (finalState.isGameOver) {
      _logger.info('Game over after computer move: status=${finalState.status}');
      await _handleGameOver(finalState);
    } else {
      await audioService.playMoveSound();
    }
  }

  void resetGame() {
    _logger.info('Resetting game: ${state.gameId}');
    final currentSize = state.board.length;
    state = GameState(
      board: currentSize.createEmptyBoard(),
      status: GameStatus.playing,
      gameId: state.gameId,
      playerId: state.playerId,
      isOnline: state.isOnline,
      gameMode: state.gameMode,
      computerDifficulty: state.computerDifficulty,
      playerXName: state.playerXName,
      playerOName: state.playerOName,
    );
  }

  void resetGameCompletely() {
    _logger.info('Resetting game completely');
    state = GameState(board: 3.createEmptyBoard(), status: GameStatus.playing);
  }

  Future<void> _handleGameOver(GameState finalState) async {
    _logger.info('Handling game over: status=${finalState.status}, gameId=${finalState.gameId}');
    final audioService = ref.read(audioServiceProvider);
    final scoresNotifier = ref.read(scoresProvider.notifier);
    final sessionScoresNotifier = ref.read(sessionScoresProvider.notifier);
    final historyNotifier = ref.read(gameHistoryProvider.notifier);
    final user = ref.read(userProvider).value;

    final resultInfo = getGameResultInfoUseCase.execute(finalState, user?.username);

    if (finalState.status == GameStatus.draw) {
      await audioService.playDrawSound();
    } else {
      if (resultInfo.isCurrentPlayerWin) {
        await audioService.playWinSound();
      } else {
        await audioService.playLoseSound();
      }
    }

    final completionData = handleGameCompletionUseCase.execute(finalState, finalState.computerDifficulty);

    if (completionData.playerXName != null) {
      await scoresNotifier.updateScore(completionData.playerXName!, completionData.isXWin, completionData.isDraw);
      sessionScoresNotifier.updateScore(completionData.playerXName!, completionData.isXWin, completionData.isDraw);
    }

    if (completionData.playerOName != null) {
      await scoresNotifier.updateScore(completionData.playerOName!, completionData.isOWin, completionData.isDraw);
      sessionScoresNotifier.updateScore(completionData.playerOName!, completionData.isOWin, completionData.isDraw);
    }

    await historyNotifier.addGameHistory(completionData.history);
    _logger.debug('Game history saved: ${completionData.history.id}');
  }
}

final NotifierProvider<JoinGameUINotifier, JoinGameUIState> joinGameUIStateProvider = NotifierProvider<JoinGameUINotifier, JoinGameUIState>(
  JoinGameUINotifier.new,
);

class JoinGameUINotifier extends Notifier<JoinGameUIState> {
  @override
  JoinGameUIState build() {
    return const JoinGameUIState();
  }

  Future<void> joinGame(String gameId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await ref.read(gameStateProvider.notifier).joinGame(gameId);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
