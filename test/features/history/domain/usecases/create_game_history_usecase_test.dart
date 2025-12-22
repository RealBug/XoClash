import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/entities/game_state_extensions.dart';
import 'package:tictac/features/history/domain/entities/game_history.dart';
import 'package:tictac/features/history/domain/usecases/create_game_history_usecase.dart';

void main() {
  group('CreateGameHistoryUseCase', () {
    late CreateGameHistoryUseCase useCase;

    setUp(() {
      useCase = CreateGameHistoryUseCase();
    });

    test('should create GameHistory from GameState with gameId', () {
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        status: GameStatus.xWon,
        gameId: 'test-game-id',
        playerXName: 'Player X',
        playerOName: 'Player O',
        gameMode: GameModeType.offlineFriend,
      );

      final GameHistory history = useCase.execute(gameState);

      expect(history.id, 'test-game-id');
      expect(history.playerXName, 'Player X');
      expect(history.playerOName, 'Player O');
      expect(history.result, GameStatus.xWon);
      expect(history.gameMode, GameModeType.offlineFriend);
      expect(history.boardSize, 3);
      expect(history.computerDifficulty, null);
    });

    test('should create GameHistory from GameState without gameId', () {
      final GameState gameState = GameState(
        board: 4.createEmptyBoard(),
        status: GameStatus.draw,
        gameMode: GameModeType.offlineComputer,
        computerDifficulty: 2,
      );

      final GameHistory history = useCase.execute(gameState);

      expect(history.id, isNotEmpty);
      expect(history.result, GameStatus.draw);
      expect(history.gameMode, GameModeType.offlineComputer);
      expect(history.boardSize, 4);
      expect(history.computerDifficulty, 2);
    });

    test('should create GameHistory with current date', () {
      final DateTime beforeExecution = DateTime.now();
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        status: GameStatus.playing,
      );

      final GameHistory history = useCase.execute(gameState);
      final DateTime afterExecution = DateTime.now();

      expect(history.date.isAfter(beforeExecution.subtract(const Duration(seconds: 1))), true);
      expect(history.date.isBefore(afterExecution.add(const Duration(seconds: 1))), true);
    });

    test('should handle GameState with null optional fields', () {
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        status: GameStatus.playing,
      );

      final GameHistory history = useCase.execute(gameState);

      expect(history.playerXName, null);
      expect(history.playerOName, null);
      expect(history.gameMode, null);
      expect(history.computerDifficulty, null);
    });
  });
}


