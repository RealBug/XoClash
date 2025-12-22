import 'package:auto_route/auto_route.dart';
import 'package:tictac/core/services/app_route.dart';

class PageRouteInfoAdapter implements AppRoute {

  const PageRouteInfoAdapter(this._route);
  final PageRouteInfo _route;

  @override
  String get routeName => _route.routeName;
  
  PageRouteInfo get pageRouteInfo => _route;
}

extension PageRouteInfoExtension on PageRouteInfo {
  AppRoute toAppRoute() => PageRouteInfoAdapter(this);
}
