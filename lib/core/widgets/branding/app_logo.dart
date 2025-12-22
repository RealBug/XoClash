import 'package:flutter/material.dart';
import 'package:tictac/core/constants/app_constants.dart';
import 'package:tictac/core/theme/app_theme.dart';

class AppLogo extends StatelessWidget {

  const AppLogo({
    super.key,
    required this.isDarkMode,
    this.fontSize = 48,
    this.blurRadius = 25,
    this.spreadRadius = 4,
    this.shadowBlurRadius = 15,
    this.shadowSpreadRadius = 2,
  });
  final bool isDarkMode;
  final double fontSize;
  final double blurRadius;
  final double spreadRadius;
  final double shadowBlurRadius;
  final double shadowSpreadRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppTheme.appIconSize,
      height: AppTheme.appIconSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.appIconBorderRadius),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppTheme.getPrimaryColor(isDarkMode).withValues(alpha: 0.3),
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
          ),
          BoxShadow(
            color: AppTheme.darkBackgroundColor.withValues(alpha: 0.2),
            blurRadius: shadowBlurRadius,
            spreadRadius: shadowSpreadRadius,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.appIconBorderRadius),
        child: Image.asset(
          'assets/app_icon.png',
          width: AppTheme.appIconSize,
          height: AppTheme.appIconSize,
          fit: BoxFit.cover,
          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
            return Container(
              width: AppTheme.appIconSize,
              height: AppTheme.appIconSize,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(AppTheme.appIconBorderRadius),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    const Color(0xFFFF6B35),
                    const Color(0xFFFF3B5C),
                    AppTheme.getPrimaryColor(isDarkMode),
                  ],
                  stops: const <double>[0.0, 0.5, 1.0],
                ),
              ),
              child: Center(
                child: Text(
                  AppConstants.appNameShort,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: AppTheme.darkTextPrimary,
                        letterSpacing: -2,
                      ),
                  textScaler: TextScaler.linear(fontSize / 32),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
