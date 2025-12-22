import 'package:flutter/material.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/widgets/snackbars/app_snackbar_content.dart';

class WarningSnackbar {
  WarningSnackbar._();

  static void show(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    final SnackBar snackBar = AppSnackbarContent.buildSnackBar(
      context: context,
      message: message,
      backgroundColor: AppTheme.yellowAccent,
      textColor: Colors.white,
      duration: duration,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

