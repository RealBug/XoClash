import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/entities/game_state_extensions.dart';
import 'package:tictac/features/game/domain/usecases/count_remaining_moves_usecase.dart';

void main() {
  group('CountRemainingMovesUseCase', () {
    late CountRemainingMovesUseCase useCase;

    setUp(() {
      useCase = CountRemainingMovesUseCase();
    });

    test('should return 9 for empty 3x3 board', () {
      final board = 3.createEmptyBoard();
      final count = useCase.execute(board);

      expect(count, equals(9));
    });

    test('should return correct count for partially filled board', () {
      final board = <List<Player>>[
        <Player>[Player.x, Player.o, Player.none],
        <Player>[Player.none, Player.x, Player.none],
        <Player>[Player.none, Player.none, Player.none],
      ];
      final count = useCase.execute(board);

      expect(count, equals(6));
    });

    test('should return 0 when board is full', () {
      final board = <List<Player>>[
        <Player>[Player.x, Player.o, Player.x],
        <Player>[Player.o, Player.x, Player.o],
        <Player>[Player.o, Player.x, Player.o],
      ];
      final count = useCase.execute(board);

      expect(count, equals(0));
    });

    test('should work with different board sizes', () {
      final board = 4.createEmptyBoard();
      final count = useCase.execute(board);

      expect(count, equals(16));
    });
  });
}

