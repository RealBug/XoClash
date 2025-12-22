import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/core/providers/service_providers.dart';
import 'package:tictac/core/services/audio_service.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/entities/game_state_extensions.dart';
import 'package:tictac/features/game/presentation/providers/game_providers.dart';
import 'package:tictac/features/home/presentation/widgets/join_game_section.dart';
import 'package:tictac/features/settings/domain/entities/settings.dart';
import 'package:tictac/features/settings/presentation/providers/settings_providers.dart';
import 'package:tictac/l10n/app_localizations.dart';

class MockAudioService extends Mock implements AudioService {}

class FakeSettingsNotifier extends SettingsNotifier {
  FakeSettingsNotifier(this._settings);

  final Settings _settings;

  @override
  Future<Settings> build() async => _settings;
}

class FakeGameStateNotifier extends GameStateNotifier {
  FakeGameStateNotifier(this._initialState);

  final GameState _initialState;

  @override
  GameState build() => _initialState;
}

class FakeJoinGameUINotifier extends JoinGameUINotifier {
  FakeJoinGameUINotifier(this._initialState);

  JoinGameUIState _initialState;

  @override
  JoinGameUIState build() => _initialState;

  @override
  void clearError() {
    _initialState = _initialState.copyWith(error: () => null);
    state = _initialState;
  }
}

void main() {
  group('JoinGameSection', () {
    late TextEditingController gameIdController;
    late FocusNode gameIdFocusNode;
    late MockAudioService mockAudioService;

    setUp(() {
      gameIdController = TextEditingController();
      gameIdFocusNode = FocusNode();
      mockAudioService = MockAudioService();
      when(() => mockAudioService.playMoveSound()).thenAnswer((_) async => <dynamic, dynamic>{});
    });

    tearDown(() {
      gameIdController.dispose();
      gameIdFocusNode.dispose();
    });

    Widget createWidget() {
      return ProviderScope(
        overrides: [
          settingsProvider
              .overrideWith(() => FakeSettingsNotifier(const Settings())),
          audioServiceProvider.overrideWithValue(mockAudioService),
          gameStateProvider.overrideWith(
            () => FakeGameStateNotifier(
              GameState(
                board: 3.createEmptyBoard(),
                status: GameStatus.playing,
              ),
            ),
          ),
        ],
        child: MaterialApp(
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
          home: Scaffold(
            body: JoinGameSection(
              gameIdController: gameIdController,
              gameIdFocusNode: gameIdFocusNode,
              onGameIdChanged: () {},
            ),
          ),
        ),
      );
    }

    testWidgets('displays join game section with text field', (WidgetTester tester) async {
      await tester.pumpWidget(createWidget());
      await tester.pump();

      expect(find.textContaining('Join'), findsWidgets);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('shows clear button when text is entered', (WidgetTester tester) async {
      await tester.pumpWidget(createWidget());

      await tester.enterText(find.byType(TextField), 'ABC123');
      await tester.pump();

      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('clears text when clear button is pressed', (WidgetTester tester) async {
      await tester.pumpWidget(createWidget());

      await tester.enterText(find.byType(TextField), 'ABC123');
      await tester.pump();

      await tester.tap(find.byIcon(Icons.clear));
      await tester.pump();

      expect(gameIdController.text, isEmpty);
    });

    testWidgets('disables join button when game ID is invalid', (WidgetTester tester) async {
      await tester.pumpWidget(createWidget());

      await tester.enterText(find.byType(TextField), 'ABC');
      await tester.pump();

      final ElevatedButton button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('enables join button when game ID is valid', (WidgetTester tester) async {
      await tester.pumpWidget(createWidget());

      await tester.enterText(find.byType(TextField), 'ABCD23');
      await tester.pump();

      final ElevatedButton button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('shows error message when join game fails', (WidgetTester tester) async {
      final FakeJoinGameUINotifier notifier = FakeJoinGameUINotifier(
        const JoinGameUIState(error: 'Game not found'),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingsProvider
                .overrideWith(() => FakeSettingsNotifier(const Settings())),
            audioServiceProvider.overrideWithValue(mockAudioService),
            gameStateProvider.overrideWith(
              () => GameStateNotifier()
                ..state = GameState(
                  board: 3.createEmptyBoard(),
                  status: GameStatus.playing,
                ),
            ),
            joinGameUIStateProvider.overrideWith(() => notifier),
          ],
          child: MaterialApp(
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
            home: Scaffold(
              body: JoinGameSection(
                gameIdController: gameIdController,
                gameIdFocusNode: gameIdFocusNode,
                onGameIdChanged: () {},
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.textContaining('Game not found'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('hides error message when clear error button is pressed',
        (WidgetTester tester) async {
      final FakeJoinGameUINotifier notifier = FakeJoinGameUINotifier(
        const JoinGameUIState(error: 'Test error'),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingsProvider
                .overrideWith(() => FakeSettingsNotifier(const Settings())),
            audioServiceProvider.overrideWithValue(mockAudioService),
            gameStateProvider.overrideWith(
              () => GameStateNotifier()
                ..state = GameState(
                  board: 3.createEmptyBoard(),
                  status: GameStatus.playing,
                ),
            ),
            joinGameUIStateProvider.overrideWith(() => notifier),
          ],
          child: MaterialApp(
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
            home: Scaffold(
              body: JoinGameSection(
                gameIdController: gameIdController,
                gameIdFocusNode: gameIdFocusNode,
                onGameIdChanged: () {},
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.byIcon(Icons.error_outline), findsOneWidget);

      final Finder closeButton = find.byIcon(Icons.close);
      expect(closeButton, findsOneWidget);
      await tester.tap(closeButton);

      // Wait for all animations and state updates to settle
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.error_outline), findsNothing);
    });

    testWidgets('formats input to uppercase and valid characters',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidget());

      await tester.enterText(find.byType(TextField), 'abc234');
      await tester.pump();

      expect(gameIdController.text, 'ABC234');
    });

    testWidgets('limits input to game ID length', (WidgetTester tester) async {
      await tester.pumpWidget(createWidget());

      final String longText = 'A' * 10;
      await tester.enterText(find.byType(TextField), longText);
      await tester.pump();

      expect(gameIdController.text.length, lessThanOrEqualTo(6));
    });
  });
}
