import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/spacing/app_spacing.dart';

class AppSnackbarContent extends StatelessWidget {

  const AppSnackbarContent({
    super.key,
    required this.message,
    required this.textColor,
    this.icon,
  });
  final String message;
  final Color textColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.paddingSymmetric(
        horizontal: AppSpacing.xxs,
        vertical: AppSpacing.xxs * 0.5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(
              icon,
              color: textColor,
              size: 20,
            ),
            Gap(AppSpacing.sm),
          ],
          Flexible(
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  static SnackBar buildSnackBar({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required Color textColor,
    IconData? icon,
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 3),
    bool isFloating = true,
    EdgeInsets? margin,
    EdgeInsets? padding,
    double borderRadius = 100,
  }) {
    final EdgeInsets? defaultMargin = isFloating
        ? AppSpacing.paddingOnly(
            bottom: AppSpacing.lg,
            left: AppSpacing.md,
            right: AppSpacing.md,
          )
        : null;

    final EdgeInsets defaultPadding = padding ??
        AppSpacing.paddingSymmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        );

    return SnackBar(
      content: AppSnackbarContent(
        message: message,
        textColor: textColor,
        icon: icon,
      ),
      backgroundColor: backgroundColor,
      behavior: isFloating ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
      margin: margin ?? defaultMargin,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      elevation: 4,
      padding: defaultPadding,
      duration: duration,
      action: action,
    );
  }
}

