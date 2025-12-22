import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/l10n/app_localizations.dart';

/// Wraps child with MaterialApp + Scaffold + Localizations for themed scenarios
class ThemedScaffoldWithLocalizations extends StatelessWidget {
  const ThemedScaffoldWithLocalizations({
    super.key,
    required this.child,
    this.isDarkMode = true,
    this.locale = const Locale('en'),
  });

  final Widget child;
  final bool isDarkMode;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[Locale('en'), Locale('fr')],
      locale: locale,
      home: Scaffold(
        backgroundColor: isDarkMode ? AppTheme.darkBackgroundColor : AppTheme.lightBackgroundColor,
        body: Padding(padding: AppSpacing.paddingAll(AppSpacing.md), child: child),
      ),
    );
  }
}

