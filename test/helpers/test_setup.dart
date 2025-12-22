import 'package:get_it/get_it.dart';
import 'package:tictac/core/services/logger_service.dart';
import 'package:tictac/core/services/logger_service_impl.dart';

void setupTestGetIt() {
  final GetIt getIt = GetIt.instance;
  
  if (!getIt.isRegistered<LoggerService>()) {
    getIt.registerLazySingleton<LoggerService>(() => LoggerServiceImpl());
  }
}

void tearDownTestGetIt() {
  final GetIt getIt = GetIt.instance;
  if (getIt.isRegistered<LoggerService>()) {
    getIt.unregister<LoggerService>();
  }
}

