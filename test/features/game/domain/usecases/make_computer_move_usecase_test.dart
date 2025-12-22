import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/core/constants/game_constants.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/entities/game_state_extensions.dart';
import 'package:tictac/features/game/domain/usecases/check_winner_usecase.dart';
import 'package:tictac/features/game/domain/usecases/make_computer_move_usecase.dart';
import 'package:tictac/features/game/domain/usecases/select_ai_move_usecase.dart';

class MockSelectAIMoveUseCase extends Mock implements SelectAIMoveUseCase {}
class MockCheckWinnerUseCase extends Mock implements CheckWinnerUseCase {}

void setUpAllFallbacks() {
  registerFallbackValue(
    GameState(
      board: 3.createEmptyBoard(),
    ),
  );
}

void main() {
  setUpAll(() {
    setUpAllFallbacks();
  });

  late MakeComputerMoveUseCase useCase;
  late MockSelectAIMoveUseCase mockSelectAIMoveUseCase;
  late MockCheckWinnerUseCase mockCheckWinnerUseCase;

  setUp(() {
    mockSelectAIMoveUseCase = MockSelectAIMoveUseCase();
    mockCheckWinnerUseCase = MockCheckWinnerUseCase();
    useCase = MakeComputerMoveUseCase(
      selectAIMoveUseCase: mockSelectAIMoveUseCase,
      checkWinnerUseCase: mockCheckWinnerUseCase,
    );
  });

  group('MakeComputerMoveUseCase', () {
    test('should make computer move and check for winner', () async {
      final GameState initialState = GameState(
        board: 3.createEmptyBoard(),
        currentPlayer: Player.o,
        status: GameStatus.playing,
      );
      final GameState updatedState = initialState.copyWith(
        board: <List<Player>>[
          <Player>[Player.x, Player.none, Player.none],
          <Player>[Player.none, Player.o, Player.none],
          <Player>[Player.none, Player.none, Player.none],
        ],
      );
      final GameState finalState = updatedState.copyWith(
        status: GameStatus.playing,
      );

      when(() => mockSelectAIMoveUseCase.execute(any(), any()))
          .thenReturn(updatedState);
      when(() => mockCheckWinnerUseCase.execute(any()))
          .thenReturn(finalState);

      final GameState result = await useCase.execute(initialState, GameConstants.aiEasyDifficulty);

      expect(result, equals(finalState));
      verify(() => mockSelectAIMoveUseCase.execute(initialState, GameConstants.aiEasyDifficulty)).called(1);
      verify(() => mockCheckWinnerUseCase.execute(updatedState)).called(1);
    });

    test('should return same state if game is already over', () async {
      final GameState gameOverState = GameState(
        board: 3.createEmptyBoard(),
        status: GameStatus.xWon,
      );

      final GameState result = await useCase.execute(gameOverState, GameConstants.aiEasyDifficulty);

      expect(result, equals(gameOverState));
      verifyNever(() => mockSelectAIMoveUseCase.execute(any(), any()));
      verifyNever(() => mockCheckWinnerUseCase.execute(any()));
    });

    test('should handle draw game', () async {
      final GameState initialState = GameState(
        board: 3.createEmptyBoard(),
        currentPlayer: Player.o,
        status: GameStatus.playing,
      );
      final GameState updatedState = initialState.copyWith(
        board: <List<Player>>[
          <Player>[Player.x, Player.o, Player.x],
          <Player>[Player.o, Player.x, Player.o],
          <Player>[Player.o, Player.x, Player.o],
        ],
      );
      final GameState finalState = updatedState.copyWith(
        status: GameStatus.draw,
      );

      when(() => mockSelectAIMoveUseCase.execute(any(), any()))
          .thenReturn(updatedState);
      when(() => mockCheckWinnerUseCase.execute(any()))
          .thenReturn(finalState);

      final GameState result = await useCase.execute(initialState, GameConstants.aiEasyDifficulty);

      expect(result.status, equals(GameStatus.draw));
      verify(() => mockSelectAIMoveUseCase.execute(initialState, GameConstants.aiEasyDifficulty)).called(1);
      verify(() => mockCheckWinnerUseCase.execute(updatedState)).called(1);
    });

    test('should propagate errors from AI service', () async {
      final GameState initialState = GameState(
        board: 3.createEmptyBoard(),
        currentPlayer: Player.o,
        status: GameStatus.playing,
      );

      when(() => mockSelectAIMoveUseCase.execute(any(), any()))
          .thenThrow(Exception('AI move selection error'));

      await expectLater(
        useCase.execute(initialState, GameConstants.aiEasyDifficulty),
        throwsException,
      );
      verify(() => mockSelectAIMoveUseCase.execute(initialState, GameConstants.aiEasyDifficulty)).called(1);
      verifyNever(() => mockCheckWinnerUseCase.execute(any()));
    });
  });
}
