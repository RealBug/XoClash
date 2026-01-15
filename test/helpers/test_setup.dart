import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictac/core/services/logger_service.dart';
import 'package:tictac/core/services/logger_service_impl.dart';

ProviderContainer createTestContainer() {
  return ProviderContainer();
}

final testLoggerServiceProvider = Provider<LoggerService>(
  (ref) => LoggerServiceImpl(),
);
