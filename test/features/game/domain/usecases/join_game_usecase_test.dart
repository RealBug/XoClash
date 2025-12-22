import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/entities/game_state_extensions.dart';
import 'package:tictac/features/game/domain/repositories/game_repository.dart';
import 'package:tictac/features/game/domain/usecases/join_game_usecase.dart';

class MockGameRepository extends Mock implements GameRepository {}

void main() {
  late JoinGameUseCase useCase;
  late MockGameRepository mockRepository;

  setUp(() {
    mockRepository = MockGameRepository();
    useCase = JoinGameUseCase(mockRepository);
  });

  test('should join an existing game', () async {
    const String gameId = 'test-game-id';
    final GameState expectedGameState = GameState(
      board: 3.createEmptyBoard(),
      gameId: gameId,
      status: GameStatus.playing,
    );

    when(() => mockRepository.joinGame(gameId))
        .thenAnswer((_) async => expectedGameState);

    final GameState result = await useCase.execute(gameId);

    expect(result, equals(expectedGameState));
    verify(() => mockRepository.joinGame(gameId)).called(1);
  });

  test('should propagate errors from repository', () async {
    const String gameId = 'invalid-game-id';

    when(() => mockRepository.joinGame(gameId))
        .thenThrow(Exception('Game not found'));

    expect(() => useCase.execute(gameId), throwsException);
    verify(() => mockRepository.joinGame(gameId)).called(1);
  });
}




















