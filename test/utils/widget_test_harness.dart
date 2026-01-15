import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictac/features/settings/domain/entities/settings.dart';
import 'package:tictac/features/settings/presentation/providers/settings_providers.dart';
import 'package:tictac/features/user/domain/entities/user.dart' as app_user;
import 'package:tictac/features/user/presentation/providers/user_providers.dart';
import 'package:tictac/l10n/app_localizations.dart';

class FakeSettingsNotifier extends SettingsNotifier {
  FakeSettingsNotifier(this._settings);

  final Settings _settings;

  @override
  Future<Settings> build() async => _settings;

  @override
  Future<void> toggleDarkMode() async {
    final Settings currentSettings = state.value ?? const Settings();
    state = AsyncData<Settings>(currentSettings.copyWith(isDarkMode: !currentSettings.isDarkMode));
  }

  @override
  Future<void> toggleSoundFx() async {
    final Settings currentSettings = state.value ?? const Settings();
    state = AsyncData<Settings>(currentSettings.copyWith(soundFxEnabled: !currentSettings.soundFxEnabled));
  }

  @override
  Future<void> toggleAnimations() async {
    final Settings currentSettings = state.value ?? const Settings();
    state = AsyncData<Settings>(currentSettings.copyWith(animationsEnabled: !currentSettings.animationsEnabled));
  }
}

class FakeUserNotifier extends UserNotifier {
  FakeUserNotifier(this._user);

  final app_user.User? _user;

  @override
  Future<app_user.User?> build() async => _user;
}

bool _uiTestEnvironmentInitialized = false;

Future<void> setUpUiTestEnvironment() async {
  if (_uiTestEnvironmentInitialized) {
    return;
  }
  SharedPreferences.setMockInitialValues(<String, Object>{});
  PackageInfo.setMockInitialValues(
    appName: 'XO Clash',
    packageName: 'tictac',
    version: '1.0.0',
    buildNumber: '1',
    buildSignature: 'test',
  );
  _uiTestEnvironmentInitialized = true;
}

Widget buildTestApp({
  required Widget screen,
  Settings settings = const Settings(),
  app_user.User? user,
  List<dynamic> overrides = const [],
  Locale locale = const Locale('en'),
}) {
  return ProviderScope(
    overrides: [
      settingsProvider.overrideWith(() => FakeSettingsNotifier(settings)),
      userProvider.overrideWith(() => FakeUserNotifier(user)),
      ...overrides,
    ],
    child: MaterialApp(
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[
        Locale('fr'),
        Locale('en'),
      ],
      locale: locale,
      home: screen,
    ),
  );
}

