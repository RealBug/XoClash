import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/l10n/app_localizations.dart';

/// Wrapper for emoji selector scenarios with theme and localizations
class EmojiSelectorScenario extends StatelessWidget {
  const EmojiSelectorScenario({
    super.key,
    required this.child,
    this.isDarkMode = true,
  });

  final Widget child;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const <Locale>[Locale('en'), Locale('fr')],
        locale: const Locale('en'),
        home: Scaffold(
          backgroundColor: isDarkMode ? AppTheme.darkSurfaceColor : AppTheme.lightSurfaceColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: AppSpacing.paddingAll(AppSpacing.md),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

