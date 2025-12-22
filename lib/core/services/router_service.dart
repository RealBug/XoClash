import 'package:tictac/core/services/app_route.dart';

abstract class RouterService {
  void navigateToHome();
  void popUntilHome();
  void popAllAndPush(AppRoute route);
}

