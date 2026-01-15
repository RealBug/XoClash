import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/core/providers/service_providers.dart';
import 'package:tictac/core/services/audio_service.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/entities/game_state_extensions.dart';
import 'package:tictac/features/game/domain/usecases/check_winner_usecase.dart';
import 'package:tictac/features/game/domain/usecases/create_game_usecase.dart';
import 'package:tictac/features/game/domain/usecases/get_game_result_info_usecase.dart';
import 'package:tictac/features/game/domain/usecases/handle_game_completion_usecase.dart';
import 'package:tictac/features/game/domain/usecases/join_game_usecase.dart';
import 'package:tictac/features/game/domain/usecases/make_computer_move_usecase.dart';
import 'package:tictac/features/game/domain/usecases/make_move_usecase.dart';
import 'package:tictac/features/game/domain/usecases/validate_game_id_usecase.dart';
import 'package:tictac/features/game/presentation/providers/game_providers.dart';
import 'package:tictac/features/history/domain/entities/game_history.dart';
import 'package:tictac/features/history/domain/repositories/history_repository.dart';
import 'package:tictac/features/history/domain/usecases/get_game_history_usecase.dart';
import 'package:tictac/features/history/domain/usecases/save_game_history_usecase.dart';
import 'package:tictac/features/history/presentation/providers/history_providers.dart';
import 'package:tictac/features/score/domain/entities/player_score.dart';
import 'package:tictac/features/score/domain/repositories/score_repository.dart';
import 'package:tictac/features/score/domain/usecases/calculate_score_update_usecase.dart';
import 'package:tictac/features/score/domain/usecases/get_all_scores_usecase.dart';
import 'package:tictac/features/score/domain/usecases/get_player_score_usecase.dart';
import 'package:tictac/features/score/domain/usecases/update_player_score_usecase.dart';
import 'package:tictac/features/score/presentation/providers/score_providers.dart'
    as score_providers;
import 'package:tictac/features/user/domain/usecases/delete_user_usecase.dart';
import 'package:tictac/features/user/domain/usecases/get_user_usecase.dart';
import 'package:tictac/features/user/domain/usecases/has_user_usecase.dart';
import 'package:tictac/features/user/presentation/providers/user_providers.dart';
import 'package:tictac/l10n/app_localizations_en.dart';


class MockCreateGameUseCase extends Mock implements CreateGameUseCase {}

class MockJoinGameUseCase extends Mock implements JoinGameUseCase {}

class MockMakeMoveUseCase extends Mock implements MakeMoveUseCase {}

class MockCheckWinnerUseCase extends Mock implements CheckWinnerUseCase {}

class MockGetGameResultInfoUseCase extends Mock
    implements GetGameResultInfoUseCase {}

class MockHandleGameCompletionUseCase extends Mock
    implements HandleGameCompletionUseCase {}

class MockAudioService extends Mock implements AudioService {}

class MockMakeComputerMoveUseCase extends Mock implements MakeComputerMoveUseCase {}

class MockGetGameHistoryUseCase extends Mock implements GetGameHistoryUseCase {}

class MockSaveGameHistoryUseCase extends Mock
    implements SaveGameHistoryUseCase {}

class MockHistoryRepository extends Mock implements HistoryRepository {}

class MockGetAllScoresUseCase extends Mock implements GetAllScoresUseCase {}

class MockGetPlayerScoreUseCase extends Mock implements GetPlayerScoreUseCase {}

class MockUpdatePlayerScoreUseCase extends Mock
    implements UpdatePlayerScoreUseCase {}

class MockCalculateScoreUpdateUseCase extends Mock
    implements CalculateScoreUpdateUseCase {}

class MockScoreRepository extends Mock implements ScoreRepository {}

class MockGetUserUseCase extends Mock implements GetUserUseCase {}


class MockHasUserUseCase extends Mock implements HasUserUseCase {}

class MockDeleteUserUseCase extends Mock implements DeleteUserUseCase {}

void setUpAllFallbacks() {
  registerFallbackValue(
    GameState(
      board: 3.createEmptyBoard(),
    ),
  );
  registerFallbackValue(
    GameHistory(
      id: 'test-id',
      date: DateTime.now(),
      playerXName: 'PlayerX',
      playerOName: 'PlayerO',
      result: GameStatus.draw,
      gameMode: GameModeType.offlineFriend,
      boardSize: 3,
    ),
  );
  registerFallbackValue(
    const PlayerScore(
      playerName: 'test-player',
    ),
  );
}

void main() {
  setUpAll(() {
    setUpAllFallbacks();
  });

  late MockCreateGameUseCase mockCreateGameUseCase;
  late MockJoinGameUseCase mockJoinGameUseCase;
  late MockMakeMoveUseCase mockMakeMoveUseCase;
  late MockCheckWinnerUseCase mockCheckWinnerUseCase;
  late MockGetGameResultInfoUseCase mockGetGameResultInfoUseCase;
  late MockHandleGameCompletionUseCase mockHandleGameCompletionUseCase;
  late MockAudioService mockAudioService;
  late MockMakeComputerMoveUseCase mockMakeComputerMoveUseCase;
  late ProviderContainer container;

  setUp(() {
    mockCreateGameUseCase = MockCreateGameUseCase();
    mockJoinGameUseCase = MockJoinGameUseCase();
    mockMakeMoveUseCase = MockMakeMoveUseCase();
    mockCheckWinnerUseCase = MockCheckWinnerUseCase();
    mockGetGameResultInfoUseCase = MockGetGameResultInfoUseCase();
    mockHandleGameCompletionUseCase = MockHandleGameCompletionUseCase();
    mockAudioService = MockAudioService();
    mockMakeComputerMoveUseCase = MockMakeComputerMoveUseCase();

    when(() => mockAudioService.playMoveSound())
        .thenAnswer((_) async => Future<void>.value());
    when(() => mockAudioService.playErrorSound())
        .thenAnswer((_) async => Future<void>.value());
    when(() => mockAudioService.playWinSound())
        .thenAnswer((_) async => Future<void>.value());
    when(() => mockAudioService.playLoseSound())
        .thenAnswer((_) async => Future<void>.value());
    when(() => mockAudioService.playDrawSound())
        .thenAnswer((_) async => Future<void>.value());

    final MockGetGameHistoryUseCase mockGetGameHistoryUseCase = MockGetGameHistoryUseCase();
    final MockSaveGameHistoryUseCase mockSaveGameHistoryUseCase = MockSaveGameHistoryUseCase();
    final MockHistoryRepository mockHistoryRepository = MockHistoryRepository();
    final MockGetAllScoresUseCase mockGetAllScoresUseCase = MockGetAllScoresUseCase();
    final MockGetPlayerScoreUseCase mockGetPlayerScoreUseCase = MockGetPlayerScoreUseCase();
    final MockUpdatePlayerScoreUseCase mockUpdatePlayerScoreUseCase = MockUpdatePlayerScoreUseCase();
    final MockCalculateScoreUpdateUseCase mockCalculateScoreUpdateUseCase = MockCalculateScoreUpdateUseCase();
    final MockScoreRepository mockScoreRepository = MockScoreRepository();
    final MockGetUserUseCase mockGetUserUseCase = MockGetUserUseCase();
    final MockHasUserUseCase mockHasUserUseCase = MockHasUserUseCase();
    final MockDeleteUserUseCase mockDeleteUserUseCase = MockDeleteUserUseCase();

    when(() => mockGetGameHistoryUseCase.execute(limit: any(named: 'limit')))
        .thenAnswer((_) async => <GameHistory>[]);
    when(() => mockSaveGameHistoryUseCase.execute(any()))
        .thenAnswer((_) async => Future<void>.value());
    when(() => mockGetAllScoresUseCase.execute()).thenAnswer((_) async => <PlayerScore>[]);
    when(() => mockGetUserUseCase.execute()).thenAnswer((_) async => null);
    when(() => mockUpdatePlayerScoreUseCase.execute(any()))
        .thenAnswer((_) async => Future<void>.value());
    when(() => mockScoreRepository.resetScores())
        .thenAnswer((_) async => Future<void>.value());

    container = ProviderContainer(
      overrides: [
        createGameUseCaseProvider.overrideWithValue(mockCreateGameUseCase),
        joinGameUseCaseProvider.overrideWithValue(mockJoinGameUseCase),
        makeMoveUseCaseProvider.overrideWithValue(mockMakeMoveUseCase),
        checkWinnerUseCaseProvider.overrideWithValue(mockCheckWinnerUseCase),
        getGameResultInfoUseCaseProvider
            .overrideWithValue(mockGetGameResultInfoUseCase),
        handleGameCompletionUseCaseProvider
            .overrideWithValue(mockHandleGameCompletionUseCase),
        audioServiceProvider.overrideWithValue(mockAudioService),
        makeComputerMoveUseCaseProvider.overrideWithValue(mockMakeComputerMoveUseCase),
        getGameHistoryUseCaseProvider
            .overrideWithValue(mockGetGameHistoryUseCase),
        saveGameHistoryUseCaseProvider
            .overrideWithValue(mockSaveGameHistoryUseCase),
        historyRepositoryProvider.overrideWithValue(mockHistoryRepository),
        score_providers.getAllScoresUseCaseProvider
            .overrideWithValue(mockGetAllScoresUseCase),
        score_providers.getPlayerScoreUseCaseProvider
            .overrideWithValue(mockGetPlayerScoreUseCase),
        score_providers.updatePlayerScoreUseCaseProvider
            .overrideWithValue(mockUpdatePlayerScoreUseCase),
        calculateScoreUpdateUseCaseProvider
            .overrideWithValue(mockCalculateScoreUpdateUseCase),
        scoreRepositoryProvider.overrideWithValue(mockScoreRepository),
        getUserUseCaseProvider.overrideWithValue(mockGetUserUseCase),
        hasUserUseCaseProvider.overrideWithValue(mockHasUserUseCase),
        deleteUserUseCaseProvider.overrideWithValue(mockDeleteUserUseCase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('validateGameIdUseCaseProvider', () {
    test('should provide ValidateGameIdUseCase instance', () {
      final useCase = container.read(validateGameIdUseCaseProvider);

      expect(useCase, isA<ValidateGameIdUseCase>());
      expect(useCase, isNotNull);
    });

    test('should provide same instance on multiple reads', () {
      final useCase1 = container.read(validateGameIdUseCaseProvider);
      final useCase2 = container.read(validateGameIdUseCaseProvider);

      expect(useCase1, same(useCase2));
    });

    test('should execute validation correctly', () {
      final useCase = container.read(validateGameIdUseCaseProvider);
      final l10n = AppLocalizationsEn();

      final result = useCase.execute('ABCDEF', l10n);
      expect(result, isNull);
    });
  });

  group('GameStateNotifier', () {
    test('build() returns initial game state', () {
      final GameState state = container.read(gameStateProvider);
      expect(state.board.length, 3);
      expect(state.status, GameStatus.playing);
    });

    group('createGame', () {
      test('creates online game successfully', () async {
        final GameState createdState = GameState(
          board: 3.createEmptyBoard(),
          gameId: 'test-game-id',
          playerId: 'test-player-id',
          isOnline: true,
          gameMode: GameModeType.online,
          status: GameStatus.playing,
        );

        when(() => mockCreateGameUseCase.execute())
            .thenAnswer((_) async => createdState);

        final GameStateNotifier notifier = container.read(gameStateProvider.notifier);
        await notifier.createGame();

        final GameState state = container.read(gameStateProvider);
        expect(state.gameId, 'test-game-id');
        expect(state.playerId, 'test-player-id');
        expect(state.isOnline, true);
        expect(state.gameMode, GameModeType.online);
        expect(state.status, GameStatus.playing);
      });

      test('handles create game failure gracefully', () async {
        when(() => mockCreateGameUseCase.execute())
            .thenThrow(Exception('Failed to create'));

        final GameStateNotifier notifier = container.read(gameStateProvider.notifier);

        try {
          await notifier.createGame();
        } catch (e) {
          // Exception is caught and handled internally
        }

        final GameState state = container.read(gameStateProvider);
        expect(state.gameMode, GameModeType.online);
        expect(state.status, GameStatus.playing);
        expect(state.isOnline, isFalse);
        expect(state.gameId, isNull);
        expect(state.playerId, isNull);
      });

      test('creates game with custom board size', () async {
        final GameState createdState = GameState(
          board: 4.createEmptyBoard(),
          gameId: 'test-game-id',
          playerId: 'test-player-id',
          isOnline: true,
          gameMode: GameModeType.online,
          status: GameStatus.playing,
        );

        when(() => mockCreateGameUseCase.execute())
            .thenAnswer((_) async => createdState);

        final GameStateNotifier notifier = container.read(gameStateProvider.notifier);
        await notifier.createGame(boardSize: 4);

        final GameState state = container.read(gameStateProvider);
        expect(state.board.length, 4);
      });
    });

    group('createOfflineGame', () {
      test('creates offline friend game', () async {
        final GameStateNotifier notifier = container.read(gameStateProvider.notifier);
        await notifier.createOfflineGame(
          boardSize: 3,
          mode: GameModeType.offlineFriend,
          playerXName: 'PlayerX',
          playerOName: 'PlayerO',
        );

        final GameState state = container.read(gameStateProvider);
        expect(state.isOnline, false);
        expect(state.gameMode, GameModeType.offlineFriend);
        expect(state.playerXName, 'PlayerX');
        expect(state.playerOName, 'PlayerO');
        expect(state.computerDifficulty, isNull);
      });

      test('creates offline computer game', () async {
        final GameStateNotifier notifier = container.read(gameStateProvider.notifier);
        await notifier.createOfflineGame(
          boardSize: 3,
          mode: GameModeType.offlineComputer,
          difficulty: 1,
        );

        final GameState state = container.read(gameStateProvider);
        expect(state.isOnline, false);
        expect(state.gameMode, GameModeType.offlineComputer);
        expect(state.computerDifficulty, 1);
      });
    });

    group('joinGame', () {
      test('joins game successfully', () async {
        final GameState gameState = GameState(
          board: 3.createEmptyBoard(),
          gameId: 'test-game-id',
          isOnline: true,
          gameMode: GameModeType.online,
          status: GameStatus.playing,
        );

        when(() => mockJoinGameUseCase.execute('test-game-id'))
            .thenAnswer((_) async => gameState);

        final GameStateNotifier notifier = container.read(gameStateProvider.notifier);
        await notifier.joinGame('test-game-id');

        final GameState state = container.read(gameStateProvider);
        expect(state.gameId, 'test-game-id');
        expect(state.isOnline, true);
      });

      test('handles join game failure', () async {
        when(() => mockJoinGameUseCase.execute('invalid-id'))
            .thenThrow(Exception('Game not found'));

        final GameStateNotifier notifier = container.read(gameStateProvider.notifier);

        try {
          await notifier.joinGame('invalid-id');
          fail('Expected exception to be thrown');
        } catch (e) {
          expect(e, isA<Exception>());
        }

        final GameState state = container.read(gameStateProvider);
        expect(state.status, GameStatus.waiting);
      });
    });

    group('makeMove', () {
      test('makes valid move', () async {
        final List<List<Player>> updatedBoard = 3.createEmptyBoard();
        updatedBoard[0][0] = Player.x;
        final GameState updatedState = GameState(
          board: updatedBoard,
          currentPlayer: Player.o,
          status: GameStatus.playing,
        );

        final GameState finalState = updatedState.copyWith(status: GameStatus.playing);

        when(() => mockMakeMoveUseCase.execute(any(), 0, 0))
            .thenAnswer((_) async => updatedState);
        when(() => mockCheckWinnerUseCase.execute(updatedState))
            .thenReturn(finalState);

        final GameStateNotifier notifier = container.read(gameStateProvider.notifier);
        await notifier.makeMove(0, 0);

        verify(() => mockMakeMoveUseCase.execute(any(), 0, 0)).called(1);
        verify(() => mockAudioService.playMoveSound()).called(1);
      });

      test('skips move if cell is occupied', () async {
        // First make a move to occupy the cell
        final List<List<Player>> updatedBoard = 3.createEmptyBoard();
        updatedBoard[0][0] = Player.x;
        final GameState updatedState = GameState(
          board: updatedBoard,
          currentPlayer: Player.o,
          status: GameStatus.playing,
        );

        when(() => mockMakeMoveUseCase.execute(any(), 0, 0))
            .thenAnswer((_) async => updatedState);
        when(() => mockCheckWinnerUseCase.execute(updatedState))
            .thenReturn(updatedState);

        final GameStateNotifier notifier = container.read(gameStateProvider.notifier);
        await notifier.makeMove(0, 0); // First move to occupy [0][0]

        // Now try to move to the same cell
        await notifier.makeMove(0, 0);

        verify(() => mockMakeMoveUseCase.execute(any(), 0, 0))
            .called(1); // Only first call
        verify(() => mockAudioService.playErrorSound()).called(1);
      });

      test('skips move if game is over', () async {
        final GameState initialState = container.read(gameStateProvider);
        final GameState finalState = initialState.copyWith(
          status: GameStatus.xWon,
        );

        when(() => mockMakeMoveUseCase.execute(any(), 0, 0))
            .thenAnswer((_) async => finalState);
        when(() => mockCheckWinnerUseCase.execute(any()))
            .thenAnswer((Invocation invocation) {
          final GameState state = invocation.positionalArguments[0] as GameState;
          return state.copyWith(status: GameStatus.xWon);
        });
        when(() => mockGetGameResultInfoUseCase.execute(any(), any()))
            .thenAnswer((Invocation invocation) {
          final GameState gameState = invocation.positionalArguments[0] as GameState;
          return GameResultInfo(
            isCurrentPlayerWin: false,
            isLocalFriendWin: false,
            shouldShowConfetti: false,
            winningPlayerName: gameState.playerXName,
          );
        });
        when(() => mockHandleGameCompletionUseCase.execute(any(), any()))
            .thenAnswer((Invocation invocation) {
          final GameState gameState = invocation.positionalArguments[0] as GameState;
          return GameCompletionData(
            history: GameHistory(
              id: gameState.gameId ?? 'test-id',
              date: DateTime.now(),
              playerXName: gameState.playerXName,
              playerOName: gameState.playerOName,
              result: gameState.status,
              gameMode: gameState.gameMode ?? GameModeType.offlineFriend,
              boardSize: gameState.board.length,
            ),
            playerXName: gameState.playerXName,
            playerOName: gameState.playerOName,
            isXWin: gameState.status == GameStatus.xWon,
            isOWin: gameState.status == GameStatus.oWon,
            isDraw: gameState.status == GameStatus.draw,
          );
        });

        final GameStateNotifier notifier = container.read(gameStateProvider.notifier);
        await notifier.makeMove(0, 0);
        await Future<void>.microtask(() {});
        await Future<void>.microtask(() {});

        final GameState currentState = container.read(gameStateProvider);
        expect(currentState.isGameOver, isTrue);

        reset(mockMakeMoveUseCase);
        reset(mockCheckWinnerUseCase);

        await notifier.makeMove(1, 1);

        verifyNever(() => mockMakeMoveUseCase.execute(any(), 1, 1));
      });

      test('sets isComputerThinking to true when computer turn starts', () async {
        final List<List<Player>> updatedBoard = 3.createEmptyBoard();
        updatedBoard[0][0] = Player.x;
        final GameState updatedState = GameState(
          board: updatedBoard,
          currentPlayer: Player.o,
          status: GameStatus.playing,
          gameMode: GameModeType.offlineComputer,
          computerDifficulty: 1,
        );

        final List<List<Player>> computerBoard = [
          [Player.x, Player.none, Player.none],
          [Player.none, Player.o, Player.none],
          [Player.none, Player.none, Player.none],
        ];
        final GameState computerMoveState = GameState(
          board: computerBoard,
          status: GameStatus.playing,
          gameMode: GameModeType.offlineComputer,
          computerDifficulty: 1,
        );

        when(() => mockMakeMoveUseCase.execute(any(), 0, 0))
            .thenAnswer((_) async => updatedState);
        when(() => mockCheckWinnerUseCase.execute(updatedState))
            .thenReturn(updatedState);
        when(() => mockMakeComputerMoveUseCase.execute(any(), 1))
            .thenAnswer((_) async => computerMoveState);
        when(() => mockCheckWinnerUseCase.execute(computerMoveState))
            .thenReturn(computerMoveState);

        final GameStateNotifier notifier = container.read(gameStateProvider.notifier);

        await notifier.createOfflineGame(
          boardSize: 3,
          mode: GameModeType.offlineComputer,
          difficulty: 1,
        );

        await notifier.makeMove(0, 0);

        await Future<void>.delayed(const Duration(milliseconds: 100));

        final GameState finalState = container.read(gameStateProvider);
        expect(finalState.isComputerThinking, isFalse);
        verify(() => mockMakeComputerMoveUseCase.execute(any(), 1)).called(1);
      });

      test('sets isComputerThinking to false when game is over before computer move', () async {
        final List<List<Player>> updatedBoard = 3.createEmptyBoard();
        updatedBoard[0][0] = Player.x;
        final GameState updatedState = GameState(
          board: updatedBoard,
          currentPlayer: Player.o,
          status: GameStatus.xWon,
          gameMode: GameModeType.offlineComputer,
          computerDifficulty: 1,
        );

        when(() => mockMakeMoveUseCase.execute(any(), 0, 0))
            .thenAnswer((_) async => updatedState);
        when(() => mockCheckWinnerUseCase.execute(updatedState))
            .thenReturn(updatedState);
        when(() => mockGetGameResultInfoUseCase.execute(any(), any()))
            .thenAnswer((Invocation invocation) {
          return const GameResultInfo(
            isCurrentPlayerWin: true,
            isLocalFriendWin: false,
            shouldShowConfetti: true,
            winningPlayerName: 'PlayerX',
          );
        });
        when(() => mockHandleGameCompletionUseCase.execute(any(), any()))
            .thenAnswer((Invocation invocation) {
          final GameState gameState = invocation.positionalArguments[0] as GameState;
          return GameCompletionData(
            history: GameHistory(
              id: gameState.gameId ?? 'test-id',
              date: DateTime.now(),
              playerXName: gameState.playerXName,
              playerOName: gameState.playerOName,
              result: gameState.status,
              gameMode: gameState.gameMode ?? GameModeType.offlineComputer,
              boardSize: gameState.board.length,
            ),
            playerXName: gameState.playerXName,
            playerOName: gameState.playerOName,
            isXWin: gameState.status == GameStatus.xWon,
            isOWin: gameState.status == GameStatus.oWon,
            isDraw: gameState.status == GameStatus.draw,
          );
        });

        final GameStateNotifier notifier = container.read(gameStateProvider.notifier);

        await notifier.createOfflineGame(
          boardSize: 3,
          mode: GameModeType.offlineComputer,
          difficulty: 1,
        );

        await notifier.makeMove(0, 0);

        await Future<void>.delayed(const Duration(milliseconds: 100));

        final GameState finalState = container.read(gameStateProvider);
        expect(finalState.isComputerThinking, isFalse);
        verifyNever(() => mockMakeComputerMoveUseCase.execute(any(), any()));
      });
    });

    group('resetGame', () {
      test('resets game while keeping game properties', () async {
        // Create a game with specific properties
        final GameState createdState = GameState(
          board: 4.createEmptyBoard(),
          gameId: 'test-game-id',
          playerId: 'test-player-id',
          isOnline: true,
          gameMode: GameModeType.online,
          status: GameStatus.playing,
        );

        when(() => mockCreateGameUseCase.execute())
            .thenAnswer((_) async => createdState);

        final GameStateNotifier notifier = container.read(gameStateProvider.notifier);
        await notifier.createGame(boardSize: 4);

        // Now reset
        notifier.resetGame();

        final GameState state = container.read(gameStateProvider);
        expect(state.board.length, 4); // Keeps board size
        expect(state.gameId, 'test-game-id'); // Keeps game ID
        expect(state.status, GameStatus.playing); // Resets status
        expect(state.board.isBoardEmpty, true); // Board is empty
      });
    });

    group('resetGameCompletely', () {
      test('resets game to default state', () async {
        // Create a game first
        final GameState createdState = GameState(
          board: 4.createEmptyBoard(),
          gameId: 'test-game-id',
          isOnline: true,
          gameMode: GameModeType.online,
          status: GameStatus.playing,
        );

        when(() => mockCreateGameUseCase.execute())
            .thenAnswer((_) async => createdState);

        final GameStateNotifier notifier = container.read(gameStateProvider.notifier);
        await notifier.createGame(boardSize: 4);

        // Now reset completely
        notifier.resetGameCompletely();

        final GameState state = container.read(gameStateProvider);
        expect(state.board.length, 3); // Default size
        expect(state.gameId, isNull); // No game ID
        expect(state.status, GameStatus.playing); // Playing status
      });
    });
  });
}
