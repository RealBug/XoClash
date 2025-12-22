import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/features/auth/presentation/screens/auth_screen.dart';
import '../../../../utils/widget_test_harness.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await setUpUiTestEnvironment();
  });

  testWidgets('AuthScreen builds and opens guest modal', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestApp(
        screen: const AuthScreen(),
      ),
    );
    await tester.pump();

    expect(find.byType(AuthScreen), findsOneWidget);

    final Finder guestButtonFinder = find.byIcon(Icons.person_outline);
    await tester.ensureVisible(guestButtonFinder);
    await tester.tap(guestButtonFinder, warnIfMissed: false);

    // Wait for modal animation (avoid pumpAndSettle timeout with infinite animations)
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();

    expect(find.byIcon(Icons.close), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
  });
}
