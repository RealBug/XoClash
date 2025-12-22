import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tictac/core/services/router_service.dart';
import 'package:tictac/core/utils/route_adapter.dart';
import 'package:tictac/core/utils/router_service_impl.dart';

class RouterHelper {
  RouterHelper._();

  static RouterService? _testRouterService;

  static set testRouterService(RouterService? routerService) {
    _testRouterService = routerService;
  }

  static RouterService _createRouterService(StackRouter router) {
    return RouterServiceFactory.create(router);
  }

  static RouterService _getRouterService(BuildContext context) {
    if (_testRouterService != null) {
      return _testRouterService!;
    }
    return _createRouterService(context.router);
  }

  /// Navigate to home, clearing all previous routes
  static void navigateToHome(BuildContext context) {
    _getRouterService(context).navigateToHome();
  }

  /// Pop all routes until a specific route can be popped
  static void popUntilHome(BuildContext context) {
    _getRouterService(context).popUntilHome();
  }

  /// Pop all routes and navigate to a specific route
  static void popAllAndPush(BuildContext context, PageRouteInfo route) {
    _getRouterService(context).popAllAndPush(route.toAppRoute());
  }
}

