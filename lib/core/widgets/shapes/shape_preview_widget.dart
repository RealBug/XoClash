import 'package:flutter/material.dart';
import 'package:tictac/core/constants/app_constants.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/widgets/shapes/shape_selector.dart';
import 'package:tictac/core/widgets/shapes/symbol_painters.dart';

class ShapePreviewWidget extends StatelessWidget {

  const ShapePreviewWidget({
    super.key,
    required this.symbol,
    required this.shape,
    required this.color,
    required this.isSelected,
    this.isDarkMode = true,
  });
  final String symbol;
  final SymbolShape shape;
  final Color color;
  final bool isSelected;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final previewColor = isSelected
        ? color
        : (isDarkMode ? AppTheme.darkTextPrimary.withValues(alpha: 0.8) : AppTheme.lightTextPrimary.withValues(alpha: 0.7));

    const double baseSize = AppConstants.shapeSelectorBaseSize;
    const double reducedSize = baseSize * AppConstants.roundedOutlineSymbolSizeFactor;

    switch (shape) {
      case SymbolShape.classic:
        return Text(
          symbol,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: previewColor,
              ),
          textScaler: const TextScaler.linear(baseSize / 32),
        );
      case SymbolShape.rounded:
        return CustomPaint(
          size: const Size(reducedSize, reducedSize),
          painter: RoundedSymbolPainter(
            symbol: symbol,
            color: previewColor,
            strokeWidth: 3.5,
          ),
        );
      case SymbolShape.bold:
        return Text(
          symbol,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: previewColor,
                letterSpacing: -2,
              ),
          textScaler: const TextScaler.linear(baseSize / 32),
        );
      case SymbolShape.outline:
        return CustomPaint(
          size: const Size(reducedSize, reducedSize),
          painter: OutlineSymbolPainter(
            symbol: symbol,
            color: previewColor,
            strokeWidth: 2.5,
            useCenterPoint: true,
          ),
        );
    }
  }
}
