import 'package:flutter/material.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';

class TabButtonWidget extends StatelessWidget {

  const TabButtonWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.isDarkMode,
    required this.onTap,
  });
  final String label;
  final bool isSelected;
  final bool isDarkMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppSpacing.paddingSymmetric(vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.getPrimaryColor(isDarkMode).withValues(alpha: 0.2)
              : (isDarkMode
                  ? AppTheme.darkCardColor.withValues(alpha: 0.5)
                  : AppTheme.lightSurfaceColor),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppTheme.getPrimaryColor(isDarkMode)
                : (isDarkMode
                    ? AppTheme.darkTextPrimary.withValues(alpha: 0.1)
                    : AppTheme.lightTextSecondary.withValues(alpha: 0.2)),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? AppTheme.getPrimaryColor(isDarkMode)
                      : (isDarkMode
                          ? AppTheme.darkTextPrimary.withValues(alpha: 0.8)
                          : AppTheme.lightTextPrimary),
                ),
          ),
        ),
      ),
    );
  }
}

