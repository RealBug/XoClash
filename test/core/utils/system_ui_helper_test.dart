import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/core/utils/system_ui_helper.dart';

void main() {
  group('SystemUIHelper', () {
    testWidgets('setStatusBarStyle should set status bar style for dark mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              SystemUIHelper.setStatusBarStyle(context, true);
              return const Scaffold(body: SizedBox());
            },
          ),
        ),
      );

      final SystemUiOverlayStyle? overlayStyle = SystemChrome.latestStyle;
      expect(overlayStyle?.statusBarIconBrightness, equals(Brightness.light));
      expect(overlayStyle?.statusBarBrightness, equals(Brightness.dark));
    });

    testWidgets('setStatusBarStyle should set status bar style for light mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              SystemUIHelper.setStatusBarStyle(context, false);
              return const Scaffold(body: SizedBox());
            },
          ),
        ),
      );

      final SystemUiOverlayStyle? overlayStyle = SystemChrome.latestStyle;
      expect(overlayStyle?.statusBarIconBrightness, equals(Brightness.dark));
      expect(overlayStyle?.statusBarBrightness, equals(Brightness.light));
    });

    testWidgets('setStatusBarStyleCustom should set custom status bar style', (WidgetTester tester) async {
      const MaterialColor customColor = Colors.red;
      const Brightness customIconBrightness = Brightness.light;
      const Brightness customBrightness = Brightness.dark;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              SystemUIHelper.setStatusBarStyleCustom(
                context: context,
                statusBarColor: customColor,
                statusBarIconBrightness: customIconBrightness,
                statusBarBrightness: customBrightness,
              );
              return const Scaffold(body: SizedBox());
            },
          ),
        ),
      );

      final SystemUiOverlayStyle? overlayStyle = SystemChrome.latestStyle;
      expect(overlayStyle?.statusBarColor, equals(customColor));
      expect(overlayStyle?.statusBarIconBrightness, equals(customIconBrightness));
      expect(overlayStyle?.statusBarBrightness, equals(customBrightness));
    });
  });
}
