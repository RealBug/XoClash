import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/features/settings/domain/entities/settings.dart';

class InfoChip extends StatelessWidget {

  const InfoChip({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
    required this.settings,
  });
  final IconData icon;
  final String text;
  final Color color;
  final Settings settings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: settings.isDarkMode
            ? AppTheme.darkSurfaceColor.withValues(alpha: 0.3)
            : AppTheme.lightSurfaceColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 14, color: color),
          Gap(AppSpacing.xxs),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}

