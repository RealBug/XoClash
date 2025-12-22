import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tictac/core/app.dart';
import 'package:tictac/core/constants/game_constants.dart';
import 'package:tictac/core/di/injection.dart';
import 'package:tictac/core/services/logger_service.dart';
import 'package:tictac/core/services/logger_service_impl.dart';
import 'package:tictac/core/spacing/app_spacing.dart';
import 'package:tictac/core/theme/app_theme.dart';

final LoggerService _earlyLogger = LoggerServiceImpl();

LoggerService _logger() {
  if (getIt.isRegistered<LoggerService>()) {
    return getIt<LoggerService>();
  }
  return _earlyLogger;
}

void main() async {
  if (kIsWeb) {
    try {
      usePathUrlStrategy();
    } catch (e) {
      _logger().warning('Could not set path URL strategy: $e');
    }
  }

  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    if (kIsWeb) {
      _logger().error('Flutter Error', details.exception, details.stack);
    }
  };

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.error_outline,
                size: 48, color: AppTheme.redAccent),
            Gap(AppSpacing.md),
            const Text('An error occurred'),
            if (kIsWeb) ...<Widget>[
              Gap(AppSpacing.xs),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Builder(
                  builder: (BuildContext context) => Text(
                    details.exception.toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  };

  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    _logger().error('Platform Error', error, stack);
    return true;
  };

  // Initialize Firebase (optional - only needed for online mode)
  // To set up Firebase, run: flutterfire configure
  // See docs/FIREBASE_SETUP.md for complete guide
  try {
    await Firebase.initializeApp();
    _logger().info('Firebase initialized successfully');
  } catch (e) {
    _logger()
        .warning('Firebase not initialized - only offline modes available: $e');
    // This is OK - offline modes (Local Friend, Computer) will still work
  }

  try {
    configureDependencies();
  } catch (e, stackTrace) {
    _logger().error('Error configuring dependencies', e, stackTrace);
    if (kIsWeb) {
      runApp(
        const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Center(
              child: Text('Error initializing app. Please check console.'),
            ),
          ),
        ),
      );
      return;
    }
    rethrow;
  }

  final LoggerService logger = getIt<LoggerService>();
  logger.info('Application starting');

  try {
    await GoogleFonts.pendingFonts().timeout(
      GameConstants.fontsLoadingTimeout,
      onTimeout: () {
        logger.warning('Google Fonts loading timeout, using fallback fonts');
        return <void>[];
      },
    );
    logger.debug('Google Fonts loaded successfully');
  } catch (e, stackTrace) {
    logger.error('Could not load Google Fonts', e, stackTrace);
  }

  logger.info('Initializing app');
  runApp(
    const ProviderScope(
      child: TicTacApp(),
    ),
  );
}
