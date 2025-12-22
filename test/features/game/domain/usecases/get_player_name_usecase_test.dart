import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/entities/game_state_extensions.dart';
import 'package:tictac/features/game/domain/usecases/get_player_name_usecase.dart';

void main() {
  group('GetPlayerNameUseCase', () {
    late GetPlayerNameUseCase useCase;

    setUp(() {
      useCase = GetPlayerNameUseCase();
    });

    group('getPlayerXName', () {
      test('should return playerXName when it exists and differs from currentUsername', () {
        final GameState gameState = GameState(
          board: 3.createEmptyBoard(),
          status: GameStatus.playing,
          playerXName: 'Player X',
        );

        final String result = useCase.getPlayerXName(gameState, 'CurrentUser');

        expect(result, 'Player X');
      });

      test('should return currentUsername when playerXName is null', () {
        final GameState gameState = GameState(
          board: 3.createEmptyBoard(),
          status: GameStatus.playing,
        );

        final String result = useCase.getPlayerXName(gameState, 'CurrentUser');

        expect(result, 'CurrentUser');
      });

      test('should return currentUsername when playerXName matches currentUsername', () {
        final GameState gameState = GameState(
          board: 3.createEmptyBoard(),
          status: GameStatus.playing,
          playerXName: 'CurrentUser',
        );

        final String result = useCase.getPlayerXName(gameState, 'CurrentUser');

        expect(result, 'CurrentUser');
      });

      test('should return empty string when both are null', () {
        final GameState gameState = GameState(
          board: 3.createEmptyBoard(),
          status: GameStatus.playing,
        );

        final String result = useCase.getPlayerXName(gameState, null);

        expect(result, '');
      });
    });

    group('getPlayerOName', () {
      test('should return playerOName when it exists', () {
        final GameState gameState = GameState(
          board: 3.createEmptyBoard(),
          status: GameStatus.playing,
          playerOName: 'Player O',
        );

        final String result = useCase.getPlayerOName(gameState, null);

        expect(result, 'Player O');
      });

      test('should return AI_Easy when offlineComputer mode with difficulty 1', () {
        final GameState gameState = GameState(
          board: 3.createEmptyBoard(),
          status: GameStatus.playing,
          gameMode: GameModeType.offlineComputer,
        );

        final String result = useCase.getPlayerOName(gameState, 1);

        expect(result, 'AI_Easy');
      });

      test('should return AI_Medium when offlineComputer mode with difficulty 2', () {
        final GameState gameState = GameState(
          board: 3.createEmptyBoard(),
          status: GameStatus.playing,
          gameMode: GameModeType.offlineComputer,
        );

        final String result = useCase.getPlayerOName(gameState, 2);

        expect(result, 'AI_Medium');
      });

      test('should return AI_Hard when offlineComputer mode with difficulty 3', () {
        final GameState gameState = GameState(
          board: 3.createEmptyBoard(),
          status: GameStatus.playing,
          gameMode: GameModeType.offlineComputer,
        );

        final String result = useCase.getPlayerOName(gameState, 3);

        expect(result, 'AI_Hard');
      });

      test('should return AI_Easy for unknown difficulty', () {
        final GameState gameState = GameState(
          board: 3.createEmptyBoard(),
          status: GameStatus.playing,
          gameMode: GameModeType.offlineComputer,
        );

        final String result = useCase.getPlayerOName(gameState, 99);

        expect(result, 'AI_Easy');
      });

      test('should return empty string when not offlineComputer mode', () {
        final GameState gameState = GameState(
          board: 3.createEmptyBoard(),
          status: GameStatus.playing,
          gameMode: GameModeType.offlineFriend,
        );

        final String result = useCase.getPlayerOName(gameState, 1);

        expect(result, '');
      });

      test('should return empty string when computerDifficulty is null', () {
        final GameState gameState = GameState(
          board: 3.createEmptyBoard(),
          status: GameStatus.playing,
          gameMode: GameModeType.offlineComputer,
        );

        final String result = useCase.getPlayerOName(gameState, null);

        expect(result, '');
      });
    });
  });
}


