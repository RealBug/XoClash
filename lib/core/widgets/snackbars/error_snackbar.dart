import 'package:flutter/material.dart';
import 'package:tictac/core/constants/error_constants.dart';
import 'package:tictac/core/domain/errors/app_exception.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';
import 'package:tictac/core/presentation/errors/app_exception_localizations.dart';
import 'package:tictac/core/widgets/snackbars/app_snackbar_content.dart';
import 'package:tictac/l10n/app_localizations.dart';

class ErrorSnackbar {
  ErrorSnackbar._();

  static void show(
    BuildContext context,
    AppException error, {
    VoidCallback? onRetry,
    Duration duration = const Duration(seconds: 4),
  }) {
    final AppLocalizations l10n = context.l10n;
    final SnackBar snackBar = AppSnackbarContent.buildSnackBar(
      context: context,
      message: error.getUserMessage(l10n),
      backgroundColor: Colors.red.shade700,
      textColor: Colors.white,
      icon: Icons.error_outline,
      action: error.isRetryable && onRetry != null
          ? SnackBarAction(
              label: ErrorSnackbarLabels.retry,
              textColor: Colors.white,
              onPressed: onRetry,
            )
          : null,
      duration: duration,
      isFloating: false,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showFromError(
    BuildContext context,
    Object error, {
    VoidCallback? onRetry,
    Duration duration = const Duration(seconds: 4),
  }) {
    final AppException appException = error is AppException
        ? error
        : AppException.unknown(
            translationKey: ErrorTranslationKeys.unknown,
            originalError: error,
          );

    show(context, appException, onRetry: onRetry, duration: duration);
  }
}
