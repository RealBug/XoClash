import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/widgets/formatters/username_formatter.dart';

class UsernameTextField extends StatelessWidget {

  const UsernameTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.isDarkMode,
    this.focusNode,
    this.autofocus = false,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
  });
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String labelText;
  final String hintText;
  final bool isDarkMode;
  final bool autofocus;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        filled: true,
        fillColor: isDarkMode
            ? AppTheme.darkSurfaceColor.withValues(alpha: 0.3)
            : AppTheme.lightSurfaceColor,
        labelStyle: Theme.of(context).textTheme.bodyMedium,
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDarkMode
                  ? AppTheme.darkTextSecondary.withValues(alpha: 0.6)
                  : AppTheme.lightTextSecondary.withValues(alpha: 0.7),
            ),
        contentPadding: AppSpacing.paddingSymmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg + 2,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: AppTheme.getBorderColor(isDarkMode, opacity: 0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: AppTheme.getBorderColor(isDarkMode, opacity: 0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: AppTheme.getPrimaryColor(isDarkMode),
            width: 2.5,
          ),
        ),
      ),
      style: Theme.of(context).textTheme.bodyLarge,
      textCapitalization: TextCapitalization.words,
      inputFormatters: <TextInputFormatter>[UsernameTextFormatter()],
      autofocus: autofocus,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
