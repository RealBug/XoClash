import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/entities/game_state_extensions.dart';
import 'package:tictac/features/game/domain/usecases/get_game_result_info_usecase.dart';

void main() {
  group('GetGameResultInfoUseCase', () {
    late GetGameResultInfoUseCase useCase;

    setUp(() {
      useCase = GetGameResultInfoUseCase();
    });

    test('should return false for all flags when game is not over', () {
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        status: GameStatus.playing,
      );

      final GameResultInfo result = useCase.execute(gameState, 'Player1');

      expect(result.isCurrentPlayerWin, false);
      expect(result.isLocalFriendWin, false);
      expect(result.shouldShowConfetti, false);
      expect(result.winningPlayerName, null);
    });

    test('should return false for all flags when game is draw', () {
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        status: GameStatus.draw,
      );

      final GameResultInfo result = useCase.execute(gameState, 'Player1');

      expect(result.isCurrentPlayerWin, false);
      expect(result.isLocalFriendWin, false);
      expect(result.shouldShowConfetti, false);
      expect(result.winningPlayerName, null);
    });

    test('should detect current player win when X wins and playerXName matches', () {
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        status: GameStatus.xWon,
        playerXName: 'Player1',
        gameMode: GameModeType.offlineFriend,
      );

      final GameResultInfo result = useCase.execute(gameState, 'Player1');

      expect(result.isCurrentPlayerWin, true);
      expect(result.shouldShowConfetti, true);
      expect(result.winningPlayerName, 'Player1');
    });

    test('should detect current player win when O wins and playerOName matches', () {
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        currentPlayer: Player.o,
        status: GameStatus.oWon,
        playerOName: 'Player1',
      );

      final GameResultInfo result = useCase.execute(gameState, 'Player1');

      expect(result.isCurrentPlayerWin, true);
      expect(result.shouldShowConfetti, true);
      expect(result.winningPlayerName, 'Player1');
    });

    test('should detect local friend win in offline friend mode', () {
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        status: GameStatus.oWon,
        playerXName: 'Player1',
        playerOName: 'Player2',
        gameMode: GameModeType.offlineFriend,
      );

      final GameResultInfo result = useCase.execute(gameState, 'Player1');

      expect(result.isCurrentPlayerWin, false);
      expect(result.isLocalFriendWin, true);
      expect(result.shouldShowConfetti, true);
      expect(result.winningPlayerName, 'Player2');
    });

    test('should not detect local friend win when current player wins', () {
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        status: GameStatus.xWon,
        playerXName: 'Player1',
        playerOName: 'Player2',
        gameMode: GameModeType.offlineFriend,
      );

      final GameResultInfo result = useCase.execute(gameState, 'Player1');

      expect(result.isCurrentPlayerWin, true);
      expect(result.isLocalFriendWin, false);
    });

    test('should handle offline game with currentUsername', () {
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        status: GameStatus.xWon,
        gameMode: GameModeType.offlineComputer,
      );

      final GameResultInfo result = useCase.execute(gameState, 'Player1');

      expect(result.isCurrentPlayerWin, true);
      expect(result.shouldShowConfetti, true);
    });

    test('should return null winningPlayerName when draw', () {
      final GameState gameState = GameState(
        board: 3.createEmptyBoard(),
        status: GameStatus.draw,
      );

      final GameResultInfo result = useCase.execute(gameState, 'Player1');

      expect(result.winningPlayerName, null);
    });
  });
}


