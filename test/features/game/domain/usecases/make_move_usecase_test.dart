import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/entities/game_state_extensions.dart';
import 'package:tictac/features/game/domain/repositories/game_repository.dart';
import 'package:tictac/features/game/domain/usecases/make_move_usecase.dart';

class MockGameRepository extends Mock implements GameRepository {}

void main() {
  late MakeMoveUseCase useCase;
  late MockGameRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(
      GameState(
        board: 3.createEmptyBoard(),
      ),
    );
  });

  setUp(() {
    mockRepository = MockGameRepository();
    useCase = MakeMoveUseCase(mockRepository);
  });

  test('should make a move on an empty cell', () async {
    final List<List<Player>> board = 3.createEmptyBoard();
    final GameState gameState = GameState(
      board: board,
      status: GameStatus.playing,
    );

    final List<List<Player>> expectedBoard = board.map((List<Player> r) => r.map((Player cell) => cell).toList()).toList();
    expectedBoard[0][0] = Player.x;
    final GameState expectedGameState = gameState.copyWith(board: expectedBoard);

    when(() => mockRepository.makeMove(gameState, 0, 0))
        .thenAnswer((_) async => expectedGameState);

    final GameState result = await useCase.execute(gameState, 0, 0);

    expect(result, equals(expectedGameState));
    expect(result.board[0][0], equals(Player.x));
    verify(() => mockRepository.makeMove(gameState, 0, 0)).called(1);
  });

  test('should not make a move if cell is already occupied', () async {
    final List<List<Player>> board = 3.createEmptyBoard();
    board[0][0] = Player.x;

    final GameState gameState = GameState(
      board: board,
      currentPlayer: Player.o,
      status: GameStatus.playing,
    );

    final GameState result = await useCase.execute(gameState, 0, 0);

    expect(result, equals(gameState));
  });

  test('should not make a move if game is over', () async {
    final List<List<Player>> board = 3.createEmptyBoard();
    final GameState gameState = GameState(
      board: board,
      status: GameStatus.xWon,
    );

    final GameState result = await useCase.execute(gameState, 0, 0);

    expect(result, equals(gameState));
  });
}
