import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/entities/game_state_extensions.dart';

void main() {
  group('GameState', () {
    test('should create a game state with default values', () {
      final List<List<Player>> board = 3.createEmptyBoard();

      final GameState gameState = GameState(board: board);

      expect(gameState.board, equals(board));
      expect(gameState.currentPlayer, equals(Player.x));
      expect(gameState.status, equals(GameStatus.waiting));
      expect(gameState.gameId, isNull);
      expect(gameState.playerId, isNull);
      expect(gameState.isOnline, isFalse);
    });

    test('should create a game state with custom values', () {
      final List<List<Player>> board = 3.createEmptyBoard();

      final GameState gameState = GameState(
        board: board,
        currentPlayer: Player.o,
        status: GameStatus.playing,
        gameId: 'test-game-id',
        playerId: 'test-player-id',
        isOnline: true,
      );

      expect(gameState.currentPlayer, equals(Player.o));
      expect(gameState.status, equals(GameStatus.playing));
      expect(gameState.gameId, equals('test-game-id'));
      expect(gameState.playerId, equals('test-player-id'));
      expect(gameState.isOnline, isTrue);
    });

    test('copyWith should create a new instance with updated values', () {
      final List<List<Player>> board = 3.createEmptyBoard();

      final GameState original = GameState(
        board: board,
        gameId: 'original-id',
      );

      final GameState updated = original.copyWith(
        currentPlayer: Player.o,
        status: GameStatus.playing,
        gameId: 'updated-id',
      );

      expect(updated.currentPlayer, equals(Player.o));
      expect(updated.status, equals(GameStatus.playing));
      expect(updated.gameId, equals('updated-id'));
      expect(updated.playerId, equals(original.playerId));
      expect(original.currentPlayer, equals(Player.x));
    });

    test('isGameOver should return true when X wins', () {
      final List<List<Player>> board = <List<Player>>[
        <Player>[Player.x, Player.x, Player.x],
        <Player>[Player.none, Player.none, Player.none],
        <Player>[Player.none, Player.none, Player.none],
      ];

      final GameState gameState = GameState(
        board: board,
        status: GameStatus.xWon,
      );

      expect(gameState.isGameOver, isTrue);
    });

    test('isGameOver should return true when O wins', () {
      final List<List<Player>> board = <List<Player>>[
        <Player>[Player.o, Player.o, Player.o],
        <Player>[Player.none, Player.none, Player.none],
        <Player>[Player.none, Player.none, Player.none],
      ];

      final GameState gameState = GameState(
        board: board,
        status: GameStatus.oWon,
      );

      expect(gameState.isGameOver, isTrue);
    });

    test('isGameOver should return true when draw', () {
      final List<List<Player>> board = <List<Player>>[
        <Player>[Player.x, Player.o, Player.x],
        <Player>[Player.o, Player.x, Player.o],
        <Player>[Player.o, Player.x, Player.o],
      ];

      final GameState gameState = GameState(
        board: board,
        status: GameStatus.draw,
      );

      expect(gameState.isGameOver, isTrue);
    });

    test('isGameOver should return false when game is in progress', () {
      final List<List<Player>> board = 3.createEmptyBoard();

      final GameState gameState = GameState(
        board: board,
        status: GameStatus.playing,
      );

      expect(gameState.isGameOver, isFalse);
    });

    test('should be equal when all properties are the same', () {
      final List<List<Player>> board1 = 3.createEmptyBoard();
      final List<List<Player>> board2 = 3.createEmptyBoard();

      final GameState gameState1 = GameState(
        board: board1,
        gameId: 'test-id',
        playerId: 'player-id',
      );
      final GameState gameState2 = GameState(
        board: board2,
        gameId: 'test-id',
        playerId: 'player-id',
      );

      expect(gameState1, equals(gameState2));
    });

    test('should not be equal when properties differ', () {
      final List<List<Player>> board = 3.createEmptyBoard();

      final GameState gameState1 = GameState(
        board: board,
        gameId: 'test-id-1',
      );
      final GameState gameState2 = GameState(
        board: board,
        gameId: 'test-id-2',
      );

      expect(gameState1, isNot(equals(gameState2)));
    });
  });
}




















