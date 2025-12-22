import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictac/core/constants/app_constants.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/history/data/datasources/history_datasource.dart';
import 'package:tictac/features/history/domain/entities/game_history.dart';

void main() {
  late HistoryDataSourceImpl dataSource;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    dataSource = HistoryDataSourceImpl();
  });

  group('HistoryDataSourceImpl', () {
    test('should save and retrieve game history', () async {
      final GameHistory history = GameHistory(
        id: 'test-id',
        date: DateTime.now(),
        playerXName: 'playerX',
        playerOName: 'playerO',
        result: GameStatus.xWon,
        gameMode: GameModeType.offlineFriend,
        boardSize: 3,
      );

      await dataSource.saveGameHistory(history);
      final List<GameHistory> result = await dataSource.getGameHistory();

      expect(result, isNotEmpty);
      expect(result.first.id, equals(history.id));
      expect(result.first.playerXName, equals(history.playerXName));
      expect(result.first.playerOName, equals(history.playerOName));
      expect(result.first.result, equals(history.result));
    });

    test('should return empty list when no history exists', () async {
      final List<GameHistory> result = await dataSource.getGameHistory();

      expect(result, isEmpty);
    });

    test('should parse all GameStatus values correctly', () async {
      final List<GameStatus> statuses = <GameStatus>[
        GameStatus.xWon,
        GameStatus.oWon,
        GameStatus.draw,
        GameStatus.waiting,
        GameStatus.playing,
      ];

      for (final GameStatus status in statuses) {
        final GameHistory history = GameHistory(
          id: 'test-$status',
          date: DateTime.now(),
          playerXName: 'X',
          playerOName: 'O',
          result: status,
          boardSize: 3,
        );

        await dataSource.saveGameHistory(history);
      }

      final List<GameHistory> result = await dataSource.getGameHistory();
      expect(result.length, equals(5));

      for (int i = 0; i < statuses.length; i++) {
        expect(result[i].result, equals(statuses[statuses.length - 1 - i]));
      }
    });

    test('should parse all GameModeType values correctly', () async {
      final List<GameModeType> modes = <GameModeType>[
        GameModeType.online,
        GameModeType.offlineFriend,
        GameModeType.offlineComputer,
      ];

      await dataSource.clearHistory();

      for (final GameModeType mode in modes) {
        final GameHistory history = GameHistory(
          id: 'test-$mode',
          date: DateTime.now(),
          playerXName: 'X',
          playerOName: 'O',
          result: GameStatus.xWon,
          gameMode: mode,
          boardSize: 3,
        );

        await dataSource.saveGameHistory(history);
      }

      final List<GameHistory> result = await dataSource.getGameHistory();
      expect(result.length, equals(3));

      for (int i = 0; i < modes.length; i++) {
        expect(result[i].gameMode, equals(modes[modes.length - 1 - i]));
      }
    });

    test('should handle null gameMode', () async {
      final GameHistory history = GameHistory(
        id: 'test-null-mode',
        date: DateTime.now(),
        playerXName: 'X',
        playerOName: 'O',
        result: GameStatus.draw,
        boardSize: 3,
      );

      await dataSource.saveGameHistory(history);
      final List<GameHistory> result = await dataSource.getGameHistory();

      expect(result, isNotEmpty);
      expect(result.first.gameMode, isNull);
    });

    test('should handle computerDifficulty field', () async {
      final GameHistory history = GameHistory(
        id: 'test-difficulty',
        date: DateTime.now(),
        playerXName: 'X',
        playerOName: 'Computer',
        result: GameStatus.xWon,
        gameMode: GameModeType.offlineComputer,
        boardSize: 3,
        computerDifficulty: 2,
      );

      await dataSource.saveGameHistory(history);
      final List<GameHistory> result = await dataSource.getGameHistory();

      expect(result, isNotEmpty);
      expect(result.first.computerDifficulty, equals(2));
    });

    test('should limit history size', () async {
      await dataSource.clearHistory();

      for (int i = 0; i < 150; i++) {
        final GameHistory history = GameHistory(
          id: 'id$i',
          date: DateTime.now(),
          result: GameStatus.xWon,
          boardSize: 3,
        );
        await dataSource.saveGameHistory(history);
      }

      final List<GameHistory> result = await dataSource.getGameHistory();

      expect(result.length, equals(AppConstants.maxHistorySize));
    });

    test('should clear history', () async {
      final GameHistory history = GameHistory(
        id: 'test-id',
        date: DateTime.now(),
        result: GameStatus.xWon,
        boardSize: 3,
      );
      await dataSource.saveGameHistory(history);

      await dataSource.clearHistory();
      final List<GameHistory> result = await dataSource.getGameHistory();

      expect(result, isEmpty);
    });
  });
}
