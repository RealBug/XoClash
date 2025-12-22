import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/features/score/data/datasources/score_datasource.dart';
import 'package:tictac/features/score/data/repositories/score_repository_impl.dart';
import 'package:tictac/features/score/domain/entities/player_score.dart';

class MockScoreDataSource extends Mock implements ScoreDataSource {}

void main() {
  late ScoreRepositoryImpl repository;
  late MockScoreDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockScoreDataSource();
    repository = ScoreRepositoryImpl(dataSource: mockDataSource);
  });

  group('ScoreRepositoryImpl', () {
    test('should get player score', () async {
      const PlayerScore score = PlayerScore(
        playerName: 'testPlayer',
        wins: 5,
        losses: 3,
        draws: 2,
        totalGames: 10,
      );

      when(() => mockDataSource.getPlayerScore('testPlayer'))
          .thenAnswer((_) async => score);

      final PlayerScore? result = await repository.getPlayerScore('testPlayer');

      expect(result, score);
      verify(() => mockDataSource.getPlayerScore('testPlayer')).called(1);
    });

    test('should return null when player score does not exist', () async {
      when(() => mockDataSource.getPlayerScore('nonExistent'))
          .thenAnswer((_) async => null);

      final PlayerScore? result = await repository.getPlayerScore('nonExistent');

      expect(result, isNull);
      verify(() => mockDataSource.getPlayerScore('nonExistent')).called(1);
    });

    test('should update player score', () async {
      const PlayerScore score = PlayerScore(
        playerName: 'testPlayer',
        wins: 6,
        losses: 3,
        draws: 2,
        totalGames: 11,
      );

      when(() => mockDataSource.savePlayerScore(score))
          .thenAnswer((_) async => <dynamic, dynamic>{});

      await repository.updatePlayerScore(score);

      verify(() => mockDataSource.savePlayerScore(score)).called(1);
    });

    test('should get all scores', () async {
      final List<PlayerScore> scores = <PlayerScore>[
        const PlayerScore(playerName: 'player1', wins: 5, losses: 2),
        const PlayerScore(playerName: 'player2', wins: 3, losses: 4),
      ];

      when(() => mockDataSource.getAllScores())
          .thenAnswer((_) async => scores);

      final List<PlayerScore> result = await repository.getAllScores();

      expect(result, scores);
      verify(() => mockDataSource.getAllScores()).called(1);
    });

    test('should reset scores', () async {
      when(() => mockDataSource.resetScores())
          .thenAnswer((_) async => <dynamic, dynamic>{});

      await repository.resetScores();

      verify(() => mockDataSource.resetScores()).called(1);
    });
  });
}


