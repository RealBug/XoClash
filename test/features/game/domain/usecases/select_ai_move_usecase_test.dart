import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/core/constants/game_constants.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/entities/game_state_extensions.dart';
import 'package:tictac/features/game/domain/usecases/check_has_winning_move_usecase.dart';
import 'package:tictac/features/game/domain/usecases/check_move_leads_to_draw_usecase.dart';
import 'package:tictac/features/game/domain/usecases/get_available_moves_usecase.dart';
import 'package:tictac/features/game/domain/usecases/select_ai_move_usecase.dart';

class MockGetAvailableMovesUseCase extends Mock implements GetAvailableMovesUseCase {}
class MockCheckHasWinningMoveUseCase extends Mock implements CheckHasWinningMoveUseCase {}
class MockCheckMoveLeadsToDrawUseCase extends Mock implements CheckMoveLeadsToDrawUseCase {}

void main() {
  setUpAll(() {
    registerFallbackValue(GameState(board: 3.createEmptyBoard()));
    registerFallbackValue(Player.x);
  });

  group('SelectAIMoveUseCase', () {
    late SelectAIMoveUseCase useCase;
    late MockGetAvailableMovesUseCase mockGetAvailableMovesUseCase;
    late MockCheckHasWinningMoveUseCase mockCheckHasWinningMoveUseCase;
    late MockCheckMoveLeadsToDrawUseCase mockCheckMoveLeadsToDrawUseCase;

    setUp(() {
      mockGetAvailableMovesUseCase = MockGetAvailableMovesUseCase();
      mockCheckHasWinningMoveUseCase = MockCheckHasWinningMoveUseCase();
      mockCheckMoveLeadsToDrawUseCase = MockCheckMoveLeadsToDrawUseCase();
      useCase = SelectAIMoveUseCase(
        getAvailableMovesUseCase: mockGetAvailableMovesUseCase,
        checkHasWinningMoveUseCase: mockCheckHasWinningMoveUseCase,
        checkMoveLeadsToDrawUseCase: mockCheckMoveLeadsToDrawUseCase,
      );
    });

    test('should return same state when no moves available', () {
      final gameState = GameState(board: 3.createEmptyBoard());
      when(() => mockGetAvailableMovesUseCase.execute(any())).thenReturn(<List<int>>[]);

      final result = useCase.execute(gameState, GameConstants.aiEasyDifficulty);

      expect(result, equals(gameState));
      verify(() => mockGetAvailableMovesUseCase.execute(gameState.board)).called(1);
    });

    test('should select move and update board', () {
      final gameState = GameState(board: 3.createEmptyBoard());
      final availableMoves = <List<int>>[
        <int>[0, 0],
        <int>[1, 1],
      ];
      when(() => mockGetAvailableMovesUseCase.execute(any())).thenReturn(availableMoves);

      final result = useCase.execute(gameState, GameConstants.aiEasyDifficulty);

      expect(result.board, isNot(equals(gameState.board)));
      expect(result.currentPlayer, equals(gameState.currentPlayer));
      verify(() => mockGetAvailableMovesUseCase.execute(gameState.board)).called(1);
    });

    test('should place move for current player', () {
      final gameState = GameState(
        board: 3.createEmptyBoard(),
        currentPlayer: Player.o,
      );
      final availableMoves = <List<int>>[
        <int>[0, 0],
      ];
      when(() => mockGetAvailableMovesUseCase.execute(any())).thenReturn(availableMoves);

      final result = useCase.execute(gameState, GameConstants.aiEasyDifficulty);

      final hasOMove = result.board.any((row) => row.any((cell) => cell == Player.o));
      expect(hasOMove, isTrue);
    });

    test('should work with different difficulties', () {
      final gameState = GameState(board: 3.createEmptyBoard());
      final availableMoves = <List<int>>[
        <int>[0, 0],
        <int>[1, 1],
      ];
      when(() => mockGetAvailableMovesUseCase.execute(any())).thenReturn(availableMoves);
      when(() => mockCheckHasWinningMoveUseCase.execute(any(), any())).thenReturn(false);
      when(() => mockCheckMoveLeadsToDrawUseCase.execute(any(), any())).thenReturn(false);

      final resultEasy = useCase.execute(gameState, GameConstants.aiEasyDifficulty);
      final resultMedium = useCase.execute(gameState, GameConstants.aiMediumDifficulty);
      final resultHard = useCase.execute(gameState, GameConstants.aiHardDifficulty);

      expect(resultEasy.board, isNot(equals(gameState.board)));
      expect(resultMedium.board, isNot(equals(gameState.board)));
      expect(resultHard.board, isNot(equals(gameState.board)));
    });
  });
}
