import 'package:flutter/material.dart';
import 'package:tictac/core/widgets/snackbars/error_snackbar.dart';

class AuthHelper {
  AuthHelper._();

  static Future<void> handleSocialAuth({
    required BuildContext context,
    required Future<void> Function() authMethod,
    required VoidCallback onSuccess,
  }) async {
    try {
      await authMethod();
      if (!context.mounted) {
        return;
      }
      onSuccess();
    } catch (e) {
      if (!context.mounted) {
        return;
      }
      ErrorSnackbar.showFromError(context, e);
    }
  }
}
