import 'package:flutter/material.dart';
import 'package:tictac/core/constants/app_constants.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/presentation/widgets/player_symbol_widget.dart';

class GameCell extends StatefulWidget {

  const GameCell({
    super.key,
    required this.player,
    required this.isEnabled,
    required this.onTap,
    this.isDarkMode = true,
    this.boardSize = 3,
    required this.cellSize,
    required this.cellMargin,
    this.animationsEnabled = true,
    this.xShape = AppConstants.defaultShape,
    this.oShape = AppConstants.defaultShape,
    this.xEmoji,
    this.oEmoji,
    this.useEmojis = false,
  });
  final Player player;
  final bool isEnabled;
  final VoidCallback onTap;
  final bool isDarkMode;
  final int boardSize;
  final double cellSize;
  final double cellMargin;
  final bool animationsEnabled;
  final String xShape;
  final String oShape;
  final String? xEmoji;
  final String? oEmoji;
  final bool useEmojis;

  @override
  State<GameCell> createState() => _GameCellState();
}

class _GameCellState extends State<GameCell> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    final Duration duration = widget.animationsEnabled
        ? const Duration(milliseconds: 300)
        : Duration.zero;
    _controller = AnimationController(
      vsync: this,
      duration: duration,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      widget.animationsEnabled
          ? CurvedAnimation(
              parent: _controller,
              curve: Curves.elasticOut,
            )
          : _controller,
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      widget.animationsEnabled
          ? CurvedAnimation(
              parent: _controller,
              curve: Curves.easeInOut,
            )
          : _controller,
    );

    if (widget.player != Player.none) {
      if (widget.animationsEnabled) {
        _controller.forward();
      } else {
        _controller.value = 1.0;
      }
    }
  }

  @override
  void didUpdateWidget(GameCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.player != Player.none && oldWidget.player == Player.none) {
      if (widget.animationsEnabled) {
        _controller.forward(from: 0.0);
      } else {
        _controller.value = 1.0;
      }
    }
    if (widget.player != Player.none &&
        (widget.xEmoji != oldWidget.xEmoji ||
            widget.oEmoji != oldWidget.oEmoji ||
            widget.xShape != oldWidget.xShape ||
            widget.oShape != oldWidget.oShape ||
            widget.useEmojis != oldWidget.useEmojis)) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isEnabled ? widget.onTap : null,
      child: Container(
        width: widget.cellSize,
        height: widget.cellSize,
        margin: EdgeInsets.all(widget.cellMargin),
        decoration: BoxDecoration(
          color: widget.isDarkMode
              ? AppTheme.darkSurfaceColor
              : AppTheme.lightSurfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF6B7280).withValues(alpha: 0.3),
          ),
        ),
        child: widget.animationsEnabled
            ? AnimatedBuilder(
                animation: _controller,
                child: PlayerSymbolWidget(
                  player: widget.player,
                  xShape: widget.xShape,
                  oShape: widget.oShape,
                  xEmoji: widget.xEmoji,
                  oEmoji: widget.oEmoji,
                  cellSize: widget.cellSize,
                ),
                builder: (BuildContext context, Widget? child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Transform.rotate(
                      angle: _rotationAnimation.value * 0.1,
                      child: child!,
                    ),
                  );
                },
              )
            : PlayerSymbolWidget(
                player: widget.player,
                xShape: widget.xShape,
                oShape: widget.oShape,
                xEmoji: widget.xEmoji,
                oEmoji: widget.oEmoji,
                cellSize: widget.cellSize,
              ),
      ),
    );
  }

}

