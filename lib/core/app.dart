import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictac/core/routing/app_router.dart';
import 'package:tictac/core/theme/app_theme.dart';
import 'package:tictac/features/settings/presentation/providers/settings_providers.dart'
    show isDarkModeProvider, languageCodeProvider;
import 'package:tictac/l10n/app_localizations.dart';

class TicTacApp extends ConsumerStatefulWidget {
  const TicTacApp({super.key});

  @override
  ConsumerState<TicTacApp> createState() => _TicTacAppState();
}

class _TicTacAppState extends ConsumerState<TicTacApp> {
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    try {
      final isDarkMode = ref.watch(isDarkModeProvider);
      final languageCode = ref.watch(languageCodeProvider);

      if (!kIsWeb) {
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: AppTheme.transparent,
            statusBarIconBrightness:
                isDarkMode ? Brightness.light : Brightness.dark,
            statusBarBrightness:
                isDarkMode ? Brightness.dark : Brightness.light,
          ),
        );
      }

      return MaterialApp.router(
        onGenerateTitle: (BuildContext context) => AppLocalizations.of(context)!.appTitle,
        theme: AppTheme.lightTheme.copyWith(
          scaffoldBackgroundColor: AppTheme.darkBackgroundColor,
        ),
        darkTheme: AppTheme.darkTheme,
        themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const <Locale>[
          Locale('en'),
          Locale('fr'),
        ],
        locale: Locale(languageCode),
        routerConfig: _appRouter.config(),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.noScaling),
            child: child ?? const SizedBox.shrink(),
          );
        },
      );
    } catch (e, stackTrace) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Error loading app'),
                Text(e.toString()),
                if (kDebugMode)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Builder(
                      builder: (BuildContext context) => Text(
                        stackTrace.toString(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 10,
                            ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
