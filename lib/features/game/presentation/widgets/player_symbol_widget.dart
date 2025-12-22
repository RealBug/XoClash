import 'package:flutter/material.dart';
import 'package:tictac/core/constants/app_constants.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/widgets/shapes/shape_selector.dart' show SymbolShape, SymbolShapeExtension;
import 'package:tictac/core/widgets/shapes/symbol_painters.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';

class PlayerSymbolWidget extends StatelessWidget {

  const PlayerSymbolWidget({
    super.key,
    required this.player,
    required this.xShape,
    required this.oShape,
    this.xEmoji,
    this.oEmoji,
    required this.cellSize,
  });
  final Player player;
  final String xShape;
  final String oShape;
  final String? xEmoji;
  final String? oEmoji;
  final double cellSize;

  @override
  Widget build(BuildContext context) {
    if (player == Player.none) {
      return const SizedBox.shrink();
    }

    final isX = player == Player.x;
    final color = isX ? AppTheme.redAccent : AppTheme.yellowAccent;
    final shape = isX ? xShape : oShape;
    final emoji = isX ? xEmoji : oEmoji;

    final double fontSize = cellSize * 0.56;

    if (emoji != null && emoji.isNotEmpty) {
      return Center(
        child: Text(
          emoji,
          style: Theme.of(context).textTheme.displayLarge,
          textScaler: TextScaler.linear(fontSize * 0.8 / 32),
        ),
      );
    }

    return Center(
      child: _buildSymbol(
        context,
        isX
            ? AppConstants.defaultPlayerSymbolX
            : AppConstants.defaultPlayerSymbolO,
        shape,
        fontSize,
        color,
      ),
    );
  }

  Widget _buildSymbol(
    BuildContext context,
    String symbol,
    String shape,
    double fontSize,
    Color color,
  ) {
    final SymbolShape shapeEnum = SymbolShapeExtension.fromStringOrDefault(shape);

    final double reducedSize = fontSize * AppConstants.roundedOutlineSymbolSizeFactor;

    switch (shapeEnum) {
      case SymbolShape.classic:
        return Text(
          symbol,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
                shadows: <Shadow>[
                  Shadow(
                    color: color.withValues(alpha: 0.5),
                    blurRadius: 20,
                  ),
                ],
              ),
          textScaler: TextScaler.linear(fontSize / 32),
        );
      case SymbolShape.rounded:
        return CustomPaint(
          size: Size(reducedSize, reducedSize),
          painter: RoundedSymbolPainter(
            symbol: symbol,
            color: color,
            strokeWidth: fontSize * 0.08,
          ),
        );
      case SymbolShape.bold:
        return Text(
          symbol,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: color,
                letterSpacing: -2,
                shadows: <Shadow>[
                  Shadow(
                    color: color.withValues(alpha: 0.5),
                    blurRadius: 20,
                  ),
                ],
              ),
          textScaler: TextScaler.linear(fontSize / 32),
        );
      case SymbolShape.outline:
        return CustomPaint(
          size: Size(reducedSize, reducedSize),
          painter: OutlineSymbolPainter(
            symbol: symbol,
            color: color,
            strokeWidth: fontSize * 0.06,
            useCenterPoint: true,
          ),
        );
    }
  }
}


