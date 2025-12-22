import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/features/score/presentation/providers/session_scores_provider.dart';

void main() {
  group('SessionScoresNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('build() returns empty map initially', () {
      final Map<String, SessionScore> state = container.read(sessionScoresProvider);
      expect(state, isEmpty);
    });

    group('updateScore', () {
      test('creates new score for new player on win', () {
        final SessionScoresNotifier notifier = container.read(sessionScoresProvider.notifier);
        notifier.updateScore('Player1', true, false);

        final SessionScore? score = container.read(sessionScoresProvider)['Player1'];
        expect(score, isNotNull);
        expect(score!.playerName, 'Player1');
        expect(score.wins, 1);
        expect(score.losses, 0);
        expect(score.draws, 0);
        expect(score.totalGames, 1);
      });

      test('creates new score for new player on loss', () {
        final SessionScoresNotifier notifier = container.read(sessionScoresProvider.notifier);
        notifier.updateScore('Player1', false, false);

        final SessionScore? score = container.read(sessionScoresProvider)['Player1'];
        expect(score, isNotNull);
        expect(score!.wins, 0);
        expect(score.losses, 1);
        expect(score.draws, 0);
      });

      test('creates new score for new player on draw', () {
        final SessionScoresNotifier notifier = container.read(sessionScoresProvider.notifier);
        notifier.updateScore('Player1', false, true);

        final SessionScore? score = container.read(sessionScoresProvider)['Player1'];
        expect(score, isNotNull);
        expect(score!.wins, 0);
        expect(score.losses, 0);
        expect(score.draws, 1);
      });

      test('updates existing score on win', () {
        final SessionScoresNotifier notifier = container.read(sessionScoresProvider.notifier);
        notifier.updateScore('Player1', true, false);
        notifier.updateScore('Player1', true, false);

        final SessionScore? score = container.read(sessionScoresProvider)['Player1'];
        expect(score!.wins, 2);
        expect(score.losses, 0);
        expect(score.draws, 0);
        expect(score.totalGames, 2);
      });

      test('updates existing score on loss', () {
        final SessionScoresNotifier notifier = container.read(sessionScoresProvider.notifier);
        notifier.updateScore('Player1', true, false);
        notifier.updateScore('Player1', false, false);

        final SessionScore? score = container.read(sessionScoresProvider)['Player1'];
        expect(score!.wins, 1);
        expect(score.losses, 1);
        expect(score.draws, 0);
      });

      test('updates existing score on draw', () {
        final SessionScoresNotifier notifier = container.read(sessionScoresProvider.notifier);
        notifier.updateScore('Player1', true, false);
        notifier.updateScore('Player1', false, true);

        final SessionScore? score = container.read(sessionScoresProvider)['Player1'];
        expect(score!.wins, 1);
        expect(score.losses, 0);
        expect(score.draws, 1);
      });

      test('handles multiple players independently', () {
        final SessionScoresNotifier notifier = container.read(sessionScoresProvider.notifier);
        notifier.updateScore('Player1', true, false);
        notifier.updateScore('Player2', false, false);
        notifier.updateScore('Player1', false, true);

        final SessionScore? score1 = container.read(sessionScoresProvider)['Player1'];
        final SessionScore? score2 = container.read(sessionScoresProvider)['Player2'];

        expect(score1!.wins, 1);
        expect(score1.draws, 1);
        expect(score2!.losses, 1);
      });
    });

    group('getPlayerScore', () {
      test('returns null for non-existent player', () {
        final SessionScoresNotifier notifier = container.read(sessionScoresProvider.notifier);
        final SessionScore? score = notifier.getPlayerScore('NonExistent');
        expect(score, isNull);
      });

      test('returns score for existing player', () {
        final SessionScoresNotifier notifier = container.read(sessionScoresProvider.notifier);
        notifier.updateScore('Player1', true, false);

        final SessionScore? score = notifier.getPlayerScore('Player1');
        expect(score, isNotNull);
        expect(score!.playerName, 'Player1');
        expect(score.wins, 1);
      });
    });

    group('migrateScore', () {
      test('migrates score from old name to new name', () {
        final SessionScoresNotifier notifier = container.read(sessionScoresProvider.notifier);
        notifier.updateScore('OldName', true, false);
        notifier.updateScore('OldName', false, false);

        notifier.migrateScore('OldName', 'NewName');

        final SessionScore? oldScore = notifier.getPlayerScore('OldName');
        final SessionScore? newScore = notifier.getPlayerScore('NewName');

        expect(oldScore, isNull);
        expect(newScore, isNotNull);
        expect(newScore!.playerName, 'NewName');
        expect(newScore.wins, 1);
        expect(newScore.losses, 1);
      });

      test('does nothing when old name does not exist', () {
        final SessionScoresNotifier notifier = container.read(sessionScoresProvider.notifier);
        notifier.migrateScore('NonExistent', 'NewName');

        final SessionScore? newScore = notifier.getPlayerScore('NewName');
        expect(newScore, isNull);
      });

      test('preserves other players when migrating', () {
        final SessionScoresNotifier notifier = container.read(sessionScoresProvider.notifier);
        notifier.updateScore('Player1', true, false);
        notifier.updateScore('Player2', false, false);

        notifier.migrateScore('Player1', 'NewName');

        final SessionScore? player2Score = notifier.getPlayerScore('Player2');
        expect(player2Score, isNotNull);
        expect(player2Score!.losses, 1);
      });
    });

    group('reset', () {
      test('clears all scores', () {
        final SessionScoresNotifier notifier = container.read(sessionScoresProvider.notifier);
        notifier.updateScore('Player1', true, false);
        notifier.updateScore('Player2', false, false);

        notifier.reset();

        final Map<String, SessionScore> state = container.read(sessionScoresProvider);
        expect(state, isEmpty);
      });

      test('can update scores after reset', () {
        final SessionScoresNotifier notifier = container.read(sessionScoresProvider.notifier);
        notifier.updateScore('Player1', true, false);
        notifier.reset();
        notifier.updateScore('Player1', false, false);

        final SessionScore? score = notifier.getPlayerScore('Player1');
        expect(score, isNotNull);
        expect(score!.losses, 1);
        expect(score.wins, 0);
      });
    });
  });
}


