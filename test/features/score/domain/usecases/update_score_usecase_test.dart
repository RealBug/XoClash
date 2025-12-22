import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/features/score/domain/entities/player_score.dart';
import 'package:tictac/features/score/domain/usecases/calculate_score_update_usecase.dart';
import 'package:tictac/features/score/domain/usecases/get_player_score_usecase.dart';
import 'package:tictac/features/score/domain/usecases/update_player_score_usecase.dart';
import 'package:tictac/features/score/domain/usecases/update_score_usecase.dart';

class MockGetPlayerScoreUseCase extends Mock implements GetPlayerScoreUseCase {}

class MockCalculateScoreUpdateUseCase extends Mock implements CalculateScoreUpdateUseCase {}

class MockUpdatePlayerScoreUseCase extends Mock implements UpdatePlayerScoreUseCase {}

void main() {
  setUpAll(() {
    registerFallbackValue(const PlayerScore(playerName: 'test-player'));
  });

  late UpdateScoreUseCase useCase;
  late MockGetPlayerScoreUseCase mockGetPlayerScoreUseCase;
  late MockCalculateScoreUpdateUseCase mockCalculateScoreUpdateUseCase;
  late MockUpdatePlayerScoreUseCase mockUpdatePlayerScoreUseCase;

  setUp(() {
    mockGetPlayerScoreUseCase = MockGetPlayerScoreUseCase();
    mockCalculateScoreUpdateUseCase = MockCalculateScoreUpdateUseCase();
    mockUpdatePlayerScoreUseCase = MockUpdatePlayerScoreUseCase();
    useCase = UpdateScoreUseCase(
      mockGetPlayerScoreUseCase,
      mockCalculateScoreUpdateUseCase,
      mockUpdatePlayerScoreUseCase,
    );
  });

  group('UpdateScoreUseCase', () {
    test('should update score for existing player', () async {
      const String playerName = 'player1';
      const PlayerScore currentScore = PlayerScore(playerName: playerName, wins: 5, losses: 2, draws: 1, totalGames: 8);
      const PlayerScore updatedScore = PlayerScore(playerName: playerName, wins: 6, losses: 2, draws: 1, totalGames: 9);

      when(() => mockGetPlayerScoreUseCase.execute(playerName))
          .thenAnswer((_) async => currentScore);
      when(() => mockCalculateScoreUpdateUseCase.execute(currentScore, playerName, true, false))
          .thenReturn(updatedScore);
      when(() => mockUpdatePlayerScoreUseCase.execute(updatedScore))
          .thenAnswer((_) async => Future<void>.value());

      await useCase.execute(playerName, true, false);

      verify(() => mockGetPlayerScoreUseCase.execute(playerName)).called(1);
      verify(() => mockCalculateScoreUpdateUseCase.execute(currentScore, playerName, true, false)).called(1);
      verify(() => mockUpdatePlayerScoreUseCase.execute(updatedScore)).called(1);
    });

    test('should create new score for new player', () async {
      const String playerName = 'newPlayer';
      const PlayerScore updatedScore = PlayerScore(playerName: playerName, wins: 1, totalGames: 1);

      when(() => mockGetPlayerScoreUseCase.execute(playerName))
          .thenAnswer((_) async => null);
      when(() => mockCalculateScoreUpdateUseCase.execute(null, playerName, true, false))
          .thenReturn(updatedScore);
      when(() => mockUpdatePlayerScoreUseCase.execute(updatedScore))
          .thenAnswer((_) async => Future<void>.value());

      await useCase.execute(playerName, true, false);

      verify(() => mockGetPlayerScoreUseCase.execute(playerName)).called(1);
      verify(() => mockCalculateScoreUpdateUseCase.execute(null, playerName, true, false)).called(1);
      verify(() => mockUpdatePlayerScoreUseCase.execute(updatedScore)).called(1);
    });

    test('should handle draw correctly', () async {
      const String playerName = 'player1';
      const PlayerScore currentScore = PlayerScore(playerName: playerName, wins: 5, losses: 2, draws: 1, totalGames: 8);
      const PlayerScore updatedScore = PlayerScore(playerName: playerName, wins: 5, losses: 2, draws: 2, totalGames: 9);

      when(() => mockGetPlayerScoreUseCase.execute(playerName))
          .thenAnswer((_) async => currentScore);
      when(() => mockCalculateScoreUpdateUseCase.execute(currentScore, playerName, false, true))
          .thenReturn(updatedScore);
      when(() => mockUpdatePlayerScoreUseCase.execute(updatedScore))
          .thenAnswer((_) async => Future<void>.value());

      await useCase.execute(playerName, false, true);

      verify(() => mockCalculateScoreUpdateUseCase.execute(currentScore, playerName, false, true)).called(1);
    });

    test('should propagate errors from getPlayerScoreUseCase', () async {
      const String playerName = 'player1';

      when(() => mockGetPlayerScoreUseCase.execute(playerName))
          .thenThrow(Exception('Error getting score'));

      expect(() => useCase.execute(playerName, true, false), throwsException);
    });
  });
}

