import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/core/providers/service_providers.dart';
import 'package:tictac/features/score/domain/entities/player_score.dart';
import 'package:tictac/features/score/domain/repositories/score_repository.dart';
import 'package:tictac/features/score/domain/usecases/calculate_score_update_usecase.dart';
import 'package:tictac/features/score/domain/usecases/get_all_scores_usecase.dart';
import 'package:tictac/features/score/domain/usecases/get_player_score_usecase.dart';
import 'package:tictac/features/score/domain/usecases/reset_scores_usecase.dart';
import 'package:tictac/features/score/domain/usecases/update_player_score_usecase.dart';
import 'package:tictac/features/score/domain/usecases/update_score_usecase.dart';
import 'package:tictac/features/score/presentation/providers/score_providers.dart';


class MockGetAllScoresUseCase extends Mock implements GetAllScoresUseCase {}

class MockGetPlayerScoreUseCase extends Mock implements GetPlayerScoreUseCase {}

class MockUpdatePlayerScoreUseCase extends Mock
    implements UpdatePlayerScoreUseCase {}

class MockCalculateScoreUpdateUseCase extends Mock
    implements CalculateScoreUpdateUseCase {}

class MockResetScoresUseCase extends Mock implements ResetScoresUseCase {}

class MockUpdateScoreUseCase extends Mock implements UpdateScoreUseCase {}

class MockScoreRepository extends Mock implements ScoreRepository {}

void setUpAllFallbacks() {
  registerFallbackValue(
    const PlayerScore(
      playerName: 'test-player',
    ),
  );
}

void main() {
  setUpAll(() {
    setUpAllFallbacks();
  });

  late MockGetAllScoresUseCase mockGetAllScoresUseCase;
  late MockGetPlayerScoreUseCase mockGetPlayerScoreUseCase;
  late MockUpdatePlayerScoreUseCase mockUpdatePlayerScoreUseCase;
  late MockCalculateScoreUpdateUseCase mockCalculateScoreUpdateUseCase;
  late MockResetScoresUseCase mockResetScoresUseCase;
  late MockUpdateScoreUseCase mockUpdateScoreUseCase;
  late MockScoreRepository mockScoreRepository;
  late ProviderContainer container;

  setUp(() {
    mockGetAllScoresUseCase = MockGetAllScoresUseCase();
    mockGetPlayerScoreUseCase = MockGetPlayerScoreUseCase();
    mockUpdatePlayerScoreUseCase = MockUpdatePlayerScoreUseCase();
    mockCalculateScoreUpdateUseCase = MockCalculateScoreUpdateUseCase();
    mockResetScoresUseCase = MockResetScoresUseCase();
    mockUpdateScoreUseCase = MockUpdateScoreUseCase();
    mockScoreRepository = MockScoreRepository();

    when(() => mockGetAllScoresUseCase.execute()).thenAnswer((_) async => <PlayerScore>[]);
    when(() => mockResetScoresUseCase.execute()).thenAnswer((_) async => Future<void>.value());
    when(() => mockUpdateScoreUseCase.execute(any(), any(), any()))
        .thenAnswer((_) async => Future<void>.value());

    container = ProviderContainer(
      overrides: [
        getAllScoresUseCaseProvider.overrideWithValue(mockGetAllScoresUseCase),
        getPlayerScoreUseCaseProvider
            .overrideWithValue(mockGetPlayerScoreUseCase),
        updatePlayerScoreUseCaseProvider
            .overrideWithValue(mockUpdatePlayerScoreUseCase),
        calculateScoreUpdateUseCaseProvider
            .overrideWithValue(mockCalculateScoreUpdateUseCase),
        resetScoresUseCaseProvider.overrideWithValue(mockResetScoresUseCase),
        updateScoreUseCaseProvider.overrideWithValue(mockUpdateScoreUseCase),
        scoreRepositoryProvider.overrideWithValue(mockScoreRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('ScoresNotifier', () {
    test('build() returns empty list initially and loads scores', () async {
      final List<PlayerScore> scores = <PlayerScore>[];

      when(() => mockGetAllScoresUseCase.execute())
          .thenAnswer((_) async => scores);

      // With AsyncNotifier, we need to wait for the build() to complete
      await container.read(scoresProvider.future);

      final List<PlayerScore>? state = container.read(scoresProvider).value;
      expect(state, isEmpty);

      verify(() => mockGetAllScoresUseCase.execute())
          .called(greaterThanOrEqualTo(1));
    });

    test('_loadScores() loads all scores', () async {
      final List<PlayerScore> scores = <PlayerScore>[
        const PlayerScore(
          playerName: 'Player1',
          wins: 5,
          losses: 2,
          draws: 1,
        ),
        const PlayerScore(
          playerName: 'Player2',
          wins: 3,
          losses: 4,
        ),
      ];

      when(() => mockGetAllScoresUseCase.execute())
          .thenAnswer((_) async => scores);

      await Future<void>.microtask(() {});
      reset(mockGetAllScoresUseCase);
      when(() => mockGetAllScoresUseCase.execute())
          .thenAnswer((_) async => scores);

      final ScoresNotifier notifier = container.read(scoresProvider.notifier);
      await notifier.refreshScores();

      verify(() => mockGetAllScoresUseCase.execute())
          .called(greaterThanOrEqualTo(1));
      final List<PlayerScore>? state = container.read(scoresProvider).value;
      expect(state, scores);
    });

    test('updateScore() updates score for existing player', () async {
      const PlayerScore updatedScore = PlayerScore(
        playerName: 'Player1',
        wins: 6,
        losses: 2,
        draws: 1,
      );

      final List<PlayerScore> allScores = <PlayerScore>[updatedScore];

      when(() => mockUpdateScoreUseCase.execute('Player1', true, false))
          .thenAnswer((_) async => Future<void>.value());
      when(() => mockGetAllScoresUseCase.execute())
          .thenAnswer((_) async => allScores);

      await Future<void>.microtask(() {});
      clearInteractions(mockGetAllScoresUseCase);
      when(() => mockGetAllScoresUseCase.execute())
          .thenAnswer((_) async => allScores);

      final ScoresNotifier notifier = container.read(scoresProvider.notifier);
      await notifier.updateScore('Player1', true, false);

      verify(() => mockUpdateScoreUseCase.execute('Player1', true, false)).called(1);
      verify(() => mockGetAllScoresUseCase.execute())
          .called(greaterThanOrEqualTo(1));
    });

    test('updateScore() creates new score for new player', () async {
      const PlayerScore newScore = PlayerScore(
        playerName: 'NewPlayer',
        wins: 1,
      );

      final List<PlayerScore> allScores = <PlayerScore>[newScore];

      when(() => mockUpdateScoreUseCase.execute('NewPlayer', true, false))
          .thenAnswer((_) async => Future<void>.value());
      when(() => mockGetAllScoresUseCase.execute())
          .thenAnswer((_) async => allScores);

      final ScoresNotifier notifier = container.read(scoresProvider.notifier);
      await notifier.updateScore('NewPlayer', true, false);

      verify(() => mockUpdateScoreUseCase.execute('NewPlayer', true, false)).called(1);
    });

    test('updateScore() handles draw correctly', () async {
      const PlayerScore updatedScore = PlayerScore(
        playerName: 'Player1',
        wins: 5,
        losses: 2,
        draws: 2,
      );

      when(() => mockUpdateScoreUseCase.execute('Player1', false, true))
          .thenAnswer((_) async => Future<void>.value());
      when(() => mockGetAllScoresUseCase.execute())
          .thenAnswer((_) async => <PlayerScore>[updatedScore]);

      final ScoresNotifier notifier = container.read(scoresProvider.notifier);
      await notifier.updateScore('Player1', false, true);

      verify(() => mockUpdateScoreUseCase.execute('Player1', false, true)).called(1);
    });

    test('getPlayerScore() returns player score', () async {
      const PlayerScore score = PlayerScore(
        playerName: 'Player1',
        wins: 5,
        losses: 2,
        draws: 1,
      );

      when(() => mockGetPlayerScoreUseCase.execute('Player1'))
          .thenAnswer((_) async => score);

      final ScoresNotifier notifier = container.read(scoresProvider.notifier);
      final PlayerScore? result = await notifier.getPlayerScore('Player1');

      expect(result, score);
      verify(() => mockGetPlayerScoreUseCase.execute('Player1')).called(1);
    });

    test('getPlayerScore() returns null for non-existent player', () async {
      when(() => mockGetPlayerScoreUseCase.execute('NonExistent'))
          .thenAnswer((_) async => null);

      final ScoresNotifier notifier = container.read(scoresProvider.notifier);
      final PlayerScore? result = await notifier.getPlayerScore('NonExistent');

      expect(result, isNull);
      verify(() => mockGetPlayerScoreUseCase.execute('NonExistent')).called(1);
    });

    test('refreshScores() reloads all scores', () async {
      final List<PlayerScore> scores = <PlayerScore>[
        const PlayerScore(
          playerName: 'Player1',
          wins: 5,
          losses: 2,
          draws: 1,
        ),
      ];

      when(() => mockGetAllScoresUseCase.execute())
          .thenAnswer((_) async => scores);

      await Future<void>.microtask(() {});
      reset(mockGetAllScoresUseCase);
      when(() => mockGetAllScoresUseCase.execute())
          .thenAnswer((_) async => scores);

      final ScoresNotifier notifier = container.read(scoresProvider.notifier);
      await notifier.refreshScores();

      verify(() => mockGetAllScoresUseCase.execute())
          .called(greaterThanOrEqualTo(1));
      final List<PlayerScore>? state = container.read(scoresProvider).value;
      expect(state, scores);
    });

    test('resetScores() clears repository and resets state', () async {
      final ScoresNotifier notifier = container.read(scoresProvider.notifier);
      await notifier.resetScores();

      verify(() => mockResetScoresUseCase.execute()).called(1);
      final List<PlayerScore>? state = container.read(scoresProvider).value;
      expect(state, isEmpty);
    });
  });
}
