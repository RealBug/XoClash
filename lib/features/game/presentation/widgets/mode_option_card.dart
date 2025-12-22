import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';

class ModeOptionCard extends StatelessWidget {

  const ModeOptionCard({
    super.key,
    this.cardKey,
    required this.mode,
    required this.icon,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.isNotSelected,
    required this.isDarkMode,
    required this.onTap,
  });
  final GameModeType mode;
  final IconData icon;
  final String title;
  final String description;
  final bool isSelected;
  final bool isNotSelected;
  final bool isDarkMode;
  final VoidCallback onTap;
  final GlobalKey? cardKey;

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkMode ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary;
    final secondaryTextColor = isDarkMode ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary;

    return AnimatedContainer(
      key: cardKey,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.only(bottom: 16),
      child: Opacity(
        opacity: isNotSelected ? 0.65 : 1.0,
        child: GestureDetector(
          onTap: onTap,
          child: Card(
            margin: EdgeInsets.zero,
            color: isSelected ? AppTheme.getPrimaryColor(isDarkMode).withValues(alpha: 0.2) : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isSelected ? AppTheme.getPrimaryColor(isDarkMode) : AppTheme.getBorderColor(isDarkMode),
                width: isSelected ? 2.5 : 1,
              ),
            ),
            elevation: isSelected ? 4 : 2,
            child: Padding(
              padding: AppSpacing.paddingSymmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.lg),
              child: Row(
                children: <Widget>[
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    padding: AppSpacing.paddingAll(AppSpacing.sm + 2),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: <Color>[
                                AppTheme.getPrimaryColor(isDarkMode).withValues(alpha: 0.3),
                                AppTheme.getPrimaryColor(isDarkMode).withValues(alpha: 0.2),
                              ],
                            )
                          : null,
                      color: isSelected
                          ? null
                          : isDarkMode
                              ? AppTheme.darkSurfaceColor.withValues(alpha: 0.3)
                              : AppTheme.lightSurfaceColor.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      icon,
                      size: 32,
                      color: isSelected
                          ? AppTheme.getPrimaryColor(isDarkMode)
                          : isDarkMode
                              ? AppTheme.darkTextPrimary.withValues(alpha: 0.8)
                              : AppTheme.lightTextSecondary,
                    ),
                  ),
                  Gap(AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          title,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.3,
                                color: isSelected ? AppTheme.getPrimaryColor(isDarkMode) : textColor,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Gap(AppSpacing.xs - 2),
                        Text(
                          description,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                height: 1.3,
                                color: secondaryTextColor,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    AnimatedScale(
                      scale: 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        padding: AppSpacing.paddingAll(AppSpacing.xs - 2),
                        decoration: BoxDecoration(
                          color: AppTheme.getPrimaryColor(isDarkMode),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: AppTheme.darkTextPrimary,
                          size: 18,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

