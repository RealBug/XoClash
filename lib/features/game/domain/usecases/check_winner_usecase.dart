import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/entities/game_state_extensions.dart';

class CheckWinnerUseCase {
  CheckWinnerUseCase();

  GameState execute(GameState gameState) {
    final board = gameState.board;
    final size = board.length;
    final winCondition = size.getWinCondition();

    final (winner, winningLine) = _findWinner(board, size, winCondition);
    if (winner != null) {
      final status = winner == Player.x ? GameStatus.xWon : GameStatus.oWon;
      return gameState.copyWith(status: status, winningLine: winningLine);
    }

    if (_isBoardFull(board, size)) {
      return gameState.copyWith(status: GameStatus.draw);
    }

    final nextPlayer = _getOpponent(gameState.currentPlayer);
    if (_isDraw(board, size, winCondition, nextPlayer)) {
      return gameState.copyWith(status: GameStatus.draw);
    }

    return gameState.copyWith(currentPlayer: nextPlayer, status: GameStatus.playing);
  }

  (Player?, WinningLine?) _findWinner(List<List<Player>> board, int size, int winCondition) {
    final (winner, line) = _findHorizontalWinner(board, size, winCondition);
    if (winner != null) {
      return (winner, line);
    }

    final (winner2, line2) = _findVerticalWinner(board, size, winCondition);
    if (winner2 != null) {
      return (winner2, line2);
    }

    final (winner3, line3) = _findMainDiagonalWinner(board, size, winCondition);
    if (winner3 != null) {
      return (winner3, line3);
    }

    return _findAntiDiagonalWinner(board, size, winCondition);
  }

  (Player?, WinningLine?) _findHorizontalWinner(List<List<Player>> board, int size, int winCondition) {
    return _findWinnerInDirection(
      board: board,
      size: size,
      winCondition: winCondition,
      rowRange: size,
      colRange: size - winCondition + 1,
      hasWin: (int row, int col, Player player) => _hasHorizontalWin(board, row, col, player, winCondition),
      createWinningLine: (int row, int col) => WinningLine(startRow: row, startCol: col, endRow: row, endCol: col + winCondition - 1),
    );
  }

  (Player?, WinningLine?) _findVerticalWinner(List<List<Player>> board, int size, int winCondition) {
    return _findWinnerInDirection(
      board: board,
      size: size,
      winCondition: winCondition,
      rowRange: size - winCondition + 1,
      colRange: size,
      hasWin: (int row, int col, Player player) => _hasVerticalWin(board, row, col, player, winCondition),
      createWinningLine: (int row, int col) => WinningLine(startRow: row, startCol: col, endRow: row + winCondition - 1, endCol: col),
    );
  }

  (Player?, WinningLine?) _findMainDiagonalWinner(List<List<Player>> board, int size, int winCondition) {
    return _findWinnerInDirection(
      board: board,
      size: size,
      winCondition: winCondition,
      rowRange: size - winCondition + 1,
      colRange: size - winCondition + 1,
      hasWin: (int row, int col, Player player) => _hasMainDiagonalWin(board, row, col, player, winCondition),
      createWinningLine: (int row, int col) =>
          WinningLine(startRow: row, startCol: col, endRow: row + winCondition - 1, endCol: col + winCondition - 1),
    );
  }

  (Player?, WinningLine?) _findAntiDiagonalWinner(List<List<Player>> board, int size, int winCondition) {
    return _findWinnerInDirection(
      board: board,
      size: size,
      winCondition: winCondition,
      rowRange: size - winCondition + 1,
      colRange: size - winCondition + 1,
      colStart: winCondition - 1,
      hasWin: (int row, int col, Player player) => _hasAntiDiagonalWin(board, row, col, player, winCondition),
      createWinningLine: (int row, int col) =>
          WinningLine(startRow: row, startCol: col, endRow: row + winCondition - 1, endCol: col - (winCondition - 1)),
    );
  }

  (Player?, WinningLine?) _findWinnerInDirection({
    required List<List<Player>> board,
    required int size,
    required int winCondition,
    required int rowRange,
    required int colRange,
    int colStart = 0,
    required bool Function(int, int, Player) hasWin,
    required WinningLine Function(int, int) createWinningLine,
  }) {
    for (int row = 0; row < rowRange; row++) {
      for (int col = colStart; col < colStart + colRange; col++) {
        final player = board[row][col];
        if (player != Player.none && hasWin(row, col, player)) {
          return (player, createWinningLine(row, col));
        }
      }
    }
    return (null, null);
  }

  bool _hasHorizontalWin(List<List<Player>> board, int row, int col, Player player, int winCondition) {
    return List.generate(winCondition, (i) => board[row][col + i]).every((cell) => cell == player);
  }

  bool _hasVerticalWin(List<List<Player>> board, int row, int col, Player player, int winCondition) {
    return List.generate(winCondition, (i) => board[row + i][col]).every((cell) => cell == player);
  }

  bool _hasMainDiagonalWin(List<List<Player>> board, int row, int col, Player player, int winCondition) {
    return List.generate(winCondition, (i) => board[row + i][col + i]).every((cell) => cell == player);
  }

  bool _hasAntiDiagonalWin(List<List<Player>> board, int row, int col, Player player, int winCondition) {
    return List.generate(winCondition, (i) => board[row + i][col - i]).every((cell) => cell == player);
  }

  bool _isBoardFull(List<List<Player>> board, int size) {
    return !board.any((row) => row.any((cell) => cell == Player.none));
  }

  bool _isDraw(List<List<Player>> board, int size, int winCondition, Player currentPlayer) {
    final (winner, _) = _findWinner(board, size, winCondition);
    if (winner != null) {
      return false;
    }

    final availableMoves = _getAvailableMoves(board, size);
    if (availableMoves.isEmpty) {
      return true;
    }

    final opponent = _getOpponent(currentPlayer);

    for (final move in availableMoves) {
      final boardAfterMove = _copyBoard(board, size);
      boardAfterMove[move[0]][move[1]] = currentPlayer;

      final (winnerAfterMove, _) = _findWinner(boardAfterMove, size, winCondition);
      if (winnerAfterMove == currentPlayer) {
        return false;
      }

      if (_isBoardFull(boardAfterMove, size)) {
        if (winnerAfterMove != null) {
          return false;
        }
        continue;
      }

      final remainingMoves = _getAvailableMoves(boardAfterMove, size);
      if (remainingMoves.isEmpty) {
        continue;
      }

      if (_opponentCanWin(boardAfterMove, remainingMoves, opponent, size, winCondition, currentPlayer)) {
        return false;
      }
    }

    return true;
  }

  bool _opponentCanWin(
    List<List<Player>> boardAfterCurrentMove,
    List<List<int>> remainingMoves,
    Player opponent,
    int size,
    int winCondition,
    Player currentPlayer,
  ) {
    for (final opponentMove in remainingMoves) {
      final boardAfterOpponentMove = _copyBoard(boardAfterCurrentMove, size);
      boardAfterOpponentMove[opponentMove[0]][opponentMove[1]] = opponent;

      final (winnerAfterOpponent, _) = _findWinner(boardAfterOpponentMove, size, winCondition);
      if (winnerAfterOpponent == opponent) {
        return true;
      }

      if (_isBoardFull(boardAfterOpponentMove, size)) {
        if (winnerAfterOpponent != null) {
          return true;
        }
        continue;
      }

      if (!_isDraw(boardAfterOpponentMove, size, winCondition, currentPlayer)) {
        return true;
      }
    }
    return false;
  }

  List<List<Player>> _copyBoard(List<List<Player>> board, int size) {
    return List.generate(size, (row) => List.generate(size, (col) => board[row][col]));
  }

  List<List<int>> _getAvailableMoves(List<List<Player>> board, int size) {
    final emptyCells = <List<int>>[];
    for (int row = 0; row < size; row++) {
      for (int col = 0; col < size; col++) {
        if (board[row][col] == Player.none) {
          emptyCells.add([row, col]);
        }
      }
    }
    return emptyCells;
  }

  Player _getOpponent(Player player) => player == Player.x ? Player.o : Player.x;
}
