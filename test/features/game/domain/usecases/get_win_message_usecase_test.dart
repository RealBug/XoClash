import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/usecases/get_win_message_usecase.dart';

void main() {
  group('GetWinMessageUseCase', () {
    late GetWinMessageUseCase useCase;

    setUp(() {
      useCase = GetWinMessageUseCase();
    });

    test('execute returns displayName when playerName is provided', () {
      const GameState gameState = GameState(
        board: <List<Player>>[
          <Player>[Player.x, Player.x, Player.x],
          <Player>[Player.none, Player.none, Player.none],
          <Player>[Player.none, Player.none, Player.none],
        ],
        status: GameStatus.xWon,
        gameMode: GameModeType.online,
      );

      final WinMessageData result = useCase.execute(
        playerName: 'Player X',
        defaultName: 'Player X',
        gameState: gameState,
        isCurrentUser: true,
      );

      expect(result.displayName, 'Player X');
      expect(result.useYouWon, true);
    });

    test('execute returns defaultName when playerName is null', () {
      const GameState gameState = GameState(
        board: <List<Player>>[
          <Player>[Player.x, Player.x, Player.x],
          <Player>[Player.none, Player.none, Player.none],
          <Player>[Player.none, Player.none, Player.none],
        ],
        status: GameStatus.xWon,
        gameMode: GameModeType.online,
      );

      final WinMessageData result = useCase.execute(
        playerName: null,
        defaultName: 'Player X',
        gameState: gameState,
        isCurrentUser: false,
      );

      expect(result.displayName, 'Player X');
      expect(result.useYouWon, false);
    });

    test('execute returns defaultName when playerName is empty', () {
      const GameState gameState = GameState(
        board: <List<Player>>[
          <Player>[Player.x, Player.x, Player.x],
          <Player>[Player.none, Player.none, Player.none],
          <Player>[Player.none, Player.none, Player.none],
        ],
        status: GameStatus.xWon,
        gameMode: GameModeType.online,
      );

      final WinMessageData result = useCase.execute(
        playerName: '',
        defaultName: 'Player O',
        gameState: gameState,
        isCurrentUser: false,
      );

      expect(result.displayName, 'Player O');
      expect(result.useYouWon, false);
    });

    test('execute returns useYouWon=true for online mode when isCurrentUser is true', () {
      const GameState gameState = GameState(
        board: <List<Player>>[
          <Player>[Player.x, Player.x, Player.x],
          <Player>[Player.none, Player.none, Player.none],
          <Player>[Player.none, Player.none, Player.none],
        ],
        status: GameStatus.xWon,
        gameMode: GameModeType.online,
      );

      final WinMessageData result = useCase.execute(
        playerName: 'Player X',
        defaultName: 'Player X',
        gameState: gameState,
        isCurrentUser: true,
      );

      expect(result.useYouWon, true);
    });

    test('execute returns useYouWon=false for online mode when isCurrentUser is false', () {
      const GameState gameState = GameState(
        board: <List<Player>>[
          <Player>[Player.x, Player.x, Player.x],
          <Player>[Player.none, Player.none, Player.none],
          <Player>[Player.none, Player.none, Player.none],
        ],
        status: GameStatus.xWon,
        gameMode: GameModeType.online,
      );

      final WinMessageData result = useCase.execute(
        playerName: 'Player X',
        defaultName: 'Player X',
        gameState: gameState,
        isCurrentUser: false,
      );

      expect(result.useYouWon, false);
    });

    test('execute returns useYouWon=false for offlineFriend mode even when isCurrentUser is true', () {
      const GameState gameState = GameState(
        board: <List<Player>>[
          <Player>[Player.x, Player.x, Player.x],
          <Player>[Player.none, Player.none, Player.none],
          <Player>[Player.none, Player.none, Player.none],
        ],
        status: GameStatus.xWon,
        gameMode: GameModeType.offlineFriend,
      );

      final WinMessageData result = useCase.execute(
        playerName: 'Player X',
        defaultName: 'Player X',
        gameState: gameState,
        isCurrentUser: true,
      );

      expect(result.useYouWon, false);
    });

    test('execute returns useYouWon=true for offlineComputer mode when isCurrentUser is true', () {
      const GameState gameState = GameState(
        board: <List<Player>>[
          <Player>[Player.x, Player.x, Player.x],
          <Player>[Player.none, Player.none, Player.none],
          <Player>[Player.none, Player.none, Player.none],
        ],
        status: GameStatus.xWon,
        gameMode: GameModeType.offlineComputer,
      );

      final WinMessageData result = useCase.execute(
        playerName: 'Player X',
        defaultName: 'Player X',
        gameState: gameState,
        isCurrentUser: true,
      );

      expect(result.useYouWon, true);
    });

    test('execute returns useYouWon=false for offlineComputer mode when isCurrentUser is false', () {
      const GameState gameState = GameState(
        board: <List<Player>>[
          <Player>[Player.x, Player.x, Player.x],
          <Player>[Player.none, Player.none, Player.none],
          <Player>[Player.none, Player.none, Player.none],
        ],
        status: GameStatus.xWon,
        gameMode: GameModeType.offlineComputer,
      );

      final WinMessageData result = useCase.execute(
        playerName: 'AI_Hard',
        defaultName: 'AI_Hard',
        gameState: gameState,
        isCurrentUser: false,
      );

      expect(result.useYouWon, false);
    });

    test('execute handles null gameMode', () {
      const GameState gameState = GameState(
        board: <List<Player>>[
          <Player>[Player.x, Player.x, Player.x],
          <Player>[Player.none, Player.none, Player.none],
          <Player>[Player.none, Player.none, Player.none],
        ],
        status: GameStatus.xWon,
      );

      final WinMessageData result = useCase.execute(
        playerName: 'Player X',
        defaultName: 'Player X',
        gameState: gameState,
        isCurrentUser: true,
      );

      expect(result.displayName, 'Player X');
      expect(result.useYouWon, true);
    });
  });
}

