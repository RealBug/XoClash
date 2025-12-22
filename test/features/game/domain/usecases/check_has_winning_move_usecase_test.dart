import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/usecases/check_has_winning_move_usecase.dart';

void main() {
  group('CheckHasWinningMoveUseCase', () {
    late CheckHasWinningMoveUseCase useCase;

    setUp(() {
      useCase = CheckHasWinningMoveUseCase();
    });

    test('should return true when X has already won', () {
      final board = <List<Player>>[
        <Player>[Player.x, Player.x, Player.x],
        <Player>[Player.o, Player.none, Player.none],
        <Player>[Player.none, Player.none, Player.none],
      ];

      final result = useCase.execute(board, Player.x);

      expect(result, isTrue);
    });

    test('should return true when O has already won', () {
      final board = <List<Player>>[
        <Player>[Player.o, Player.o, Player.o],
        <Player>[Player.x, Player.none, Player.none],
        <Player>[Player.none, Player.none, Player.none],
      ];

      final result = useCase.execute(board, Player.o);

      expect(result, isTrue);
    });

    test('should return false when no winning move', () {
      final board = <List<Player>>[
        <Player>[Player.x, Player.o, Player.none],
        <Player>[Player.o, Player.x, Player.none],
        <Player>[Player.none, Player.none, Player.none],
      ];

      final result = useCase.execute(board, Player.x);

      expect(result, isFalse);
    });

    test('should return false when board is full', () {
      final board = <List<Player>>[
        <Player>[Player.x, Player.o, Player.x],
        <Player>[Player.o, Player.x, Player.o],
        <Player>[Player.o, Player.x, Player.o],
      ];

      final result = useCase.execute(board, Player.x);

      expect(result, isFalse);
    });
  });
}

