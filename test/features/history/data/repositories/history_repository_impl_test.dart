import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/history/data/datasources/history_datasource.dart';
import 'package:tictac/features/history/data/repositories/history_repository_impl.dart';
import 'package:tictac/features/history/domain/entities/game_history.dart';

class MockHistoryDataSource extends Mock implements HistoryDataSource {}

void main() {
  late HistoryRepositoryImpl repository;
  late MockHistoryDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockHistoryDataSource();
    repository = HistoryRepositoryImpl(dataSource: mockDataSource);
  });

  group('HistoryRepositoryImpl', () {
    test('should save game history', () async {
      final GameHistory history = GameHistory(
        id: 'test-id',
        date: DateTime.now(),
        result: GameStatus.xWon,
        boardSize: 3,
      );

      when(() => mockDataSource.saveGameHistory(history))
          .thenAnswer((_) async => <dynamic, dynamic>{});

      await repository.saveGameHistory(history);

      verify(() => mockDataSource.saveGameHistory(history)).called(1);
    });

    test('should get game history without limit', () async {
      final List<GameHistory> histories = <GameHistory>[
        GameHistory(
          id: 'test-id-1',
          date: DateTime.now(),
          result: GameStatus.xWon,
          boardSize: 3,
        ),
        GameHistory(
          id: 'test-id-2',
          date: DateTime.now(),
          result: GameStatus.oWon,
          boardSize: 3,
        ),
      ];

      when(() => mockDataSource.getGameHistory())
          .thenAnswer((_) async => histories);

      final List<GameHistory> result = await repository.getGameHistory();

      expect(result, histories);
      verify(() => mockDataSource.getGameHistory()).called(1);
    });

    test('should get game history with limit', () async {
      final List<GameHistory> histories = <GameHistory>[
        GameHistory(
          id: 'test-id-1',
          date: DateTime.now(),
          result: GameStatus.xWon,
          boardSize: 3,
        ),
      ];

      when(() => mockDataSource.getGameHistory(limit: 1))
          .thenAnswer((_) async => histories);

      final List<GameHistory> result = await repository.getGameHistory(limit: 1);

      expect(result, histories);
      verify(() => mockDataSource.getGameHistory(limit: 1)).called(1);
    });

    test('should clear history', () async {
      when(() => mockDataSource.clearHistory())
          .thenAnswer((_) async => <dynamic, dynamic>{});

      await repository.clearHistory();

      verify(() => mockDataSource.clearHistory()).called(1);
    });
  });
}


