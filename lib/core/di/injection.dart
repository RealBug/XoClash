import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:tictac/core/di/injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  preferRelativeImports: true,
)
void configureDependencies() => getIt.init();
