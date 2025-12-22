import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictac/features/score/data/datasources/score_datasource.dart';
import 'package:tictac/features/score/domain/entities/player_score.dart';

void main() {
  late ScoreDataSourceImpl dataSource;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    dataSource = ScoreDataSourceImpl();
  });

  group('ScoreDataSourceImpl', () {
    test('should save and retrieve player score', () async {
      const PlayerScore score = PlayerScore(
        playerName: 'testPlayer',
        wins: 5,
        losses: 3,
        draws: 2,
        totalGames: 10,
      );

      await dataSource.savePlayerScore(score);
      final PlayerScore? result = await dataSource.getPlayerScore('testPlayer');

      expect(result, isNotNull);
      expect(result?.playerName, equals(score.playerName));
      expect(result?.wins, equals(score.wins));
      expect(result?.losses, equals(score.losses));
      expect(result?.draws, equals(score.draws));
      expect(result?.totalGames, equals(score.totalGames));
    });

    test('should return null for non-existent player', () async {
      final PlayerScore? result = await dataSource.getPlayerScore('nonExistent');

      expect(result, isNull);
    });

    test('should return all scores', () async {
      const PlayerScore score1 = PlayerScore(playerName: 'player1', wins: 5, losses: 2, draws: 1, totalGames: 8);
      const PlayerScore score2 = PlayerScore(playerName: 'player2', wins: 3, losses: 4, draws: 1, totalGames: 8);

      await dataSource.savePlayerScore(score1);
      await dataSource.savePlayerScore(score2);
      final List<PlayerScore> result = await dataSource.getAllScores();

      expect(result.length, equals(2));
      expect(result.any((PlayerScore s) => s.playerName == 'player1'), isTrue);
      expect(result.any((PlayerScore s) => s.playerName == 'player2'), isTrue);
    });

    test('should reset all scores', () async {
      const PlayerScore score = PlayerScore(playerName: 'player1', wins: 5, losses: 2, draws: 1, totalGames: 8);
      await dataSource.savePlayerScore(score);

      await dataSource.resetScores();
      final List<PlayerScore> result = await dataSource.getAllScores();

      expect(result, isEmpty);
    });
  });
}
