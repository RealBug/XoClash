import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/entities/game_state_extensions.dart';
import 'package:tictac/features/game/domain/usecases/get_player_name_usecase.dart';
import 'package:tictac/features/game/domain/usecases/handle_game_completion_usecase.dart';
import 'package:tictac/features/history/domain/usecases/create_game_history_usecase.dart';

void main() {
  group('HandleGameCompletionUseCase', () {
    late HandleGameCompletionUseCase useCase;
    late CreateGameHistoryUseCase createGameHistoryUseCase;
    late GetPlayerNameUseCase getPlayerNameUseCase;

    setUp(() {
      createGameHistoryUseCase = CreateGameHistoryUseCase();
      getPlayerNameUseCase = GetPlayerNameUseCase();
      useCase = HandleGameCompletionUseCase(
        createGameHistoryUseCase: createGameHistoryUseCase,
        getPlayerNameUseCase: getPlayerNameUseCase,
      );
    });

    test('should handle X win correctly', () {
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        status: GameStatus.xWon,
        playerXName: 'Player X',
        playerOName: 'Player O',
      );

      final GameCompletionData result = useCase.execute(gameState, null);

      expect(result.isXWin, true);
      expect(result.isOWin, false);
      expect(result.isDraw, false);
      expect(result.playerXName, 'Player X');
      expect(result.playerOName, 'Player O');
      expect(result.history.result, GameStatus.xWon);
    });

    test('should handle O win correctly', () {
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        currentPlayer: Player.o,
        status: GameStatus.oWon,
        playerXName: 'Player X',
        playerOName: 'Player O',
      );

      final GameCompletionData result = useCase.execute(gameState, null);

      expect(result.isXWin, false);
      expect(result.isOWin, true);
      expect(result.isDraw, false);
      expect(result.playerXName, 'Player X');
      expect(result.playerOName, 'Player O');
      expect(result.history.result, GameStatus.oWon);
    });

    test('should handle draw correctly', () {
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        status: GameStatus.draw,
        playerXName: 'Player X',
        playerOName: 'Player O',
      );

      final GameCompletionData result = useCase.execute(gameState, null);

      expect(result.isXWin, false);
      expect(result.isOWin, false);
      expect(result.isDraw, true);
      expect(result.history.result, GameStatus.draw);
    });

    test('should generate playerOName for offlineComputer mode', () {
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        status: GameStatus.xWon,
        playerXName: 'Player X',
        gameMode: GameModeType.offlineComputer,
      );

      final GameCompletionData result = useCase.execute(gameState, 2);

      expect(result.playerXName, 'Player X');
      expect(result.playerOName, 'AI_Medium');
    });

    test('should use existing playerOName when available', () {
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        status: GameStatus.xWon,
        playerXName: 'Player X',
        playerOName: 'Existing Player O',
        gameMode: GameModeType.offlineComputer,
      );

      final GameCompletionData result = useCase.execute(gameState, 2);

      expect(result.playerOName, 'Existing Player O');
    });

    test('should return null playerOName when not offlineComputer', () {
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        status: GameStatus.xWon,
        playerXName: 'Player X',
        gameMode: GameModeType.offlineFriend,
      );

      final GameCompletionData result = useCase.execute(gameState, 2);

      expect(result.playerOName, null);
    });

    test('should create history with correct game state data', () {
      final GameState gameState = GameState(
        board: 4.createEmptyBoard(),
        status: GameStatus.xWon,
        gameId: 'test-game-id',
        playerXName: 'Player X',
        playerOName: 'Player O',
        gameMode: GameModeType.offlineFriend,
      );

      final GameCompletionData result = useCase.execute(gameState, null);

      expect(result.history.id, 'test-game-id');
      expect(result.history.boardSize, 4);
      expect(result.history.gameMode, GameModeType.offlineFriend);
    });
  });
}


