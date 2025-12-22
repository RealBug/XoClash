import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictac/core/di/injection.dart';
import 'package:tictac/core/services/app_info_service.dart';
import 'package:tictac/core/services/audio_service.dart';
import 'package:tictac/core/services/logger_service.dart';

final Provider<AudioService> audioServiceProvider = Provider<AudioService>((Ref ref) => getIt<AudioService>());

final Provider<LoggerService> loggerServiceProvider = Provider<LoggerService>((Ref ref) => getIt<LoggerService>());

final Provider<AppInfoService> appInfoServiceProvider = Provider<AppInfoService>((Ref ref) => getIt<AppInfoService>());
