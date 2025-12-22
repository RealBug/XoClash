import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/usecases/create_offline_game_usecase.dart';

void main() {
  late CreateOfflineGameUseCase useCase;

  setUp(() {
    useCase = CreateOfflineGameUseCase();
  });

  group('CreateOfflineGameUseCase', () {
    test('should create offline friend game with correct properties', () {
      const int boardSize = 3;
      const GameModeType mode = GameModeType.offlineFriend;
      const String playerXName = 'Player X';
      const String playerOName = 'Player O';

      final GameState gameState = useCase.execute(
        boardSize: boardSize,
        mode: mode,
        playerXName: playerXName,
        playerOName: playerOName,
      );

      expect(gameState.board.length, equals(boardSize));
      expect(gameState.gameMode, equals(mode));
      expect(gameState.playerXName, equals(playerXName));
      expect(gameState.playerOName, equals(playerOName));
      expect(gameState.computerDifficulty, isNull);
      expect(gameState.status, equals(GameStatus.playing));
      expect(gameState.gameId, isNotNull);
      expect(gameState.gameId, startsWith('offline_'));
    });

    test('should create offline computer game with difficulty', () {
      const int boardSize = 4;
      const GameModeType mode = GameModeType.offlineComputer;
      const int difficulty = 2;

      final GameState gameState = useCase.execute(
        boardSize: boardSize,
        mode: mode,
        difficulty: difficulty,
      );

      expect(gameState.board.length, equals(boardSize));
      expect(gameState.gameMode, equals(mode));
      expect(gameState.computerDifficulty, equals(difficulty));
      expect(gameState.status, equals(GameStatus.playing));
      expect(gameState.gameId, isNotNull);
      expect(gameState.gameId, startsWith('offline_'));
    });

    test('should generate unique game IDs', () async {
      final GameState gameState1 = useCase.execute(
        boardSize: 3,
        mode: GameModeType.offlineFriend,
      );
      
      // Small delay to ensure different timestamp
      await Future<void>.delayed(const Duration(milliseconds: 2));
      
      final GameState gameState2 = useCase.execute(
        boardSize: 3,
        mode: GameModeType.offlineFriend,
      );

      expect(gameState1.gameId, isNot(equals(gameState2.gameId)));
    });

    test('should create game with different board sizes', () {
      for (final int boardSize in <int>[3, 4, 5]) {
        final GameState gameState = useCase.execute(
          boardSize: boardSize,
          mode: GameModeType.offlineFriend,
        );

        expect(gameState.board.length, equals(boardSize));
        expect(gameState.board[0].length, equals(boardSize));
      }
    });

    test('should create empty board', () {
      final GameState gameState = useCase.execute(
        boardSize: 3,
        mode: GameModeType.offlineFriend,
      );

      for (final List<Player> row in gameState.board) {
        for (final Player cell in row) {
          expect(cell, equals(Player.none));
        }
      }
    });
  });
}

