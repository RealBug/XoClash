import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/entities/game_state_extensions.dart';
import 'package:tictac/features/game/domain/repositories/game_repository.dart';
import 'package:tictac/features/game/domain/usecases/create_game_usecase.dart';

class MockGameRepository extends Mock implements GameRepository {}

void main() {
  late CreateGameUseCase useCase;
  late MockGameRepository mockRepository;

  setUp(() {
    mockRepository = MockGameRepository();
    useCase = CreateGameUseCase(mockRepository);
  });

  test('should create a new game', () async {
    final GameState expectedGameState = GameState(
      board: 3.createEmptyBoard(),
      gameId: 'test-game-id',
      playerId: 'test-player-id',
    );

    when(() => mockRepository.createGame())
        .thenAnswer((_) async => expectedGameState);

    final GameState result = await useCase.execute();

    expect(result, equals(expectedGameState));
    verify(() => mockRepository.createGame()).called(1);
  });

  test('should propagate errors from repository', () async {
    when(() => mockRepository.createGame()).thenThrow(Exception('Error'));

    expect(() => useCase.execute(), throwsException);
    verify(() => mockRepository.createGame()).called(1);
  });
}




















