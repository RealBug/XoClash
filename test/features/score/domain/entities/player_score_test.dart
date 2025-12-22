import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/features/score/domain/entities/player_score.dart';

void main() {
  group('PlayerScore', () {
    test('should create PlayerScore with default values', () {
      const PlayerScore score = PlayerScore(playerName: 'Player1');

      expect(score.playerName, 'Player1');
      expect(score.wins, 0);
      expect(score.losses, 0);
      expect(score.draws, 0);
      expect(score.totalGames, 0);
    });

    test('should create PlayerScore with custom values', () {
      const PlayerScore score = PlayerScore(
        playerName: 'Player1',
        wins: 10,
        losses: 5,
        draws: 3,
        totalGames: 18,
      );

      expect(score.playerName, 'Player1');
      expect(score.wins, 10);
      expect(score.losses, 5);
      expect(score.draws, 3);
      expect(score.totalGames, 18);
    });

    test('copyWith should update properties', () {
      const PlayerScore score = PlayerScore(
        playerName: 'Player1',
        wins: 10,
        losses: 5,
        draws: 3,
        totalGames: 18,
      );

      final PlayerScore updated = score.copyWith(
        wins: 15,
        totalGames: 20,
      );

      expect(updated.playerName, 'Player1');
      expect(updated.wins, 15);
      expect(updated.losses, 5);
      expect(updated.draws, 3);
      expect(updated.totalGames, 20);
    });

    test('copyWith should keep original values when null', () {
      const PlayerScore score = PlayerScore(
        playerName: 'Player1',
        wins: 10,
        losses: 5,
      );

      final PlayerScore updated = score.copyWith();

      expect(updated.playerName, 'Player1');
      expect(updated.wins, 10);
      expect(updated.losses, 5);
      expect(updated.draws, 0);
      expect(updated.totalGames, 0);
    });

    test('winRate should return 0.0 when totalGames is 0', () {
      const PlayerScore score = PlayerScore(playerName: 'Player1');

      expect(score.winRate, 0.0);
    });

    test('winRate should calculate correctly', () {
      const PlayerScore score = PlayerScore(
        playerName: 'Player1',
        wins: 10,
        totalGames: 20,
      );

      expect(score.winRate, 0.5);
    });

    test('winRate should return 1.0 when all games are wins', () {
      const PlayerScore score = PlayerScore(
        playerName: 'Player1',
        wins: 10,
        totalGames: 10,
      );

      expect(score.winRate, 1.0);
    });

    test('winRate should return 0.0 when no wins', () {
      const PlayerScore score = PlayerScore(
        playerName: 'Player1',
        losses: 10,
        totalGames: 10,
      );

      expect(score.winRate, 0.0);
    });

    test('should be equal when properties are equal', () {
      const PlayerScore score1 = PlayerScore(
        playerName: 'Player1',
        wins: 10,
        losses: 5,
        draws: 3,
        totalGames: 18,
      );

      const PlayerScore score2 = PlayerScore(
        playerName: 'Player1',
        wins: 10,
        losses: 5,
        draws: 3,
        totalGames: 18,
      );

      expect(score1, score2);
    });
  });
}


