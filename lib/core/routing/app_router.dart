import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tictac/core/playbook/playbook_screen.dart';
import 'package:tictac/core/routing/splash_route_wrapper.dart';
import 'package:tictac/features/auth/presentation/screens/auth_screen.dart';
import 'package:tictac/features/auth/presentation/screens/login_screen.dart';
import 'package:tictac/features/auth/presentation/screens/signup_screen.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';
import 'package:tictac/features/game/presentation/screens/board_size_screen.dart';
import 'package:tictac/features/game/presentation/screens/game_mode_screen.dart';
import 'package:tictac/features/game/presentation/screens/game_screen.dart';
import 'package:tictac/features/home/presentation/screens/home_screen.dart';
import 'package:tictac/features/onboarding/presentation/screens/avatar_selection_screen.dart';
import 'package:tictac/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:tictac/features/score/presentation/screens/statistics_screen.dart';
import 'package:tictac/features/settings/presentation/screens/settings_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  final List<AutoRoute> routes = <AutoRoute>[
    AutoRoute(
      page: SplashRoute.page,
      initial: true,
      path: '/',
    ),
    CustomRoute<AuthRoute>(
      page: AuthRoute.page,
      path: '/auth',
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    AutoRoute(
      page: LoginRoute.page,
      path: '/login',
    ),
    AutoRoute(
      page: SignupRoute.page,
      path: '/signup',
    ),
    AutoRoute(
      page: HomeRoute.page,
      path: '/home',
    ),
    AutoRoute(
      page: GameModeRoute.page,
      path: '/game-mode',
    ),
    AutoRoute(
      page: BoardSizeRoute.page,
      path: '/board-size',
    ),
    AutoRoute(
      page: GameRoute.page,
      path: '/game',
    ),
    AutoRoute(
      page: SettingsRoute.page,
      path: '/settings',
    ),
    AutoRoute(
      page: StatisticsRoute.page,
      path: '/statistics',
    ),
    AutoRoute(
      page: OnboardingRoute.page,
      path: '/onboarding',
    ),
    AutoRoute(
      page: AvatarSelectionRoute.page,
      path: '/avatar-selection',
    ),
    AutoRoute(
      page: PlaybookRoute.page,
      path: '/playbook',
    ),
  ];
}
