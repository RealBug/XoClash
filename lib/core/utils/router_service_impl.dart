import 'package:auto_route/auto_route.dart';
import 'package:tictac/core/routing/app_router.dart';
import 'package:tictac/core/services/app_route.dart';
import 'package:tictac/core/services/router_service.dart';

class RouterServiceImpl implements RouterService {

  RouterServiceImpl(this._router, [PageRouteInfo Function(AppRoute)? routeConverter])
      : _routeConverter = routeConverter ?? _defaultRouteConverter;
  final StackRouter _router;
  final PageRouteInfo Function(AppRoute) _routeConverter;

  static PageRouteInfo _defaultRouteConverter(AppRoute route) {
    return switch (route.routeName) {
      'HomeRoute' => const HomeRoute(),
      'AuthRoute' => const AuthRoute(),
      'LoginRoute' => const LoginRoute(),
      'SignupRoute' => const SignupRoute(),
      'GameModeRoute' => const GameModeRoute(),
      'BoardSizeRoute' => BoardSizeRoute(),
      'GameRoute' => GameRoute(),
      'SettingsRoute' => SettingsRoute(),
      'StatisticsRoute' => const StatisticsRoute(),
      'OnboardingRoute' => const OnboardingRoute(),
      'AvatarSelectionRoute' => const AvatarSelectionRoute(),
      'PlaybookRoute' => const PlaybookRoute(),
      _ => throw ArgumentError('Unknown route: ${route.routeName}'),
    };
  }

  @override
  void navigateToHome() {
    while (_router.canPop()) {
      _router.pop();
    }
    _router.push(const HomeRoute());
  }

  @override
  void popUntilHome() {
    while (_router.canPop()) {
      _router.pop();
    }
  }

  @override
  void popAllAndPush(AppRoute route) {
    final PageRouteInfo<Object?> pageRouteInfo = _routeConverter(route);
    while (_router.canPop()) {
      _router.pop();
    }
    _router.push(pageRouteInfo);
  }
}

class RouterServiceFactory {
  RouterServiceFactory._();

  static RouterService create(
    StackRouter router, [
    PageRouteInfo Function(AppRoute)? routeConverter,
  ]) {
    return RouterServiceImpl(router, routeConverter);
  }
}

