import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/features/score/domain/entities/player_score.dart';
import 'package:tictac/features/score/domain/repositories/score_repository.dart';
import 'package:tictac/features/score/domain/usecases/get_player_score_usecase.dart';

class MockScoreRepository extends Mock implements ScoreRepository {}

void main() {
  late GetPlayerScoreUseCase useCase;
  late MockScoreRepository mockRepository;

  setUp(() {
    mockRepository = MockScoreRepository();
    useCase = GetPlayerScoreUseCase(mockRepository);
  });

  group('GetPlayerScoreUseCase', () {
    test('should return player score when repository returns score', () async {
      const String playerName = 'testPlayer';
      const PlayerScore expectedScore = PlayerScore(
        playerName: playerName,
        wins: 5,
        losses: 3,
        draws: 2,
        totalGames: 10,
      );

      when(() => mockRepository.getPlayerScore(playerName)).thenAnswer((_) async => expectedScore);

      final PlayerScore? result = await useCase.execute(playerName);

      expect(result, equals(expectedScore));
      verify(() => mockRepository.getPlayerScore(playerName)).called(1);
    });

    test('should return null when repository returns null', () async {
      const String playerName = 'nonExistentPlayer';

      when(() => mockRepository.getPlayerScore(playerName)).thenAnswer((_) async => null);

      final PlayerScore? result = await useCase.execute(playerName);

      expect(result, isNull);
      verify(() => mockRepository.getPlayerScore(playerName)).called(1);
    });
  });
}
