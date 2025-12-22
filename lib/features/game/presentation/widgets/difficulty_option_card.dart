import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/widgets/ai/ai_character.dart';

class DifficultyOptionCard extends StatelessWidget {

  const DifficultyOptionCard({
    super.key,
    required this.difficulty,
    required this.isSelected,
    required this.isDarkMode,
    required this.onTap,
  });
  final int difficulty;
  final bool isSelected;
  final bool isDarkMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final character = AICharacter.getCharacter(difficulty);
    final textColor = isDarkMode ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary;
    final secondaryTextColor = isDarkMode ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          margin: EdgeInsets.zero,
          color: isSelected ? character.color.withValues(alpha: 0.2) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isSelected ? character.color : AppTheme.getBorderColor(isDarkMode, opacity: 0.5),
              width: isSelected ? 2.5 : 1,
            ),
          ),
          elevation: isSelected ? 4 : 2,
          child: Padding(
            padding: AppSpacing.paddingSymmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg - 2),
            child: Row(
              children: <Widget>[
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  padding: AppSpacing.paddingAll(AppSpacing.sm),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[
                              character.color.withValues(alpha: 0.3),
                              character.color.withValues(alpha: 0.2),
                            ],
                          )
                        : null,
                    color: isSelected
                        ? null
                        : isDarkMode
                            ? AppTheme.darkSurfaceColor.withValues(alpha: 0.3)
                            : AppTheme.lightSurfaceColor.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    character.emoji,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
                Gap(AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        character.getDisplayName(context),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                              color: isSelected ? character.color : textColor,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Gap(AppSpacing.xxs),
                      Text(
                        character.getSubtitle(context),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              height: 1.3,
                              color: secondaryTextColor,
                            ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
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
                        color: character.color,
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
    );
  }
}


