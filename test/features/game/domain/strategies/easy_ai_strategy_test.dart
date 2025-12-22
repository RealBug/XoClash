import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/entities/game_state_extensions.dart';
import 'package:tictac/features/game/domain/strategies/easy_ai_strategy.dart';

class MockRandom extends Mock implements math.Random {}

void main() {
  group('EasyAIStrategy', () {
    test('should select random move from available moves', () {
      final mockRandom = MockRandom();
      when(() => mockRandom.nextInt(any())).thenReturn(1);
      final strategy = EasyAIStrategy(random: mockRandom);
      final gameState = GameState(board: 3.createEmptyBoard());
      final availableMoves = <List<int>>[
        <int>[0, 0],
        <int>[1, 1],
        <int>[2, 2],
      ];

      final move = strategy.selectMove(gameState, availableMoves);

      expect(move, equals(<int>[1, 1]));
      verify(() => mockRandom.nextInt(3)).called(1);
    });

    test('should select first move when random returns 0', () {
      final mockRandom = MockRandom();
      when(() => mockRandom.nextInt(any())).thenReturn(0);
      final strategy = EasyAIStrategy(random: mockRandom);
      final gameState = GameState(board: 3.createEmptyBoard());
      final availableMoves = <List<int>>[
        <int>[0, 0],
        <int>[1, 1],
      ];

      final move = strategy.selectMove(gameState, availableMoves);

      expect(move, equals(<int>[0, 0]));
    });

    test('should work with single available move', () {
      final strategy = EasyAIStrategy();
      final gameState = GameState(board: 3.createEmptyBoard());
      final availableMoves = <List<int>>[
        <int>[2, 2],
      ];

      final move = strategy.selectMove(gameState, availableMoves);

      expect(move, equals(<int>[2, 2]));
    });
  });
}

