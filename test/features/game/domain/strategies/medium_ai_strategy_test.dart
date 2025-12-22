import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/entities/game_state_extensions.dart';
import 'package:tictac/features/game/domain/strategies/medium_ai_strategy.dart';
import 'package:tictac/features/game/domain/usecases/check_has_winning_move_usecase.dart';
import 'package:tictac/features/game/domain/usecases/check_move_leads_to_draw_usecase.dart';

class MockRandom extends Mock implements math.Random {}
class MockCheckHasWinningMoveUseCase extends Mock implements CheckHasWinningMoveUseCase {}
class MockCheckMoveLeadsToDrawUseCase extends Mock implements CheckMoveLeadsToDrawUseCase {}

void main() {
  setUpAll(() {
    registerFallbackValue(Player.x);
    registerFallbackValue(
      GameState(board: 3.createEmptyBoard()),
    );
  });

  group('MediumAIStrategy', () {
    late MediumAIStrategy strategy;
    late MockRandom mockRandom;
    late MockCheckHasWinningMoveUseCase mockCheckHasWinningMoveUseCase;
    late MockCheckMoveLeadsToDrawUseCase mockCheckMoveLeadsToDrawUseCase;

    setUp(() {
      mockRandom = MockRandom();
      mockCheckHasWinningMoveUseCase = MockCheckHasWinningMoveUseCase();
      mockCheckMoveLeadsToDrawUseCase = MockCheckMoveLeadsToDrawUseCase();
      strategy = MediumAIStrategy(
        random: mockRandom,
        checkHasWinningMoveUseCase: mockCheckHasWinningMoveUseCase,
        checkMoveLeadsToDrawUseCase: mockCheckMoveLeadsToDrawUseCase,
      );
    });

    test('should block opponent winning move', () {
      final board = <List<Player>>[
        <Player>[Player.x, Player.x, Player.none],
        <Player>[Player.o, Player.none, Player.none],
        <Player>[Player.none, Player.none, Player.none],
      ];
      final gameState = GameState(board: board, currentPlayer: Player.o);
      final availableMoves = <List<int>>[
        <int>[0, 2],
        <int>[1, 1],
      ];

      when(() => mockCheckHasWinningMoveUseCase.execute(any(), any())).thenReturn(false);
      when(() => mockCheckHasWinningMoveUseCase.execute(any(), Player.x)).thenReturn(true);

      final move = strategy.selectMove(gameState, availableMoves);

      expect(move, equals(<int>[0, 2]));
    });

    test('should take winning move when probability allows', () {
      final board = <List<Player>>[
        <Player>[Player.o, Player.o, Player.none],
        <Player>[Player.x, Player.none, Player.none],
        <Player>[Player.none, Player.none, Player.none],
      ];
      final gameState = GameState(board: board, currentPlayer: Player.o);
      final availableMoves = <List<int>>[
        <int>[0, 2],
        <int>[1, 1],
      ];

      when(() => mockRandom.nextDouble()).thenReturn(0.8);
      when(() => mockRandom.nextInt(any())).thenReturn(0);
      when(() => mockCheckHasWinningMoveUseCase.execute(any(), any())).thenReturn(false);
      when(() => mockCheckHasWinningMoveUseCase.execute(any(), Player.o)).thenReturn(true);

      final move = strategy.selectMove(gameState, availableMoves);

      expect(move, equals(<int>[0, 2]));
    });

    test('should prefer draw when probability allows', () {
      final board = <List<Player>>[
        <Player>[Player.x, Player.o, Player.x],
        <Player>[Player.o, Player.x, Player.none],
        <Player>[Player.none, Player.none, Player.o],
      ];
      final gameState = GameState(board: board);
      final availableMoves = <List<int>>[
        <int>[1, 2],
        <int>[2, 0],
      ];

      when(() => mockRandom.nextDouble()).thenReturn(0.8);
      when(() => mockRandom.nextInt(any())).thenReturn(0);
      when(() => mockCheckHasWinningMoveUseCase.execute(any(), any())).thenReturn(false);
      when(() => mockCheckMoveLeadsToDrawUseCase.execute(any(), any())).thenReturn(false);
      when(() => mockCheckMoveLeadsToDrawUseCase.execute(any(), <int>[1, 2])).thenReturn(true);

      final move = strategy.selectMove(gameState, availableMoves);

      expect(move, equals(<int>[1, 2]));
    });
  });
}

