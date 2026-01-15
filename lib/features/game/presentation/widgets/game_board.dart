import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tictac/core/constants/app_constants.dart';
import 'package:tictac/core/constants/game_constants.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/domain/entities/game_state_extensions.dart';
import 'package:tictac/features/game/presentation/widgets/animated_cell_wrapper.dart';
import 'package:tictac/features/game/presentation/widgets/game_cell.dart';
import 'package:tictac/features/game/presentation/widgets/winning_line_overlay.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({
    super.key,
    required this.gameState,
    required this.onCellTap,
    this.isDarkMode = true,
    this.animationsEnabled = true,
    this.xShape = AppConstants.defaultShape,
    this.oShape = AppConstants.defaultShape,
    this.xEmoji,
    this.oEmoji,
    this.useEmojis = false,
    this.onWinningLineAnimationComplete,
  });
  final GameState gameState;
  final Function(int row, int col) onCellTap;
  final bool isDarkMode;
  final bool animationsEnabled;
  final String xShape;
  final String oShape;
  final String? xEmoji;
  final String? oEmoji;
  final bool useEmojis;
  final VoidCallback? onWinningLineAnimationComplete;

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  int _resetKey = 0;
  bool _wasBoardEmpty = true;

  @override
  void didUpdateWidget(GameBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final isBoardEmpty = widget.gameState.board.isBoardEmpty;

    if (!_wasBoardEmpty && isBoardEmpty) {
      _resetKey = DateTime.now().millisecondsSinceEpoch;
    }

    _wasBoardEmpty = isBoardEmpty;
  }

  bool _isCellEnabled(GameState gameState, int row, int col) {
    if (gameState.isGameOver) {
      return false;
    }
    if (gameState.board[row][col] != Player.none) {
      return false;
    }
    if (gameState.status != GameStatus.playing) {
      return false;
    }

    if (gameState.gameMode == GameModeType.offlineComputer) {
      return gameState.currentPlayer == Player.x;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final boardColor = widget.isDarkMode ? AppTheme.darkCardColor : AppTheme.lightCardColor;
    final shadowColor = widget.isDarkMode
        ? AppTheme.darkBackgroundColor.withValues(alpha: 0.5)
        : AppTheme.lightTextPrimary.withValues(alpha: 0.1);

    final isBoardEmpty = widget.gameState.board.isBoardEmpty;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final maxWidth = constraints.maxWidth.isFinite ? constraints.maxWidth : MediaQuery.of(context).size.width;
        final availableWidth = maxWidth - (GameConstants.boardContainerPadding * 2);
        final availableHeight = constraints.maxHeight > 0 && constraints.maxHeight.isFinite
            ? constraints.maxHeight - (GameConstants.boardContainerPadding * 2)
            : double.infinity;

        final boardSize = widget.gameState.board.length;
        final cellMargin = GameConstants.getCellMargin(boardSize);

        final maxCellWidth = (availableWidth - (boardSize * cellMargin * 2)) / boardSize;
        final maxCellHeight = availableHeight.isFinite ? (availableHeight - (boardSize * cellMargin * 2)) / boardSize : maxCellWidth;

        final cellSize = math.min(maxCellWidth, maxCellHeight).clamp(GameConstants.minCellSize, GameConstants.maxCellSize);

        return Stack(
          children: <Widget>[
            SizedBox(
              width: maxWidth.isFinite ? maxWidth : null,
              child: Container(
                padding: const EdgeInsets.all(GameConstants.boardContainerPadding),
                decoration: BoxDecoration(
                  color: boardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: <BoxShadow>[BoxShadow(color: shadowColor, blurRadius: 20, spreadRadius: 5)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List<Widget>.generate(widget.gameState.board.length, (row) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: List<Widget>.generate(widget.gameState.board[row].length, (col) {
                        return AnimatedCellWrapper(
                          key: ValueKey<String>('cell_${row}_${col}_$_resetKey'),
                          row: row,
                          col: col,
                          boardSize: widget.gameState.board.length,
                          animationsEnabled: widget.animationsEnabled,
                          isCellEmpty: widget.gameState.board[row][col] == Player.none,
                          isBoardEmpty: isBoardEmpty,
                          child: GameCell(
                            player: widget.gameState.board[row][col],
                            isEnabled: _isCellEnabled(widget.gameState, row, col),
                            onTap: () => widget.onCellTap(row, col),
                            isDarkMode: widget.isDarkMode,
                            boardSize: widget.gameState.board.length,
                            cellSize: cellSize,
                            cellMargin: cellMargin,
                            animationsEnabled: widget.animationsEnabled,
                            xShape: widget.xShape,
                            oShape: widget.oShape,
                            xEmoji: widget.xEmoji,
                            oEmoji: widget.oEmoji,
                            useEmojis: widget.useEmojis,
                          ),
                        );
                      }),
                    );
                  }),
                ),
              ),
            ),
            if (widget.gameState.winningLine != null)
              WinningLineOverlay(
                winningLine: widget.gameState.winningLine!,
                boardSize: widget.gameState.board.length,
                cellSize: cellSize,
                cellMargin: cellMargin,
                color: widget.gameState.status == GameStatus.xWon ? AppTheme.redAccent : AppTheme.yellowAccent,
                animationsEnabled: widget.animationsEnabled,
                onAnimationComplete: widget.onWinningLineAnimationComplete,
              ),
            if (widget.gameState.isComputerThinking)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(color: boardColor.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(24)),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: boardColor,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: <BoxShadow>[BoxShadow(color: shadowColor, blurRadius: 20, spreadRadius: 5)],
                      ),
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            widget.isDarkMode ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
