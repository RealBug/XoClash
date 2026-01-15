import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:tictac/core/constants/logger_constants.dart';
import 'package:tictac/core/services/logger_service.dart';

class LoggerServiceImpl implements LoggerService {

  LoggerServiceImpl();
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: LoggerConstants.methodCount,
      errorMethodCount: LoggerConstants.errorMethodCount,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    level: kDebugMode ? Level.debug : Level.off,
  );

  @override
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  @override
  void warning(String message) {
    _logger.w(message);
  }

  @override
  void info(String message) {
    _logger.i(message);
  }

  @override
  void debug(String message) {
    _logger.d(message);
  }
}
