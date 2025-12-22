import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/widgets/effects/cosmic_background.dart';

class ModalBottomSheet extends StatelessWidget {

  const ModalBottomSheet({
    super.key,
    required this.title,
    required this.child,
    required this.isDarkMode,
    this.onClose,
  });
  final String title;
  final Widget child;
  final bool isDarkMode;
  final VoidCallback? onClose;

  static void show({
    required BuildContext context,
    required String title,
    required Widget child,
    required bool isDarkMode,
    VoidCallback? onClose,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.transparent,
      builder: (BuildContext bottomSheetContext) {
        final double screenHeight = MediaQuery.of(bottomSheetContext).size.height;
        final double safeAreaTop = MediaQuery.of(bottomSheetContext).padding.top;
        return Padding(
          padding: EdgeInsets.only(
            top: safeAreaTop,
            bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom,
          ),
          child: SizedBox(
            height: screenHeight - safeAreaTop,
            child: ModalBottomSheet(
              title: title,
              isDarkMode: isDarkMode,
              onClose: onClose ?? () => Navigator.of(bottomSheetContext).pop(),
              child: child,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppTheme.transparent,
        statusBarIconBrightness:
            isDarkMode ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
      ),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: CosmicBackground(
          isDarkMode: isDarkMode,
          child: SafeArea(
            minimum: const EdgeInsets.only(top: 24),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 16,
                bottom: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppTheme.darkTextPrimary.withValues(alpha: 0.3)
                            : AppTheme.lightTextSecondary
                                .withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      IconButton(
                        onPressed: onClose,
                        icon: Icon(
                          Icons.close,
                          color: isDarkMode
                              ? AppTheme.darkTextPrimary.withValues(alpha: 0.7)
                              : AppTheme.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                  Gap(AppSpacing.xl),
                  Expanded(
                    child: child,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
