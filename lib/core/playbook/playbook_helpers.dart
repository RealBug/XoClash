import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/core/widgets/inputs/username_text_field.dart';
import 'package:tictac/features/settings/domain/entities/settings.dart';
import 'package:tictac/features/settings/presentation/providers/settings_providers.dart';
import 'package:tictac/l10n/app_localizations.dart';

/// Fake settings notifier for playbook stories
class FakeSettingsNotifier extends SettingsNotifier {
  FakeSettingsNotifier(this._settings);

  final Settings _settings;

  @override
  Future<Settings> build() async => _settings;
}

// ============================================================================
// CONSTANTS
// ============================================================================

const List<LocalizationsDelegate<Object>> defaultLocalizationsDelegates = <LocalizationsDelegate<Object>>[
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

const List<Locale> defaultSupportedLocales = <Locale>[Locale('fr'), Locale('en')];

// ============================================================================
// SCAFFOLD HELPERS
// ============================================================================

/// Wraps child with MaterialApp + Scaffold for dark theme scenarios
class DarkScaffold extends StatelessWidget {
  const DarkScaffold({
    super.key,
    required this.child,
    this.withLocalizations = false,
  });

  final Widget child;
  final bool withLocalizations;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      localizationsDelegates:
          withLocalizations ? defaultLocalizationsDelegates : null,
      supportedLocales:
          withLocalizations ? defaultSupportedLocales : const <Locale>[Locale('en')],
      home: Scaffold(
        backgroundColor: AppTheme.darkBackgroundColor,
        body: Padding(padding: AppSpacing.paddingAll(AppSpacing.md), child: child),
      ),
    );
  }
}

/// Wraps child with MaterialApp + Scaffold for light theme scenarios
class LightScaffold extends StatelessWidget {
  const LightScaffold({
    super.key,
    required this.child,
    this.withLocalizations = false,
  });

  final Widget child;
  final bool withLocalizations;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      localizationsDelegates:
          withLocalizations ? defaultLocalizationsDelegates : null,
      supportedLocales:
          withLocalizations ? defaultSupportedLocales : const <Locale>[Locale('en')],
      home: Scaffold(
        backgroundColor: AppTheme.lightBackgroundColor,
        body: Padding(padding: AppSpacing.paddingAll(AppSpacing.md), child: child),
      ),
    );
  }
}

/// Wraps child with ProviderScope for settings-dependent scenarios
class WithSettings extends StatelessWidget {
  const WithSettings({
    super.key,
    required this.child,
    this.isDarkMode = true,
  });

  final Widget child;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        settingsProvider.overrideWith(
          () => FakeSettingsNotifier(Settings(isDarkMode: isDarkMode)),
        ),
      ],
      child: child,
    );
  }
}

// ============================================================================
// WIDGET HELPERS
// ============================================================================

/// Avatar circle button used in multiple scenarios
class AvatarCircle extends StatelessWidget {
  const AvatarCircle({
    super.key,
    required this.emoji,
    required this.isDarkMode,
  });

  final String emoji;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppTheme.getPrimaryColor(isDarkMode).withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppTheme.getPrimaryColor(isDarkMode).withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(emoji, style: Theme.of(context).textTheme.headlineSmall),
      ),
    );
  }
}

/// Username field with avatar row - reusable widget
class UsernameWithAvatar extends StatelessWidget {
  const UsernameWithAvatar({
    super.key,
    required this.emoji,
    required this.isDarkMode,
  });

  final String emoji;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: UsernameTextField(
                controller: TextEditingController(),
                labelText: 'Username',
                hintText: 'Enter your username',
                isDarkMode: isDarkMode,
              ),
            ),
            Gap(AppSpacing.sm),
            GestureDetector(
              onTap: () {},
              child: AvatarCircle(emoji: emoji, isDarkMode: isDarkMode),
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================================
// CARD HELPERS
// ============================================================================

/// Wraps child with ProviderScope + MaterialApp for scenarios needing settings
class ThemedScenario extends StatelessWidget {
  const ThemedScenario({
    super.key,
    required this.child,
    required this.isDarkMode,
  });

  final Widget child;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        settingsProvider.overrideWith(
          () => FakeSettingsNotifier(Settings(isDarkMode: isDarkMode)),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
        localizationsDelegates: defaultLocalizationsDelegates,
        supportedLocales: defaultSupportedLocales,
        home: Scaffold(
          backgroundColor: isDarkMode
              ? AppTheme.darkBackgroundColor
              : AppTheme.lightBackgroundColor,
          body: Padding(
            padding: AppSpacing.paddingAll(AppSpacing.md),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Simple card with title and description
class SimpleCard extends StatelessWidget {
  const SimpleCard({
    super.key,
    required this.title,
    required this.description,
    required this.isDarkMode,
    this.elevation = 0,
    this.shadowColor,
    this.side,
  });

  final String title;
  final String description;
  final bool isDarkMode;
  final double elevation;
  final Color? shadowColor;
  final BorderSide? side;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isDarkMode ? AppTheme.darkCardColor : AppTheme.lightCardColor,
      elevation: elevation,
      shadowColor: shadowColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: side ??
            BorderSide(
              color: AppTheme.getBorderColor(isDarkMode,
                  opacity: isDarkMode ? 0.12 : 0.3),
            ),
      ),
      child: Padding(
        padding: AppSpacing.paddingAll(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Gap(AppSpacing.xs),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
