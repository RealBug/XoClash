import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictac/core/services/logger_service.dart';
import 'package:tictac/features/game/data/datasources/local_game_datasource.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/entities/game_state_extensions.dart';

class MockLoggerService extends Mock implements LoggerService {}

void main() {
  late LocalGameDataSourceImpl dataSource;
  late MockLoggerService mockLogger;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    mockLogger = MockLoggerService();
    dataSource = LocalGameDataSourceImpl(mockLogger);
  });

  group('Edge Cases - Large Boards', () {
    test('should save and retrieve 5x5 board', () async {
      final GameState gameState = GameState(
        board: 5.createEmptyBoard(),
        gameId: 'large-board',
        status: GameStatus.playing,
      );

      await dataSource.saveGame(gameState);
      final GameState? retrieved = await dataSource.getGame('large-board');

      expect(retrieved, isNotNull);
      expect(retrieved!.board.length, equals(5));
      expect(retrieved.board[0].length, equals(5));
    });

    test('should handle complex 5x5 board state', () async {
      const GameState gameState = GameState(
        board: <List<Player>>[
          <Player>[Player.x, Player.o, Player.x, Player.o, Player.x],
          <Player>[Player.o, Player.x, Player.o, Player.x, Player.o],
          <Player>[Player.x, Player.o, Player.x, Player.o, Player.x],
          <Player>[Player.o, Player.x, Player.o, Player.x, Player.o],
          <Player>[Player.x, Player.o, Player.x, Player.o, Player.none],
        ],
        gameId: 'complex-5x5',
        status: GameStatus.playing,
      );

      await dataSource.saveGame(gameState);
      final GameState? retrieved = await dataSource.getGame('complex-5x5');

      expect(retrieved, isNotNull);
      expect(retrieved!.board, equals(gameState.board));
    });

    test('should handle 4x4 board with partial moves', () async {
      const GameState gameState = GameState(
        board: <List<Player>>[
          <Player>[Player.x, Player.none, Player.none, Player.o],
          <Player>[Player.none, Player.x, Player.o, Player.none],
          <Player>[Player.o, Player.none, Player.x, Player.none],
          <Player>[Player.none, Player.none, Player.none, Player.x],
        ],
        gameId: 'partial-4x4',
        status: GameStatus.playing,
      );

      await dataSource.saveGame(gameState);
      final GameState? retrieved = await dataSource.getGame('partial-4x4');

      expect(retrieved, isNotNull);
      expect(retrieved!.board.length, equals(4));
      expect(retrieved.board, equals(gameState.board));
    });
  });

  group('Edge Cases - Special Characters in IDs', () {
    test('should handle game ID with special characters', () async {
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        gameId: 'test-game_123',
        status: GameStatus.playing,
      );

      await dataSource.saveGame(gameState);
      final GameState? retrieved = await dataSource.getGame('test-game_123');

      expect(retrieved, isNotNull);
      expect(retrieved!.gameId, equals('test-game_123'));
    });

    test('should handle player ID with special characters', () async {
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        gameId: 'test-game',
        playerId: 'player_2024-12-25',
        status: GameStatus.playing,
      );

      await dataSource.saveGame(gameState);
      final GameState? retrieved = await dataSource.getGame('test-game');

      expect(retrieved, isNotNull);
      expect(retrieved!.playerId, equals('player_2024-12-25'));
    });
  });

  group('Edge Cases - Player Names', () {
    test('should handle empty player names', () async {
      const GameState gameState = GameState(
        board: <List<Player>>[
          <Player>[Player.none, Player.none, Player.none],
          <Player>[Player.none, Player.none, Player.none],
          <Player>[Player.none, Player.none, Player.none],
        ],
        gameId: 'empty-names',
        playerXName: '',
        playerOName: '',
        status: GameStatus.playing,
      );

      await dataSource.saveGame(gameState);
      final GameState? retrieved = await dataSource.getGame('empty-names');

      expect(retrieved, isNotNull);
      expect(retrieved!.playerXName, equals(''));
      expect(retrieved.playerOName, equals(''));
    });

    test('should handle very long player names', () async {
      const String longName = 'ThisIsAVeryLongPlayerNameThatExceedsNormalLengthLimits';
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        gameId: 'long-names',
        playerXName: longName,
        playerOName: longName,
        status: GameStatus.playing,
      );

      await dataSource.saveGame(gameState);
      final GameState? retrieved = await dataSource.getGame('long-names');

      expect(retrieved, isNotNull);
      expect(retrieved!.playerXName, equals(longName));
      expect(retrieved.playerOName, equals(longName));
    });

    test('should handle player names with special characters', () async {
      const GameState gameState = GameState(
        board: <List<Player>>[
          <Player>[Player.none, Player.none, Player.none],
          <Player>[Player.none, Player.none, Player.none],
          <Player>[Player.none, Player.none, Player.none],
        ],
        gameId: 'special-names',
        playerXName: 'Player-X_2024!',
        playerOName: 'Player-O@Test#',
        status: GameStatus.playing,
      );

      await dataSource.saveGame(gameState);
      final GameState? retrieved = await dataSource.getGame('special-names');

      expect(retrieved, isNotNull);
      expect(retrieved!.playerXName, equals('Player-X_2024!'));
      expect(retrieved.playerOName, equals('Player-O@Test#'));
    });

    test('should handle unicode characters in player names', () async {
      const GameState gameState = GameState(
        board: <List<Player>>[
          <Player>[Player.none, Player.none, Player.none],
          <Player>[Player.none, Player.none, Player.none],
          <Player>[Player.none, Player.none, Player.none],
        ],
        gameId: 'unicode-names',
        playerXName: 'Joueur 🎮',
        playerOName: 'Игрок',
        status: GameStatus.playing,
      );

      await dataSource.saveGame(gameState);
      final GameState? retrieved = await dataSource.getGame('unicode-names');

      expect(retrieved, isNotNull);
      expect(retrieved!.playerXName, equals('Joueur 🎮'));
      expect(retrieved.playerOName, equals('Игрок'));
    });
  });

  group('Edge Cases - Concurrent Operations', () {
    test('should handle rapid successive saves', () async {
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        gameId: 'rapid-save',
        status: GameStatus.playing,
      );

      await dataSource.saveGame(gameState);
      await dataSource.saveGame(gameState.copyWith(currentPlayer: Player.o));
      await dataSource.saveGame(gameState.copyWith(status: GameStatus.xWon));

      final GameState? retrieved = await dataSource.getGame('rapid-save');

      expect(retrieved, isNotNull);
      expect(retrieved!.status, equals(GameStatus.xWon));
    });

    test('should handle save after delete', () async {
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        gameId: 'save-delete-save',
        status: GameStatus.playing,
      );

      await dataSource.saveGame(gameState);
      await dataSource.deleteGame('save-delete-save');
      await dataSource.saveGame(gameState);

      final GameState? retrieved = await dataSource.getGame('save-delete-save');
      expect(retrieved, isNotNull);
    });
  });

  group('Edge Cases - Boundary Values', () {
    test('should handle max difficulty value', () async {
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        gameId: 'max-difficulty',
        computerDifficulty: 999,
        gameMode: GameModeType.offlineComputer,
        status: GameStatus.playing,
      );

      await dataSource.saveGame(gameState);
      final GameState? retrieved = await dataSource.getGame('max-difficulty');

      expect(retrieved, isNotNull);
      expect(retrieved!.computerDifficulty, equals(999));
    });

    test('should handle zero difficulty value', () async {
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        gameId: 'zero-difficulty',
        computerDifficulty: 0,
        gameMode: GameModeType.offlineComputer,
        status: GameStatus.playing,
      );

      await dataSource.saveGame(gameState);
      final GameState? retrieved = await dataSource.getGame('zero-difficulty');

      expect(retrieved, isNotNull);
      expect(retrieved!.computerDifficulty, equals(0));
    });

    test('should handle negative difficulty value', () async {
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        gameId: 'negative-difficulty',
        computerDifficulty: -1,
        gameMode: GameModeType.offlineComputer,
        status: GameStatus.playing,
      );

      await dataSource.saveGame(gameState);
      final GameState? retrieved = await dataSource.getGame('negative-difficulty');

      expect(retrieved, isNotNull);
      expect(retrieved!.computerDifficulty, equals(-1));
    });
  });

  group('Edge Cases - Win Scenarios', () {
    test('should save game with xWon status and full board', () async {
      const GameState gameState = GameState(
        board: <List<Player>>[
          <Player>[Player.x, Player.x, Player.x],
          <Player>[Player.o, Player.o, Player.none],
          <Player>[Player.none, Player.none, Player.none],
        ],
        gameId: 'x-won',
        status: GameStatus.xWon,
      );

      await dataSource.saveGame(gameState);
      final GameState? retrieved = await dataSource.getGame('x-won');

      expect(retrieved, isNotNull);
      expect(retrieved!.status, equals(GameStatus.xWon));
      expect(retrieved.board, equals(gameState.board));
    });

    test('should save game with oWon status', () async {
      const GameState gameState = GameState(
        board: <List<Player>>[
          <Player>[Player.o, Player.x, Player.x],
          <Player>[Player.o, Player.x, Player.none],
          <Player>[Player.o, Player.none, Player.none],
        ],
        gameId: 'o-won',
        status: GameStatus.oWon,
      );

      await dataSource.saveGame(gameState);
      final GameState? retrieved = await dataSource.getGame('o-won');

      expect(retrieved, isNotNull);
      expect(retrieved!.status, equals(GameStatus.oWon));
    });

    test('should save game with draw status and full board', () async {
      const GameState gameState = GameState(
        board: <List<Player>>[
          <Player>[Player.x, Player.o, Player.x],
          <Player>[Player.o, Player.x, Player.o],
          <Player>[Player.o, Player.x, Player.o],
        ],
        gameId: 'draw',
        status: GameStatus.draw,
      );

      await dataSource.saveGame(gameState);
      final GameState? retrieved = await dataSource.getGame('draw');

      expect(retrieved, isNotNull);
      expect(retrieved!.status, equals(GameStatus.draw));
      final bool allFilled = retrieved.board.every(
        (List<Player> row) => row.every((Player cell) => cell != Player.none),
      );
      expect(allFilled, isTrue);
    });
  });

  group('Edge Cases - Storage Limits', () {
    test('should handle saving many games', () async {
      for (int i = 0; i < 50; i++) {
        final GameState gameState = GameState(
          board: 3.createEmptyBoard(),
          gameId: 'game-$i',
          status: GameStatus.playing,
        );
        await dataSource.saveGame(gameState);
      }

      final GameState? retrieved = await dataSource.getGame('game-25');
      expect(retrieved, isNotNull);
      expect(retrieved!.gameId, equals('game-25'));
    });

    test('should handle overwriting games', () async {
      final GameState gameState1 = GameState(
        board: 3.createEmptyBoard(),
        gameId: 'overwrite-test',
      );

      await dataSource.saveGame(gameState1);

      final GameState gameState2 = gameState1.copyWith(status: GameStatus.playing);
      await dataSource.saveGame(gameState2);

      final GameState? retrieved = await dataSource.getGame('overwrite-test');
      expect(retrieved!.status, equals(GameStatus.playing));
    });
  });

  group('Edge Cases - Delete Operations', () {
    test('should not throw when deleting non-existent game', () async {
      expect(
        () => dataSource.deleteGame('non-existent'),
        returnsNormally,
      );
    });

    test('should handle deleting the same game twice', () async {
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        gameId: 'delete-twice',
      );

      await dataSource.saveGame(gameState);
      await dataSource.deleteGame('delete-twice');
      await dataSource.deleteGame('delete-twice');

      final GameState? retrieved = await dataSource.getGame('delete-twice');
      expect(retrieved, isNull);
    });
  });
}
