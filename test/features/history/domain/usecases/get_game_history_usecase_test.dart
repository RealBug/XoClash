import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/history/domain/entities/game_history.dart';
import 'package:tictac/features/history/domain/repositories/history_repository.dart';
import 'package:tictac/features/history/domain/usecases/get_game_history_usecase.dart';

class MockHistoryRepository extends Mock implements HistoryRepository {}

void main() {
  late GetGameHistoryUseCase useCase;
  late MockHistoryRepository mockRepository;

  setUp(() {
    mockRepository = MockHistoryRepository();
    useCase = GetGameHistoryUseCase(mockRepository);
  });

  group('GetGameHistoryUseCase', () {
    test('should return game history from repository', () async {
      final List<GameHistory> expectedHistory = <GameHistory>[
        GameHistory(
          id: 'id1',
          date: DateTime.now(),
          playerXName: 'playerX',
          playerOName: 'playerO',
          result: GameStatus.xWon,
          gameMode: GameModeType.offlineFriend,
          boardSize: 3,
        ),
        GameHistory(
          id: 'id2',
          date: DateTime.now(),
          playerXName: 'playerX2',
          playerOName: 'playerO2',
          result: GameStatus.draw,
          gameMode: GameModeType.offlineComputer,
          boardSize: 4,
        ),
      ];

      when(() => mockRepository.getGameHistory()).thenAnswer((_) async => expectedHistory);

      final List<GameHistory> result = await useCase.execute();

      expect(result, equals(expectedHistory));
      expect(result.length, equals(2));
      verify(() => mockRepository.getGameHistory()).called(1);
    });

    test('should return limited game history when limit is provided', () async {
      const int limit = 5;
      final List<GameHistory> expectedHistory = List<GameHistory>.generate(
        limit,
        (int index) => GameHistory(
          id: 'id$index',
          date: DateTime.now(),
          playerXName: 'playerX$index',
          playerOName: 'playerO$index',
          result: GameStatus.xWon,
          boardSize: 3,
        ),
      );

      when(() => mockRepository.getGameHistory(limit: limit)).thenAnswer((_) async => expectedHistory);

      final List<GameHistory> result = await useCase.execute(limit: limit);

      expect(result, equals(expectedHistory));
      expect(result.length, equals(limit));
      verify(() => mockRepository.getGameHistory(limit: limit)).called(1);
    });
  });
}
