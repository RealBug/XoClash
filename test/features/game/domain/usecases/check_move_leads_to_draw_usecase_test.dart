import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/usecases/check_move_leads_to_draw_usecase.dart';

void main() {
  group('CheckMoveLeadsToDrawUseCase', () {
    late CheckMoveLeadsToDrawUseCase useCase;

    setUp(() {
      useCase = CheckMoveLeadsToDrawUseCase();
    });

    test('should return false when move leads to opponent win', () {
      final board = <List<Player>>[
        <Player>[Player.x, Player.o, Player.x],
        <Player>[Player.o, Player.x, Player.none],
        <Player>[Player.none, Player.none, Player.o],
      ];
      final gameState = GameState(board: board);

      final result = useCase.execute(gameState, <int>[2, 0]);

      expect(result, isFalse);
    });

    test('should return false when move allows opponent to win next', () {
      final board = <List<Player>>[
        <Player>[Player.x, Player.o, Player.none],
        <Player>[Player.o, Player.x, Player.none],
        <Player>[Player.none, Player.none, Player.none],
      ];
      final gameState = GameState(board: board);

      final result = useCase.execute(gameState, <int>[0, 2]);

      expect(result, isFalse);
    });

    test('should return true when only one move remains', () {
      final board = <List<Player>>[
        <Player>[Player.x, Player.o, Player.x],
        <Player>[Player.o, Player.x, Player.o],
        <Player>[Player.o, Player.x, Player.none],
      ];
      final gameState = GameState(board: board, currentPlayer: Player.o);

      final result = useCase.execute(gameState, <int>[2, 2]);

      expect(result, isTrue);
    });
  });
}

