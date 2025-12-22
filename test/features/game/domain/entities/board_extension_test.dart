import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/entities/game_state_extensions.dart';

void main() {
  group('BoardSizeExtension', () {
    test('should create empty 3x3 board', () {
      final List<List<Player>> board = 3.createEmptyBoard();

      expect(board.length, equals(3));
      expect(board[0].length, equals(3));
      expect(board.every((List<Player> row) => row.every((Player cell) => cell == Player.none)),
          isTrue);
    });

    test('should create empty 4x4 board', () {
      final List<List<Player>> board = 4.createEmptyBoard();

      expect(board.length, equals(4));
      expect(board[0].length, equals(4));
      expect(board.every((List<Player> row) => row.every((Player cell) => cell == Player.none)),
          isTrue);
    });

    test('should create empty 5x5 board', () {
      final List<List<Player>> board = 5.createEmptyBoard();

      expect(board.length, equals(5));
      expect(board[0].length, equals(5));
      expect(board.every((List<Player> row) => row.every((Player cell) => cell == Player.none)),
          isTrue);
    });

    test('should create board with minimum size (1x1)', () {
      final List<List<Player>> board = 1.createEmptyBoard();

      expect(board.length, equals(1));
      expect(board[0].length, equals(1));
      expect(board[0][0], equals(Player.none));
    });

    test('should create board with large size (10x10)', () {
      final List<List<Player>> board = 10.createEmptyBoard();

      expect(board.length, equals(10));
      expect(board[0].length, equals(10));
      expect(board.every((List<Player> row) => row.every((Player cell) => cell == Player.none)),
          isTrue);
    });

    test('should create independent cells in board', () {
      final List<List<Player>> board = 3.createEmptyBoard();

      board[0][0] = Player.x;
      board[1][1] = Player.o;

      expect(board[0][0], equals(Player.x));
      expect(board[1][1], equals(Player.o));
      expect(board[0][1], equals(Player.none));
      expect(board[2][2], equals(Player.none));
    });
  });

  group('BoardExtension - isBoardEmpty', () {
    test('should return true for completely empty board', () {
      final List<List<Player>> board = 3.createEmptyBoard();

      expect(board.isBoardEmpty, isTrue);
    });

    test('should return false for board with one move', () {
      final List<List<Player>> board = 3.createEmptyBoard();
      board[0][0] = Player.x;

      expect(board.isBoardEmpty, isFalse);
    });

    test('should return false for board with multiple moves', () {
      const List<List<Player>> board = <List<Player>>[
        <Player>[Player.x, Player.o, Player.none],
        <Player>[Player.none, Player.x, Player.none],
        <Player>[Player.none, Player.none, Player.o],
      ];

      expect(board.isBoardEmpty, isFalse);
    });

    test('should return false for completely filled board', () {
      const List<List<Player>> board = <List<Player>>[
        <Player>[Player.x, Player.o, Player.x],
        <Player>[Player.o, Player.x, Player.o],
        <Player>[Player.o, Player.x, Player.o],
      ];

      expect(board.isBoardEmpty, isFalse);
    });

    test('should work with 4x4 board', () {
      final List<List<Player>> board = 4.createEmptyBoard();

      expect(board.isBoardEmpty, isTrue);

      board[2][3] = Player.o;

      expect(board.isBoardEmpty, isFalse);
    });

    test('should work with 5x5 board', () {
      final List<List<Player>> board = 5.createEmptyBoard();

      expect(board.isBoardEmpty, isTrue);

      board[4][4] = Player.x;

      expect(board.isBoardEmpty, isFalse);
    });

    test('should work with 1x1 board', () {
      final List<List<Player>> board = 1.createEmptyBoard();

      expect(board.isBoardEmpty, isTrue);

      board[0][0] = Player.x;

      expect(board.isBoardEmpty, isFalse);
    });

    test('should handle board with only Player.none values', () {
      final List<List<Player>> board = <List<Player>>[
        <Player>[Player.none, Player.none, Player.none],
        <Player>[Player.none, Player.none, Player.none],
        <Player>[Player.none, Player.none, Player.none],
      ];

      expect(board.isBoardEmpty, isTrue);
    });

    test('should detect non-empty board with X in last position', () {
      const List<List<Player>> board = <List<Player>>[
        <Player>[Player.none, Player.none, Player.none],
        <Player>[Player.none, Player.none, Player.none],
        <Player>[Player.none, Player.none, Player.x],
      ];

      expect(board.isBoardEmpty, isFalse);
    });

    test('should detect non-empty board with O in first position', () {
      const List<List<Player>> board = <List<Player>>[
        <Player>[Player.o, Player.none, Player.none],
        <Player>[Player.none, Player.none, Player.none],
        <Player>[Player.none, Player.none, Player.none],
      ];

      expect(board.isBoardEmpty, isFalse);
    });

    test('should detect non-empty board with move in center', () {
      const List<List<Player>> board = <List<Player>>[
        <Player>[Player.none, Player.none, Player.none],
        <Player>[Player.none, Player.x, Player.none],
        <Player>[Player.none, Player.none, Player.none],
      ];

      expect(board.isBoardEmpty, isFalse);
    });
  });

  group('BoardExtension - Edge Cases', () {
    test('should handle empty list (0x0 board)', () {
      const List<List<Player>> board = <List<Player>>[];

      expect(board.isBoardEmpty, isTrue);
    });

    test('should handle single row board (1xN)', () {
      const List<List<Player>> board = <List<Player>>[
        <Player>[Player.none, Player.none, Player.none],
      ];

      expect(board.isBoardEmpty, isTrue);

      const List<List<Player>> boardWithMove = <List<Player>>[
        <Player>[Player.x, Player.none, Player.none],
      ];

      expect(boardWithMove.isBoardEmpty, isFalse);
    });

    test('should handle very large empty board', () {
      final List<List<Player>> board = 100.createEmptyBoard();

      expect(board.isBoardEmpty, isTrue);
      expect(board.length, equals(100));
      expect(board[0].length, equals(100));
    });
  });

  group('BoardExtension - Performance', () {
    test('should efficiently check large board', () {
      final List<List<Player>> board = 50.createEmptyBoard();

      final Stopwatch stopwatch = Stopwatch()..start();
      final bool isEmpty = board.isBoardEmpty;
      stopwatch.stop();

      expect(isEmpty, isTrue);
      expect(stopwatch.elapsedMilliseconds, lessThan(100));
    });

    test('should efficiently check large non-empty board', () {
      final List<List<Player>> board = 50.createEmptyBoard();
      board[49][49] = Player.x;

      final Stopwatch stopwatch = Stopwatch()..start();
      final bool isEmpty = board.isBoardEmpty;
      stopwatch.stop();

      expect(isEmpty, isFalse);
      expect(stopwatch.elapsedMilliseconds, lessThan(100));
    });
  });
}
