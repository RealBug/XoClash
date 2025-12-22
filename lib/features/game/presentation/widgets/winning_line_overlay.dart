import 'package:flutter/material.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/presentation/widgets/winning_line_painter.dart';

class WinningLineOverlay extends StatefulWidget {

  const WinningLineOverlay({
    super.key,
    required this.winningLine,
    required this.boardSize,
    required this.cellSize,
    required this.cellMargin,
    required this.color,
    required this.animationsEnabled,
    this.onAnimationComplete,
  });
  final WinningLine winningLine;
  final int boardSize;
  final double cellSize;
  final double cellMargin;
  final Color color;
  final bool animationsEnabled;
  final VoidCallback? onAnimationComplete;

  @override
  State<WinningLineOverlay> createState() => _WinningLineOverlayState();
}

class _WinningLineOverlayState extends State<WinningLineOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    if (widget.animationsEnabled) {
      _controller.forward().then((_) {
        if (widget.onAnimationComplete != null) {
          widget.onAnimationComplete!();
        }
      });
    } else {
      _controller.value = 1.0;
      if (widget.onAnimationComplete != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.onAnimationComplete!();
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return AnimatedBuilder(
            animation: _animation,
            builder: (BuildContext context, Widget? child) {
              return CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: WinningLinePainter(
                  startRow: widget.winningLine.startRow,
                  startCol: widget.winningLine.startCol,
                  endRow: widget.winningLine.endRow,
                  endCol: widget.winningLine.endCol,
                  boardSize: widget.boardSize,
                  cellSize: widget.cellSize,
                  cellMargin: widget.cellMargin,
                  color: widget.color,
                  progress: _animation.value,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
