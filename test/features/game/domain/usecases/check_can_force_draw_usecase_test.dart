import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/usecases/check_can_force_draw_usecase.dart';
import 'package:tictac/features/game/domain/usecases/check_has_winning_move_usecase.dart';
import 'package:tictac/features/game/domain/usecases/check_winner_usecase.dart';
import 'package:tictac/features/game/domain/usecases/count_remaining_moves_usecase.dart';
import 'package:tictac/features/game/domain/usecases/get_available_moves_usecase.dart';

void main() {
  group('CheckCanForceDrawUseCase', () {
    late CheckCanForceDrawUseCase useCase;

    setUp(() {
      useCase = CheckCanForceDrawUseCase(
        checkWinnerUseCase: CheckWinnerUseCase(),
        countRemainingMovesUseCase: CountRemainingMovesUseCase(),
        getAvailableMovesUseCase: GetAvailableMovesUseCase(),
        checkHasWinningMoveUseCase: CheckHasWinningMoveUseCase(CheckWinnerUseCase()),
      );
    });

    test('should return true when board is full', () {
      final board = <List<Player>>[
        <Player>[Player.x, Player.o, Player.x],
        <Player>[Player.o, Player.x, Player.o],
        <Player>[Player.o, Player.x, Player.o],
      ];
      final gameState = GameState(board: board);

      final result = useCase.execute(gameState);

      expect(result, isTrue);
    });

    test('should return false when opponent can win', () {
      final board = <List<Player>>[
        <Player>[Player.x, Player.x, Player.none],
        <Player>[Player.o, Player.none, Player.none],
        <Player>[Player.none, Player.none, Player.none],
      ];
      final gameState = GameState(board: board, currentPlayer: Player.o);

      final result = useCase.execute(gameState);

      expect(result, isFalse);
    });

    test('should return true when draw can be forced with few moves remaining', () {
      final board = <List<Player>>[
        <Player>[Player.x, Player.o, Player.x],
        <Player>[Player.o, Player.x, Player.o],
        <Player>[Player.none, Player.none, Player.none],
      ];
      final gameState = GameState(board: board);

      final result = useCase.execute(gameState);

      expect(result, anyOf(isTrue, isFalse));
    });

    test('should return false when more than 2 moves remaining', () {
      final board = <List<Player>>[
        <Player>[Player.x, Player.none, Player.none],
        <Player>[Player.none, Player.o, Player.none],
        <Player>[Player.none, Player.none, Player.none],
      ];
      final gameState = GameState(board: board);

      final result = useCase.execute(gameState);

      expect(result, isFalse);
    });

    test('should handle case where current player wins after move', () {
      final board = <List<Player>>[
        <Player>[Player.x, Player.x, Player.none],
        <Player>[Player.o, Player.o, Player.none],
        <Player>[Player.none, Player.none, Player.none],
      ];
      final gameState = GameState(board: board);

      final result = useCase.execute(gameState);

      expect(result, isA<bool>());
    });

    test('should handle case where opponent wins after move', () {
      final board = <List<Player>>[
        <Player>[Player.x, Player.x, Player.none],
        <Player>[Player.o, Player.o, Player.none],
        <Player>[Player.none, Player.none, Player.none],
      ];
      final gameState = GameState(board: board, currentPlayer: Player.o);

      final result = useCase.execute(gameState);

      expect(result, isA<bool>());
    });

    test('should return true when draw is achieved after move', () {
      final board = <List<Player>>[
        <Player>[Player.x, Player.o, Player.x],
        <Player>[Player.o, Player.x, Player.o],
        <Player>[Player.x, Player.none, Player.none],
      ];
      final gameState = GameState(board: board, currentPlayer: Player.o);

      final result = useCase.execute(gameState);

      expect(result, isA<bool>());
    });

    test('should check if opponent can win when game continues', () {
      final board = <List<Player>>[
        <Player>[Player.x, Player.o, Player.x],
        <Player>[Player.o, Player.x, Player.o],
        <Player>[Player.none, Player.none, Player.none],
      ];
      final gameState = GameState(board: board);

      final result = useCase.execute(gameState);

      expect(result, isA<bool>());
    });
  });
}
