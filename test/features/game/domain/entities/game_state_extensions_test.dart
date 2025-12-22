import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/entities/game_state_extensions.dart';

void main() {
  group('BoardSizeExtension', () {
    test('createEmptyBoard() creates 3x3 board with all Player.none', () {
      final List<List<Player>> board = 3.createEmptyBoard();

      expect(board.length, 3);
      expect(board[0].length, 3);
      expect(board[1].length, 3);
      expect(board[2].length, 3);

      for (final List<Player> row in board) {
        for (final Player cell in row) {
          expect(cell, Player.none);
        }
      }
    });

    test('createEmptyBoard() creates 4x4 board with all Player.none', () {
      final List<List<Player>> board = 4.createEmptyBoard();

      expect(board.length, 4);
      for (final List<Player> row in board) {
        expect(row.length, 4);
        for (final Player cell in row) {
          expect(cell, Player.none);
        }
      }
    });

    test('createEmptyBoard() creates 5x5 board with all Player.none', () {
      final List<List<Player>> board = 5.createEmptyBoard();

      expect(board.length, 5);
      for (final List<Player> row in board) {
        expect(row.length, 5);
        for (final Player cell in row) {
          expect(cell, Player.none);
        }
      }
    });

    test('createEmptyBoard() creates board of any size', () {
      for (final int size in <int>[2, 6, 10]) {
        final List<List<Player>> board = size.createEmptyBoard();
        expect(board.length, size);
        for (final List<Player> row in board) {
          expect(row.length, size);
          for (final Player cell in row) {
            expect(cell, Player.none);
          }
        }
      }
    });
  });

  group('BoardExtension', () {
    test('isBoardEmpty returns true for completely empty board', () {
      final List<List<Player>> board = 3.createEmptyBoard();
      expect(board.isBoardEmpty, true);
    });

    test('isBoardEmpty returns false when one cell is filled', () {
      final List<List<Player>> board = 3.createEmptyBoard();
      board[0][0] = Player.x;
      expect(board.isBoardEmpty, false);
    });

    test('isBoardEmpty returns false when board is partially filled', () {
      final List<List<Player>> board = 3.createEmptyBoard();
      board[0][0] = Player.x;
      board[1][1] = Player.o;
      expect(board.isBoardEmpty, false);
    });

    test('isBoardEmpty returns false when board is completely filled', () {
      final List<List<Player>> board = <List<Player>>[
        <Player>[Player.x, Player.o, Player.x],
        <Player>[Player.o, Player.x, Player.o],
        <Player>[Player.x, Player.o, Player.x],
      ];
      expect(board.isBoardEmpty, false);
    });

    test('isBoardEmpty returns false when board has Player.o', () {
      final List<List<Player>> board = 3.createEmptyBoard();
      board[1][1] = Player.o;
      expect(board.isBoardEmpty, false);
    });

    test('isBoardEmpty works with different board sizes', () {
      expect(4.createEmptyBoard().isBoardEmpty, true);
      expect(5.createEmptyBoard().isBoardEmpty, true);

      final List<List<Player>> board4 = 4.createEmptyBoard();
      board4[0][0] = Player.x;
      expect(board4.isBoardEmpty, false);
    });
  });
}


