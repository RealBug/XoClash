import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictac/core/routing/app_router.dart';
import 'package:tictac/core/services/app_info_service.dart';
import 'package:tictac/core/services/app_info_service_impl.dart';
import 'package:tictac/core/services/audio_service.dart';
import 'package:tictac/core/services/audio_service_impl.dart';
import 'package:tictac/core/services/logger_service.dart';
import 'package:tictac/core/services/logger_service_impl.dart';
import 'package:tictac/core/services/navigation_service.dart';
import 'package:tictac/core/services/navigation_service_impl.dart';
import 'package:tictac/features/auth/data/datasources/auth_datasource.dart';
import 'package:tictac/features/auth/data/services/auth_backend_service.dart';
import 'package:tictac/features/auth/data/services/firebase_auth_backend_service.dart';
import 'package:tictac/features/game/data/datasources/local_game_datasource.dart';
import 'package:tictac/features/game/data/datasources/remote_game_datasource.dart';
import 'package:tictac/features/game/data/repositories/game_repository_impl.dart';
import 'package:tictac/features/game/data/services/firebase_game_backend_service.dart';
import 'package:tictac/features/game/data/services/game_backend_service.dart';
import 'package:tictac/features/game/domain/repositories/game_repository.dart';
import 'package:tictac/features/history/data/datasources/history_datasource.dart';
import 'package:tictac/features/history/data/repositories/history_repository_impl.dart';
import 'package:tictac/features/history/domain/repositories/history_repository.dart';
import 'package:tictac/features/score/data/datasources/score_datasource.dart';
import 'package:tictac/features/score/data/repositories/score_repository_impl.dart';
import 'package:tictac/features/score/domain/repositories/score_repository.dart';
import 'package:tictac/features/settings/data/datasources/settings_datasource.dart';
import 'package:tictac/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:tictac/features/settings/domain/repositories/settings_repository.dart';
import 'package:tictac/features/user/data/datasources/user_datasource.dart';
import 'package:tictac/features/user/data/repositories/user_repository_impl.dart';
import 'package:tictac/features/user/domain/repositories/user_repository.dart';

final Provider<LoggerService> loggerServiceProvider = Provider<LoggerService>(
  (Ref ref) => LoggerServiceImpl(),
);

final Provider<AppRouter> appRouterProvider = Provider<AppRouter>(
  (Ref ref) => AppRouter(),
);

final Provider<NavigationService> navigationServiceProvider =
    Provider<NavigationService>(
      (Ref ref) => NavigationServiceImpl(ref.watch(appRouterProvider)),
    );

final Provider<AudioService> audioServiceProvider = Provider<AudioService>(
  (Ref ref) => AudioServiceImpl(ref.watch(loggerServiceProvider)),
);

final Provider<AppInfoService> appInfoServiceProvider =
    Provider<AppInfoService>(
      (Ref ref) => AppInfoServiceImpl(ref.watch(loggerServiceProvider)),
    );

final Provider<UserDataSource> userDataSourceProvider =
    Provider<UserDataSource>((Ref ref) => UserDataSourceImpl());

final Provider<ScoreDataSource> scoreDataSourceProvider =
    Provider<ScoreDataSource>((Ref ref) => ScoreDataSourceImpl());

final Provider<HistoryDataSource> historyDataSourceProvider =
    Provider<HistoryDataSource>((Ref ref) => HistoryDataSourceImpl());

final Provider<SettingsDataSource> settingsDataSourceProvider =
    Provider<SettingsDataSource>((Ref ref) => SettingsDataSourceImpl());

final Provider<LocalGameDataSource> localGameDataSourceProvider =
    Provider<LocalGameDataSource>(
      (Ref ref) => LocalGameDataSourceImpl(ref.watch(loggerServiceProvider)),
    );

final Provider<GameBackendService> gameBackendServiceProvider =
    Provider<GameBackendService>(
      (Ref ref) =>
          FirebaseGameBackendService(null, ref.watch(loggerServiceProvider)),
    );

final Provider<RemoteGameDataSource> remoteGameDataSourceProvider =
    Provider<RemoteGameDataSource>(
      (Ref ref) => RemoteGameDataSourceImpl(
        ref.watch(gameBackendServiceProvider),
        ref.watch(loggerServiceProvider),
      ),
    );

final Provider<AuthBackendService> authBackendServiceProvider =
    Provider<AuthBackendService>(
      (Ref ref) => FirebaseAuthBackendService(
        null,
        null,
        ref.watch(loggerServiceProvider),
      ),
    );

final Provider<AuthDataSource> authDataSourceProvider =
    Provider<AuthDataSource>(
      (Ref ref) => AuthDataSourceImpl(
        ref.watch(authBackendServiceProvider),
        ref.watch(loggerServiceProvider),
      ),
    );

final Provider<UserRepository> userRepositoryProvider =
    Provider<UserRepository>(
      (Ref ref) =>
          UserRepositoryImpl(dataSource: ref.watch(userDataSourceProvider)),
    );

final Provider<ScoreRepository> scoreRepositoryProvider =
    Provider<ScoreRepository>(
      (Ref ref) =>
          ScoreRepositoryImpl(dataSource: ref.watch(scoreDataSourceProvider)),
    );

final Provider<HistoryRepository> historyRepositoryProvider =
    Provider<HistoryRepository>(
      (Ref ref) => HistoryRepositoryImpl(
        dataSource: ref.watch(historyDataSourceProvider),
      ),
    );

final Provider<SettingsRepository> settingsRepositoryProvider =
    Provider<SettingsRepository>(
      (Ref ref) => SettingsRepositoryImpl(
        dataSource: ref.watch(settingsDataSourceProvider),
      ),
    );

final Provider<GameRepository> gameRepositoryProvider =
    Provider<GameRepository>(
      (Ref ref) => GameRepositoryImpl(
        localDataSource: ref.watch(localGameDataSourceProvider),
        remoteDataSource: ref.watch(remoteGameDataSourceProvider),
        logger: ref.watch(loggerServiceProvider),
      ),
    );
