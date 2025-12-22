import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/widgets/shapes/shape_option_widget.dart';
import 'package:tictac/core/widgets/shapes/shape_selector.dart';

class ShapeSectionWidget extends StatelessWidget {

  const ShapeSectionWidget({
    super.key,
    required this.isX,
    required this.selectedShape,
    required this.color,
    required this.onSelected,
    this.isDarkMode = true,
  });
  final bool isX;
  final SymbolShape? selectedShape;
  final Color color;
  final Function(SymbolShape) onSelected;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          isX ? context.l10n.shapeX : context.l10n.shapeO,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        Gap(AppSpacing.sm),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: SymbolShape.values.map((SymbolShape shape) {
            final isSelected = selectedShape != null && selectedShape == shape;
            return ShapeOptionWidget(
              shape: shape,
              isX: isX,
              isSelected: isSelected,
              color: color,
              onSelected: onSelected,
              isDarkMode: isDarkMode,
            );
          }).toList(),
        ),
      ],
    );
  }
}

