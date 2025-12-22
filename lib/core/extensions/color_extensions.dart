import 'package:flutter/material.dart';
import 'package:tictac/core/theme/app_theme.dart';

extension ColorExtensions on bool {
  Color textColorSecondary([double alpha = 1.0]) {
    return (this
            ? AppTheme.darkTextSecondary
            : AppTheme.lightTextSecondary)
        .withValues(alpha: alpha);
  }

  Color textColorPrimary([double alpha = 1.0]) {
    return (this ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary)
        .withValues(alpha: alpha);
  }

  Color textColorHint([double alpha = 1.0]) {
    return (this ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary)
        .withValues(alpha: alpha * 0.6);
  }

  Color cardBackground([double alpha = 1.0]) {
    return (this ? AppTheme.darkCardColor : AppTheme.lightCardColor)
        .withValues(alpha: alpha);
  }

  Color borderColor([double alpha = 1.0]) {
    return (this ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary)
        .withValues(alpha: alpha * 0.2);
  }
}





