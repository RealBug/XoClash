import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/core/widgets/emojis/emoji_categories.dart';
import 'package:tictac/l10n/app_localizations.dart';

void main() {

  group('EmojiCategories', () {
    testWidgets('all() returns all categories', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const <Locale>[
            Locale('fr'),
            Locale('en'),
          ],
          home: Builder(
            builder: (BuildContext context) {
              final List<EmojiCategory> categories = EmojiCategories.all(context);
              expect(categories.length, greaterThan(0));
              expect(categories[0], isA<EmojiCategory>());
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('all() returns categories with correct structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const <Locale>[
            Locale('fr'),
            Locale('en'),
          ],
          home: Builder(
            builder: (BuildContext context) {
              final List<EmojiCategory> categories = EmojiCategories.all(context);
              for (final EmojiCategory category in categories) {
                expect(category.name, isNotEmpty);
                expect(category.icon, isNotEmpty);
                expect(category.emojis, isNotEmpty);
                expect(category.emojis.length, greaterThan(0));
              }
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('EmojiCategory has required properties', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const <Locale>[
            Locale('fr'),
            Locale('en'),
          ],
          home: Builder(
            builder: (BuildContext context) {
              final List<EmojiCategory> categories = EmojiCategories.all(context);
              if (categories.isNotEmpty) {
                final EmojiCategory category = categories[0];
                expect(category.name, isA<String>());
                expect(category.icon, isA<String>());
                expect(category.emojis, isA<List<String>>());
              }
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });
}

