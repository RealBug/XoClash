import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/history/domain/entities/game_history.dart';

void main() {
  group('GameHistory', () {
    test('should create GameHistory with all properties', () {
      final DateTime date = DateTime.now();
      final GameHistory history = GameHistory(
        id: 'test-id',
        date: date,
        playerXName: 'Player X',
        playerOName: 'Player O',
        result: GameStatus.xWon,
        gameMode: GameModeType.offlineFriend,
        boardSize: 3,
      );

      expect(history.id, 'test-id');
      expect(history.date, date);
      expect(history.playerXName, 'Player X');
      expect(history.playerOName, 'Player O');
      expect(history.result, GameStatus.xWon);
      expect(history.gameMode, GameModeType.offlineFriend);
      expect(history.boardSize, 3);
      expect(history.computerDifficulty, null);
    });

    test('should create GameHistory with minimal properties', () {
      final DateTime date = DateTime.now();
      final GameHistory history = GameHistory(
        id: 'test-id',
        date: date,
        result: GameStatus.draw,
        boardSize: 3,
      );

      expect(history.id, 'test-id');
      expect(history.date, date);
      expect(history.playerXName, null);
      expect(history.playerOName, null);
      expect(history.result, GameStatus.draw);
      expect(history.gameMode, null);
      expect(history.boardSize, 3);
      expect(history.computerDifficulty, null);
    });

    test('copyWith should update properties', () {
      final DateTime date = DateTime.now();
      final GameHistory history = GameHistory(
        id: 'test-id',
        date: date,
        playerXName: 'Player X',
        result: GameStatus.xWon,
        boardSize: 3,
      );

      final GameHistory updated = history.copyWith(
        playerXName: 'New Player X',
        result: GameStatus.oWon,
        boardSize: 4,
      );

      expect(updated.id, 'test-id');
      expect(updated.date, date);
      expect(updated.playerXName, 'New Player X');
      expect(updated.result, GameStatus.oWon);
      expect(updated.boardSize, 4);
    });

    test('copyWith should keep original values when null', () {
      final DateTime date = DateTime.now();
      final GameHistory history = GameHistory(
        id: 'test-id',
        date: date,
        playerXName: 'Player X',
        result: GameStatus.xWon,
        boardSize: 3,
      );

      final GameHistory updated = history.copyWith();

      expect(updated.id, 'test-id');
      expect(updated.date, date);
      expect(updated.playerXName, 'Player X');
      expect(updated.result, GameStatus.xWon);
      expect(updated.boardSize, 3);
    });

    test('winnerName should return playerXName when X wins', () {
      final GameHistory history = GameHistory(
        id: 'test-id',
        date: DateTime.now(),
        playerXName: 'Player X',
        playerOName: 'Player O',
        result: GameStatus.xWon,
        boardSize: 3,
      );

      expect(history.winnerName, 'Player X');
    });

    test('winnerName should return playerOName when O wins', () {
      final GameHistory history = GameHistory(
        id: 'test-id',
        date: DateTime.now(),
        playerXName: 'Player X',
        playerOName: 'Player O',
        result: GameStatus.oWon,
        boardSize: 3,
      );

      expect(history.winnerName, 'Player O');
    });

    test('winnerName should return null when draw', () {
      final GameHistory history = GameHistory(
        id: 'test-id',
        date: DateTime.now(),
        playerXName: 'Player X',
        playerOName: 'Player O',
        result: GameStatus.draw,
        boardSize: 3,
      );

      expect(history.winnerName, null);
    });

    test('winnerName should return null when playing', () {
      final GameHistory history = GameHistory(
        id: 'test-id',
        date: DateTime.now(),
        result: GameStatus.playing,
        boardSize: 3,
      );

      expect(history.winnerName, null);
    });

    test('should be equal when properties are equal', () {
      final DateTime date = DateTime.now();
      final GameHistory history1 = GameHistory(
        id: 'test-id',
        date: date,
        playerXName: 'Player X',
        result: GameStatus.xWon,
        boardSize: 3,
      );

      final GameHistory history2 = GameHistory(
        id: 'test-id',
        date: date,
        playerXName: 'Player X',
        result: GameStatus.xWon,
        boardSize: 3,
      );

      expect(history1, history2);
    });
  });
}

