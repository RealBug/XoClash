import 'package:flutter/material.dart';
import 'package:tictac/core/constants/app_constants.dart';
import 'package:tictac/core/widgets/shapes/shape_selector.dart';
import 'package:tictac/core/widgets/shapes/symbol_painters.dart';

class GameShapeWidget extends StatelessWidget {

  const GameShapeWidget({
    super.key,
    required this.symbol,
    required this.shape,
    required this.color,
  });
  final String symbol;
  final String shape;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final SymbolShape shapeEnum = SymbolShapeExtension.fromStringOrDefault(shape);

    const double fontSize = 16.0;
    const double reducedSize = fontSize * AppConstants.roundedOutlineSymbolSizeFactor;

    switch (shapeEnum) {
      case SymbolShape.classic:
        return Text(
          symbol,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        );
      case SymbolShape.rounded:
        return SizedBox(
          width: fontSize + 2,
          height: fontSize + 2,
          child: CustomPaint(
            size: const Size(reducedSize, reducedSize),
            painter: RoundedSymbolPainter(
              symbol: symbol,
              color: color,
              strokeWidth: fontSize * 0.08,
              usePathForX: true,
            ),
          ),
        );
      case SymbolShape.bold:
        return Text(
          symbol,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: color,
                letterSpacing: -1,
              ),
        );
      case SymbolShape.outline:
        return SizedBox(
          width: fontSize + 2,
          height: fontSize + 2,
          child: CustomPaint(
            size: const Size(reducedSize, reducedSize),
            painter: OutlineSymbolPainter(
              symbol: symbol,
              color: color,
              strokeWidth: fontSize * 0.06,
            ),
          ),
        );
    }
  }
}

