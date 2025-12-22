import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/presentation/widgets/game_board.dart';
import '../../../../utils/widget_test_harness.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await setUpUiTestEnvironment();
  });

  testWidgets('GameBoard calls onCellTap for an empty cell', (WidgetTester tester) async {
    bool tapped = false;

    const GameState gameState = GameState(
      board: <List<Player>>[
        <Player>[Player.none, Player.none, Player.none],
        <Player>[Player.none, Player.none, Player.none],
        <Player>[Player.none, Player.none, Player.none],
      ],
      status: GameStatus.playing,
    );

    await tester.pumpWidget(
      buildTestApp(
        screen: Scaffold(
          body: Center(
            child: SizedBox(
              width: 320,
              height: 320,
              child: GameBoard(
                gameState: gameState,
                animationsEnabled: false,
                onCellTap: (int row, int col) {
                  if (row == 0 && col == 0) {
                    tapped = true;
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey<String>('cell_0_0_0')));
    await tester.pumpAndSettle();

    expect(tapped, isTrue);
  });
}
