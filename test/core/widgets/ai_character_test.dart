import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/core/constants/game_constants.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/widgets/ai/ai_character.dart';
import 'package:tictac/l10n/app_localizations.dart';

void main() {
  group('AICharacter', () {
    test('getCharacter returns Easy character for difficulty 1', () {
      final AICharacter character =
          AICharacter.getCharacter(GameConstants.aiEasyDifficulty);
      expect(character.difficulty, GameConstants.aiEasyDifficulty);
      expect(character.emoji, '🌱');
    });

    test('getCharacter returns Medium character for difficulty 2', () {
      final AICharacter character =
          AICharacter.getCharacter(GameConstants.aiMediumDifficulty);
      expect(character.difficulty, GameConstants.aiMediumDifficulty);
      expect(character.emoji, '⚡');
    });

    test('getCharacter returns Hard character for difficulty 3', () {
      final AICharacter character =
          AICharacter.getCharacter(GameConstants.aiHardDifficulty);
      expect(character.difficulty, GameConstants.aiHardDifficulty);
      expect(character.emoji, '👑');
    });

    test('getCharacter returns Easy character for unknown difficulty', () {
      final AICharacter character = AICharacter.getCharacter(999);
      expect(character.difficulty, GameConstants.aiEasyDifficulty);
    });

    testWidgets('getDisplayName returns localized name', (WidgetTester tester) async {
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
              final AICharacter character =
                  AICharacter.getCharacter(GameConstants.aiEasyDifficulty);
              final String displayName = character.getDisplayName(context);
              expect(displayName, isNotEmpty);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('getSubtitle returns localized subtitle', (WidgetTester tester) async {
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
              final AICharacter character =
                  AICharacter.getCharacter(GameConstants.aiEasyDifficulty);
              final String subtitle = character.getSubtitle(context);
              expect(subtitle, isNotEmpty);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    test('AICharacter has required properties', () {
      const AICharacter character = AICharacter(
        name: 'Test',
        emoji: '🎮',
        color: AppTheme.blueAccent,
        difficulty: 1,
      );
      expect(character.name, 'Test');
      expect(character.emoji, '🎮');
      expect(character.color, AppTheme.blueAccent);
      expect(character.difficulty, 1);
    });

    test('getComputerPlayerId returns correct player ID', () {
      expect(
        AICharacter.getComputerPlayerId(GameConstants.aiEasyDifficulty),
        isNotEmpty,
      );
      expect(
        AICharacter.getComputerPlayerId(GameConstants.aiMediumDifficulty),
        isNotEmpty,
      );
      expect(
        AICharacter.getComputerPlayerId(GameConstants.aiHardDifficulty),
        isNotEmpty,
      );
      expect(AICharacter.getComputerPlayerId(999), isNotEmpty);
    });
  });
}
