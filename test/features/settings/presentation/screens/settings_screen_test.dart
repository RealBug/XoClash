import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/features/settings/presentation/screens/settings_screen.dart';
import '../../../../utils/widget_test_harness.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await setUpUiTestEnvironment();
  });

  testWidgets('SettingsScreen builds (hideProfile=true)', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestApp(
        screen: const SettingsScreen(hideProfile: true),
      ),
    );
    await tester.pump();

    expect(find.byType(SettingsScreen), findsOneWidget);
    expect(find.byIcon(Icons.animation), findsOneWidget);
    expect(find.byIcon(Icons.graphic_eq), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  });
}
