import 'package:flutter/material.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';

/// Wraps child with MaterialApp + Scaffold for themed scenarios
class ThemedScaffold extends StatelessWidget {
  const ThemedScaffold({super.key, required this.child, this.isDarkMode = true});

  final Widget child;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
      home: Scaffold(
        backgroundColor: isDarkMode ? AppTheme.darkBackgroundColor : AppTheme.lightBackgroundColor,
        body: Padding(padding: AppSpacing.paddingAll(AppSpacing.md), child: child),
      ),
    );
  }
}
