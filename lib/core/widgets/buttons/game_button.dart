import 'package:flutter/material.dart';
import 'package:tictac/core/constants/ui_constants.dart';
import 'package:tictac/core/theme/app_theme.dart';

class GameButton extends StatelessWidget {

  const GameButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  });
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        backgroundColor ?? AppTheme.getPrimaryColor(isDarkMode);
    final isDisabled = onPressed == null || isLoading;
    final buttonTextColor = textColor ??
        (isOutlined
            ? (isDisabled
                ? (isDarkMode
                    ? AppTheme.darkTextPrimary.withValues(alpha: 0.3)
                    : AppTheme.lightTextSecondary)
                : primaryColor)
            : (isDisabled
                ? (isDarkMode
                    ? AppTheme.darkTextPrimary.withValues(alpha: 0.3)
                    : AppTheme.lightTextSecondary)
                : AppTheme.darkTextPrimary));
    final buttonBorderColor = borderColor ?? primaryColor;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(UIConstants.borderRadiusCircular),
        boxShadow: onPressed != null && !isLoading
            ? <BoxShadow>[
                BoxShadow(
                  color: AppTheme.darkBackgroundColor
                      .withValues(alpha: isOutlined ? 0.1 : 0.15),
                  offset: Offset(0, isOutlined ? 3 : 4),
                ),
                BoxShadow(
                  color: AppTheme.darkBackgroundColor
                      .withValues(alpha: isOutlined ? 0.05 : 0.1),
                  offset: Offset(0, isOutlined ? 1 : 2),
                ),
              ]
            : null,
        color: isOutlined
            ? (isDarkMode
                ? AppTheme.darkTextPrimary.withValues(alpha: 0.05)
                : AppTheme.lightCardColor)
            : (isDarkMode && !isOutlined
                ? AppTheme.darkTextPrimary.withValues(alpha: 0.05)
                : null),
      ),
      child: isOutlined && icon != null
          ? OutlinedButton.icon(
              onPressed: isLoading ? null : onPressed,
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(UIConstants.borderRadiusSmall),
                ),
                child: Icon(
                  icon,
                  color: primaryColor,
                  size: 20,
                ),
              ),
              label: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.darkTextPrimary),
                      ),
                    )
                  : Text(
                      text,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: buttonTextColor,
                            letterSpacing: 1,
                          ),
                    ),
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                side: BorderSide(
                  color: buttonBorderColor,
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(UIConstants.borderRadiusCircular),
                ),
                minimumSize: const Size(double.infinity, 66),
                fixedSize: const Size.fromHeight(66),
              ),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                backgroundColor:
                    isOutlined ? AppTheme.transparent : primaryColor,
                elevation: 0,
                minimumSize: const Size(double.infinity, 66),
                fixedSize: const Size.fromHeight(66),
                disabledBackgroundColor: isDarkMode
                    ? AppTheme.darkTextPrimary.withValues(alpha: 0.1)
                    : AppTheme.lightTextSecondary.withValues(alpha: 0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(UIConstants.borderRadiusCircular),
                  side: isOutlined
                      ? BorderSide(
                          color: buttonBorderColor,
                          width: 2,
                        )
                      : BorderSide(
                          color: isDisabled
                              ? (isDarkMode
                                  ? AppTheme.darkTextPrimary
                                      .withValues(alpha: 0.15)
                                  : AppTheme.lightTextSecondary
                                      .withValues(alpha: 0.25))
                              : primaryColor.withValues(alpha: 0.3),
                          width: 2,
                        ),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.darkTextPrimary),
                      ),
                    )
                  : Text(
                      text,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: buttonTextColor,
                            letterSpacing: 1,
                          ),
                    ),
            ),
    );
  }
}
