import 'package:flutter/material.dart';
import 'package:tictac/core/theme/app_theme.dart';

class AvatarOptionWidget extends StatelessWidget {

  const AvatarOptionWidget({
    super.key,
    required this.avatar,
    required this.isSelected,
    required this.onTap,
    required this.isDarkMode,
  });
  final String avatar;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.getPrimaryColor(isDarkMode).withValues(alpha: 0.2)
              : (isDarkMode
                  ? const Color(0xFF3A2A6B).withValues(alpha: 0.3)
                  : AppTheme.lightSurfaceColor),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppTheme.getPrimaryColor(isDarkMode)
                : AppTheme.getBorderColor(isDarkMode, opacity: 0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        padding: const EdgeInsets.all(4),
        child: Center(
          child: FittedBox(
            child: Text(
              avatar,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 40,
                    height: 1.0,
                  ),
              textAlign: TextAlign.center,
              textHeightBehavior: const TextHeightBehavior(
                applyHeightToFirstAscent: false,
                applyHeightToLastDescent: false,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

