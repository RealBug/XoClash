import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/history/domain/entities/game_history.dart';
import 'package:tictac/features/history/domain/repositories/history_repository.dart';
import 'package:tictac/features/history/domain/usecases/save_game_history_usecase.dart';

class MockHistoryRepository extends Mock implements HistoryRepository {}

void main() {
  late SaveGameHistoryUseCase useCase;
  late MockHistoryRepository mockRepository;

  setUp(() {
    mockRepository = MockHistoryRepository();
    useCase = SaveGameHistoryUseCase(mockRepository);
  });

  group('SaveGameHistoryUseCase', () {
    test('should save game history successfully', () async {
      final GameHistory history = GameHistory(
        id: 'test-id',
        date: DateTime.now(),
        playerXName: 'playerX',
        playerOName: 'playerO',
        result: GameStatus.xWon,
        gameMode: GameModeType.offlineFriend,
        boardSize: 3,
      );

      when(() => mockRepository.saveGameHistory(history)).thenAnswer((_) async => Future<void>.value());

      await useCase.execute(history);

      verify(() => mockRepository.saveGameHistory(history)).called(1);
    });
  });
}
