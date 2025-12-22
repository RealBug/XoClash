import 'package:flutter/material.dart';
import 'package:tictac/core/constants/game_constants.dart';
import 'package:tictac/core/widgets/snackbars/app_snackbar_content.dart';
import 'package:tictac/features/game/presentation/widgets/game_result_helper.dart';

class GameResultSnackBar {
  GameResultSnackBar._();

  static void show(
    BuildContext context,
    GameResultData data,
  ) {
    final SnackBar snackBar = AppSnackbarContent.buildSnackBar(
      context: context,
      message: data.message,
      backgroundColor: data.backgroundColor.withValues(alpha: 0.95),
      textColor: data.textColor,
      icon: data.showTrophy ? Icons.emoji_events : null,
      duration: GameConstants.snackBarDuration,
      margin: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      borderRadius: 50,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

