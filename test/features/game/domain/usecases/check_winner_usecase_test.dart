import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/usecases/check_winner_usecase.dart';

void main() {
  late CheckWinnerUseCase useCase;

  setUp(() {
    useCase = CheckWinnerUseCase();
  });

  test('should detect X wins horizontally', () {
    final List<List<Player>> board = <List<Player>>[
      <Player>[Player.x, Player.x, Player.x],
      <Player>[Player.o, Player.o, Player.none],
      <Player>[Player.none, Player.none, Player.none],
    ];

    final GameState gameState = GameState(board: board, status: GameStatus.playing);

    final GameState result = useCase.execute(gameState);

    expect(result.status, equals(GameStatus.xWon));
  });

  test('should detect O wins horizontally', () {
    final List<List<Player>> board = <List<Player>>[
      <Player>[Player.o, Player.o, Player.o],
      <Player>[Player.x, Player.x, Player.none],
      <Player>[Player.none, Player.none, Player.none],
    ];

    final GameState gameState = GameState(board: board, currentPlayer: Player.o, status: GameStatus.playing);

    final GameState result = useCase.execute(gameState);

    expect(result.status, equals(GameStatus.oWon));
  });

  test('should detect X wins vertically', () {
    final List<List<Player>> board = <List<Player>>[
      <Player>[Player.x, Player.o, Player.none],
      <Player>[Player.x, Player.o, Player.none],
      <Player>[Player.x, Player.none, Player.none],
    ];

    final GameState gameState = GameState(board: board, status: GameStatus.playing);

    final GameState result = useCase.execute(gameState);

    expect(result.status, equals(GameStatus.xWon));
  });

  test('should detect O wins vertically', () {
    final List<List<Player>> board = <List<Player>>[
      <Player>[Player.o, Player.x, Player.none],
      <Player>[Player.o, Player.x, Player.none],
      <Player>[Player.o, Player.none, Player.none],
    ];

    final GameState gameState = GameState(board: board, currentPlayer: Player.o, status: GameStatus.playing);

    final GameState result = useCase.execute(gameState);

    expect(result.status, equals(GameStatus.oWon));
  });

  test('should detect X wins on main diagonal', () {
    final List<List<Player>> board = <List<Player>>[
      <Player>[Player.x, Player.o, Player.none],
      <Player>[Player.o, Player.x, Player.none],
      <Player>[Player.none, Player.none, Player.x],
    ];

    final GameState gameState = GameState(board: board, status: GameStatus.playing);

    final GameState result = useCase.execute(gameState);

    expect(result.status, equals(GameStatus.xWon));
  });

  test('should detect O wins on anti-diagonal', () {
    final List<List<Player>> board = <List<Player>>[
      <Player>[Player.x, Player.x, Player.o],
      <Player>[Player.x, Player.o, Player.none],
      <Player>[Player.o, Player.none, Player.none],
    ];

    final GameState gameState = GameState(board: board, currentPlayer: Player.o, status: GameStatus.playing);

    final GameState result = useCase.execute(gameState);

    expect(result.status, equals(GameStatus.oWon));
  });

  test('should detect draw when board is full', () {
    final List<List<Player>> board = <List<Player>>[
      <Player>[Player.x, Player.o, Player.x],
      <Player>[Player.o, Player.x, Player.o],
      <Player>[Player.o, Player.x, Player.o],
    ];

    final GameState gameState = GameState(board: board, status: GameStatus.playing);

    final GameState result = useCase.execute(gameState);

    expect(result.status, equals(GameStatus.draw));
  });

  test('should continue game when no winner and board not full', () {
    final List<List<Player>> board = <List<Player>>[
      <Player>[Player.x, Player.o, Player.none],
      <Player>[Player.o, Player.x, Player.none],
      <Player>[Player.none, Player.none, Player.none],
    ];

    final GameState gameState = GameState(board: board, status: GameStatus.playing);

    final GameState result = useCase.execute(gameState);

    expect(result.status, equals(GameStatus.playing));
    expect(result.currentPlayer, equals(Player.o));
  });

  test('should switch player when no winner', () {
    final List<List<Player>> board = <List<Player>>[
      <Player>[Player.x, Player.o, Player.none],
      <Player>[Player.none, Player.none, Player.none],
      <Player>[Player.none, Player.none, Player.none],
    ];

    final GameState gameState = GameState(board: board, status: GameStatus.playing);

    final GameState result = useCase.execute(gameState);

    expect(result.currentPlayer, equals(Player.o));
    expect(result.status, equals(GameStatus.playing));
  });

  test('should detect draw when no one can win', () {
    final List<List<Player>> board = <List<Player>>[
      <Player>[Player.x, Player.o, Player.x],
      <Player>[Player.o, Player.o, Player.x],
      <Player>[Player.x, Player.x, Player.o],
    ];

    final GameState gameState = GameState(board: board, status: GameStatus.playing);

    final GameState result = useCase.execute(gameState);

    expect(result.status, equals(GameStatus.draw));
  });

  test('should detect draw when only one move left and no one can win', () {
    final List<List<Player>> board = <List<Player>>[
      <Player>[Player.o, Player.x, Player.x],
      <Player>[Player.none, Player.x, Player.o],
      <Player>[Player.o, Player.o, Player.x],
    ];

    final GameState gameState = GameState(board: board, currentPlayer: Player.o, status: GameStatus.playing);

    final GameState result = useCase.execute(gameState);

    expect(result.status, equals(GameStatus.draw));
  });

  group('4x4 Board tests', () {
    test('should detect X wins horizontally on 4x4 board', () {
      final List<List<Player>> board = <List<Player>>[
        <Player>[Player.x, Player.x, Player.x, Player.x],
        <Player>[Player.o, Player.o, Player.o, Player.none],
        <Player>[Player.none, Player.none, Player.none, Player.none],
        <Player>[Player.none, Player.none, Player.none, Player.none],
      ];

      final GameState gameState = GameState(board: board, status: GameStatus.playing);

      final GameState result = useCase.execute(gameState);

      expect(result.status, equals(GameStatus.xWon));
      expect(result.winningLine, isNotNull);
    });

    test('should detect O wins vertically on 4x4 board', () {
      final List<List<Player>> board = <List<Player>>[
        <Player>[Player.o, Player.x, Player.none, Player.none],
        <Player>[Player.o, Player.x, Player.none, Player.none],
        <Player>[Player.o, Player.x, Player.none, Player.none],
        <Player>[Player.o, Player.none, Player.none, Player.none],
      ];

      final GameState gameState = GameState(board: board, currentPlayer: Player.o, status: GameStatus.playing);

      final GameState result = useCase.execute(gameState);

      expect(result.status, equals(GameStatus.oWon));
    });

    test('should detect X wins on main diagonal 4x4 board', () {
      final List<List<Player>> board = <List<Player>>[
        <Player>[Player.x, Player.o, Player.none, Player.none],
        <Player>[Player.o, Player.x, Player.none, Player.none],
        <Player>[Player.none, Player.o, Player.x, Player.none],
        <Player>[Player.none, Player.none, Player.o, Player.x],
      ];

      final GameState gameState = GameState(board: board, status: GameStatus.playing);

      final GameState result = useCase.execute(gameState);

      expect(result.status, equals(GameStatus.xWon));
    });

    test('should detect O wins on anti-diagonal 4x4 board', () {
      final List<List<Player>> board = <List<Player>>[
        <Player>[Player.x, Player.x, Player.none, Player.o],
        <Player>[Player.x, Player.none, Player.o, Player.none],
        <Player>[Player.none, Player.o, Player.x, Player.none],
        <Player>[Player.o, Player.none, Player.none, Player.none],
      ];

      final GameState gameState = GameState(board: board, currentPlayer: Player.o, status: GameStatus.playing);

      final GameState result = useCase.execute(gameState);

      expect(result.status, equals(GameStatus.oWon));
    });
  });

  group('5x5 Board tests', () {
    test('should detect X wins with 4-in-a-row on 5x5 board', () {
      final List<List<Player>> board = <List<Player>>[
        <Player>[Player.x, Player.x, Player.x, Player.x, Player.none],
        <Player>[Player.o, Player.o, Player.o, Player.none, Player.none],
        <Player>[Player.none, Player.none, Player.none, Player.none, Player.none],
        <Player>[Player.none, Player.none, Player.none, Player.none, Player.none],
        <Player>[Player.none, Player.none, Player.none, Player.none, Player.none],
      ];

      final GameState gameState = GameState(board: board, status: GameStatus.playing);

      final GameState result = useCase.execute(gameState);

      expect(result.status, equals(GameStatus.xWon));
    });

    test('should detect O wins vertically on 5x5 board', () {
      final List<List<Player>> board = <List<Player>>[
        <Player>[Player.o, Player.x, Player.none, Player.none, Player.none],
        <Player>[Player.o, Player.x, Player.none, Player.none, Player.none],
        <Player>[Player.o, Player.none, Player.none, Player.none, Player.none],
        <Player>[Player.o, Player.none, Player.none, Player.none, Player.none],
        <Player>[Player.none, Player.none, Player.none, Player.none, Player.none],
      ];

      final GameState gameState = GameState(board: board, currentPlayer: Player.o, status: GameStatus.playing);

      final GameState result = useCase.execute(gameState);

      expect(result.status, equals(GameStatus.oWon));
    });

    test('should detect diagonal win on 5x5 board', () {
      final List<List<Player>> board = <List<Player>>[
        <Player>[Player.x, Player.o, Player.none, Player.none, Player.none],
        <Player>[Player.o, Player.x, Player.none, Player.none, Player.none],
        <Player>[Player.none, Player.o, Player.x, Player.none, Player.none],
        <Player>[Player.none, Player.none, Player.o, Player.x, Player.none],
        <Player>[Player.none, Player.none, Player.none, Player.none, Player.none],
      ];

      final GameState gameState = GameState(board: board, status: GameStatus.playing);

      final GameState result = useCase.execute(gameState);

      expect(result.status, equals(GameStatus.xWon));
    });

    test('should detect draw when only move available leads to draw for X', () {
      final List<List<Player>> board = <List<Player>>[
        <Player>[Player.o, Player.o, Player.none],
        <Player>[Player.x, Player.x, Player.o],
        <Player>[Player.o, Player.x, Player.x],
      ];

      final GameState gameState = GameState(board: board, currentPlayer: Player.o, status: GameStatus.playing);

      final GameState result = useCase.execute(gameState);

      expect(result.status, equals(GameStatus.draw));
    });

    test('should detect draw when only move available leads to draw for O', () {
      final List<List<Player>> board = <List<Player>>[
        <Player>[Player.x, Player.x, Player.none],
        <Player>[Player.o, Player.o, Player.x],
        <Player>[Player.x, Player.o, Player.o],
      ];

      final GameState gameState = GameState(board: board);

      final GameState result = useCase.execute(gameState);

      expect(result.status, equals(GameStatus.draw));
    });

    test('should not detect draw when current player can win', () {
      final List<List<Player>> board = <List<Player>>[
        <Player>[Player.o, Player.o, Player.none],
        <Player>[Player.x, Player.x, Player.o],
        <Player>[Player.o, Player.x, Player.x],
      ];

      final GameState gameState = GameState(board: board);

      final GameState result = useCase.execute(gameState);

      expect(result.status, equals(GameStatus.playing));
    });

    test('should detect draw when no one can complete a line', () {
      final List<List<Player>> board = <List<Player>>[
        <Player>[Player.x, Player.o, Player.x],
        <Player>[Player.o, Player.x, Player.o],
        <Player>[Player.none, Player.none, Player.none],
      ];

      final GameState gameState = GameState(board: board);

      final GameState result = useCase.execute(gameState);

      expect(result.status, equals(GameStatus.playing));
    });

    test('should detect draw when X must play but O can win on next turn', () {
      final List<List<Player>> board = <List<Player>>[
        <Player>[Player.o, Player.o, Player.none],
        <Player>[Player.x, Player.x, Player.o],
        <Player>[Player.o, Player.x, Player.x],
      ];

      final GameState gameState = GameState(board: board, currentPlayer: Player.o, status: GameStatus.playing);

      final GameState result = useCase.execute(gameState);

      expect(result.status, equals(GameStatus.draw));
    });

    test('should correctly set winningLine for horizontal win', () {
      final List<List<Player>> board = <List<Player>>[
        <Player>[Player.x, Player.x, Player.x],
        <Player>[Player.o, Player.o, Player.none],
        <Player>[Player.none, Player.none, Player.none],
      ];

      final GameState gameState = GameState(board: board, status: GameStatus.playing);

      final GameState result = useCase.execute(gameState);

      expect(result.winningLine, isNotNull);
      expect(result.winningLine!.startRow, equals(0));
      expect(result.winningLine!.startCol, equals(0));
      expect(result.winningLine!.endRow, equals(0));
      expect(result.winningLine!.endCol, equals(2));
    });

    test('should correctly set winningLine for vertical win', () {
      final List<List<Player>> board = <List<Player>>[
        <Player>[Player.x, Player.o, Player.none],
        <Player>[Player.x, Player.o, Player.none],
        <Player>[Player.x, Player.none, Player.none],
      ];

      final GameState gameState = GameState(board: board, status: GameStatus.playing);

      final GameState result = useCase.execute(gameState);

      expect(result.winningLine, isNotNull);
      expect(result.winningLine!.startRow, equals(0));
      expect(result.winningLine!.startCol, equals(0));
      expect(result.winningLine!.endRow, equals(2));
      expect(result.winningLine!.endCol, equals(0));
    });

    test('should correctly set winningLine for main diagonal win', () {
      final List<List<Player>> board = <List<Player>>[
        <Player>[Player.x, Player.o, Player.none],
        <Player>[Player.o, Player.x, Player.none],
        <Player>[Player.none, Player.none, Player.x],
      ];

      final GameState gameState = GameState(board: board, status: GameStatus.playing);

      final GameState result = useCase.execute(gameState);

      expect(result.winningLine, isNotNull);
      expect(result.winningLine!.startRow, equals(0));
      expect(result.winningLine!.startCol, equals(0));
      expect(result.winningLine!.endRow, equals(2));
      expect(result.winningLine!.endCol, equals(2));
    });

    test('should correctly set winningLine for anti-diagonal win', () {
      final List<List<Player>> board = <List<Player>>[
        <Player>[Player.x, Player.x, Player.o],
        <Player>[Player.x, Player.o, Player.none],
        <Player>[Player.o, Player.none, Player.none],
      ];

      final GameState gameState = GameState(board: board, currentPlayer: Player.o, status: GameStatus.playing);

      final GameState result = useCase.execute(gameState);

      expect(result.winningLine, isNotNull);
      expect(result.winningLine!.startRow, equals(0));
      expect(result.winningLine!.startCol, equals(2));
      expect(result.winningLine!.endRow, equals(2));
      expect(result.winningLine!.endCol, equals(0));
    });

    test('should switch player correctly when O just played', () {
      final List<List<Player>> board = <List<Player>>[
        <Player>[Player.x, Player.o, Player.none],
        <Player>[Player.none, Player.none, Player.none],
        <Player>[Player.none, Player.none, Player.none],
      ];

      final GameState gameState = GameState(board: board, currentPlayer: Player.o, status: GameStatus.playing);

      final GameState result = useCase.execute(gameState);

      expect(result.currentPlayer, equals(Player.x));
      expect(result.status, equals(GameStatus.playing));
    });

    test('should switch player correctly when X just played', () {
      final List<List<Player>> board = <List<Player>>[
        <Player>[Player.x, Player.o, Player.none],
        <Player>[Player.none, Player.none, Player.none],
        <Player>[Player.none, Player.none, Player.none],
      ];

      final GameState gameState = GameState(board: board);

      final GameState result = useCase.execute(gameState);

      expect(result.currentPlayer, equals(Player.o));
      expect(result.status, equals(GameStatus.playing));
    });

    test('should detect draw when board becomes full after move with no winner', () {
      final List<List<Player>> board = <List<Player>>[
        <Player>[Player.o, Player.o, Player.none],
        <Player>[Player.x, Player.x, Player.o],
        <Player>[Player.o, Player.x, Player.x],
      ];

      final GameState gameState = GameState(board: board, currentPlayer: Player.o, status: GameStatus.playing);

      final GameState result = useCase.execute(gameState);

      expect(result.status, equals(GameStatus.draw));
    });
  });
}
