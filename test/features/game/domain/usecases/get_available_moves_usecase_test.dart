import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/entities/game_state_extensions.dart';
import 'package:tictac/features/game/domain/usecases/get_available_moves_usecase.dart';

void main() {
  group('GetAvailableMovesUseCase', () {
    late GetAvailableMovesUseCase useCase;

    setUp(() {
      useCase = GetAvailableMovesUseCase();
    });

    test('should return all empty cells on empty board', () {
      final board = 3.createEmptyBoard();
      final moves = useCase.execute(board);

      expect(moves.length, equals(9));
    });

    test('should return only empty cells on partially filled board', () {
      final board = <List<Player>>[
        <Player>[Player.x, Player.o, Player.none],
        <Player>[Player.none, Player.x, Player.none],
        <Player>[Player.none, Player.none, Player.none],
      ];
      final moves = useCase.execute(board);

      expect(moves.length, equals(6));
      expect(moves.any((move) => move[0] == 0 && move[1] == 2), isTrue);
      expect(moves.any((move) => move[0] == 1 && move[1] == 0), isTrue);
      expect(moves.any((move) => move[0] == 1 && move[1] == 2), isTrue);
      expect(moves.any((move) => move[0] == 2 && move[1] == 0), isTrue);
      expect(moves.any((move) => move[0] == 2 && move[1] == 1), isTrue);
      expect(moves.any((move) => move[0] == 2 && move[1] == 2), isTrue);
    });

    test('should return empty list when board is full', () {
      final board = <List<Player>>[
        <Player>[Player.x, Player.o, Player.x],
        <Player>[Player.o, Player.x, Player.o],
        <Player>[Player.o, Player.x, Player.o],
      ];
      final moves = useCase.execute(board);

      expect(moves.length, equals(0));
    });

    test('should work with different board sizes', () {
      final board = 4.createEmptyBoard();
      final moves = useCase.execute(board);

      expect(moves.length, equals(16));
    });
  });
}

