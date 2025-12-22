import 'package:flutter/material.dart';
import 'package:tictac/core/theme/app_theme.dart';

class BoardVisualCell extends StatelessWidget {

  const BoardVisualCell({
    super.key,
    required this.size,
    required this.spacing,
    required this.isSelected,
    required this.isDarkMode,
    this.isLastInRow = false,
    this.isLastInColumn = false,
  });
  final double size;
  final double spacing;
  final bool isSelected;
  final bool isDarkMode;
  final bool isLastInRow;
  final bool isLastInColumn;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: EdgeInsets.only(
        right: isLastInRow ? 0 : spacing,
        bottom: isLastInColumn ? 0 : spacing,
      ),
      decoration: BoxDecoration(
        color: isSelected
            ? AppTheme.getPrimaryColor(isDarkMode).withValues(alpha: 0.3)
            : isDarkMode
                ? AppTheme.darkTextPrimary.withValues(alpha: 0.1)
                : AppTheme.lightTextSecondary.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
