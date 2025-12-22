import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/features/home/presentation/screens/home_screen.dart';
import '../../../../utils/widget_test_harness.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await setUpUiTestEnvironment();
  });

  testWidgets('HomeScreen builds and shows settings button', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestApp(
        screen: const HomeScreen(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsWidgets);
  });
}
