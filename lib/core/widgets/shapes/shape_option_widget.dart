import 'package:flutter/material.dart';
import 'package:tictac/core/constants/app_constants.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/widgets/shapes/shape_preview_widget.dart';
import 'package:tictac/core/widgets/shapes/shape_selector.dart';

class ShapeOptionWidget extends StatelessWidget {

  const ShapeOptionWidget({
    super.key,
    required this.shape,
    required this.isX,
    required this.isSelected,
    required this.color,
    required this.onSelected,
    this.isDarkMode = true,
  });
  final SymbolShape shape;
  final bool isX;
  final bool isSelected;
  final Color color;
  final Function(SymbolShape) onSelected;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onSelected(shape),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.2)
                : (isDarkMode
                    ? AppTheme.darkCardColor.withValues(alpha: 0.5)
                    : AppTheme.lightSurfaceColor),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? color
                  : (isDarkMode
                      ? AppTheme.darkTextPrimary.withValues(alpha: 0.1)
                      : AppTheme.lightTextSecondary.withValues(alpha: 0.2)),
              width: isSelected ? 2.5 : 1,
            ),
          ),
          child: Center(
            child: ShapePreviewWidget(
              symbol: isX
                  ? AppConstants.defaultPlayerSymbolX
                  : AppConstants.defaultPlayerSymbolO,
              shape: shape,
              color: AppTheme.getPrimaryColor(isDarkMode),
              isSelected: isSelected,
              isDarkMode: isDarkMode,
            ),
          ),
        ),
      ),
    );
  }
}

