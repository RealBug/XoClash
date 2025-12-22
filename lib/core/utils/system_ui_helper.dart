import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tictac/core/theme/app_theme.dart';

class SystemUIHelper {
  SystemUIHelper._();

  /// Set system UI overlay style based on dark mode
  static void setStatusBarStyle(BuildContext context, bool isDarkMode) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppTheme.transparent,
        statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
      ),
    );
  }

  /// Set system UI overlay style with custom colors
  static void setStatusBarStyleCustom({
    required BuildContext context,
    required Color statusBarColor,
    required Brightness statusBarIconBrightness,
    required Brightness statusBarBrightness,
  }) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: statusBarColor,
        statusBarIconBrightness: statusBarIconBrightness,
        statusBarBrightness: statusBarBrightness,
      ),
    );
  }
}


