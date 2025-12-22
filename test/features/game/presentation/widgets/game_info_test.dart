import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/entities/game_state_extensions.dart';
import 'package:tictac/features/game/presentation/widgets/game_info.dart';
import '../../../../utils/widget_test_harness.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await setUpUiTestEnvironment();
  });

  group('GameInfo', () {
    testWidgets('renders game info with basic game state', (WidgetTester tester) async {
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        status: GameStatus.playing,
      );

      await tester.pumpWidget(
        buildTestApp(
          screen: Scaffold(
            body: GameInfo(
              gameState: gameState,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(GameInfo), findsOneWidget);
    });

    testWidgets('renders game info with player names', (WidgetTester tester) async {
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        status: GameStatus.playing,
        playerXName: 'Player X',
        playerOName: 'Player O',
      );

      await tester.pumpWidget(
        buildTestApp(
          screen: Scaffold(
            body: GameInfo(
              gameState: gameState,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(GameInfo), findsOneWidget);
    });

    testWidgets('renders game info when game is over', (WidgetTester tester) async {
      const GameState gameState = GameState(
        board: <List<Player>>[
          <Player>[Player.x, Player.x, Player.x],
          <Player>[Player.none, Player.none, Player.none],
          <Player>[Player.none, Player.none, Player.none],
        ],
        status: GameStatus.xWon,
      );

      await tester.pumpWidget(
        buildTestApp(
          screen: const Scaffold(
            body: GameInfo(
              gameState: gameState,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(GameInfo), findsOneWidget);
    });

    testWidgets('renders game info with offline computer mode', (WidgetTester tester) async {
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        status: GameStatus.playing,
        gameMode: GameModeType.offlineComputer,
        computerDifficulty: 1,
      );

      await tester.pumpWidget(
        buildTestApp(
          screen: Scaffold(
            body: GameInfo(
              gameState: gameState,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(GameInfo), findsOneWidget);
    });

    testWidgets('renders game info with offline friend mode', (WidgetTester tester) async {
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        status: GameStatus.playing,
        gameMode: GameModeType.offlineFriend,
        playerXName: 'Player X',
        playerOName: 'Player O',
      );

      await tester.pumpWidget(
        buildTestApp(
          screen: Scaffold(
            body: GameInfo(
              gameState: gameState,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(GameInfo), findsOneWidget);
    });
  });
}
