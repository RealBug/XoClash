import 'package:tictac/core/navigation/coordinator.dart';
import 'package:tictac/core/navigation/flow_events.dart';

class NavigationCoordinator extends BaseCoordinator {
  NavigationCoordinator(super.navigation);

  void _goBack() {
    if (navigation.canPop()) {
      navigation.pop();
    } else {
      navigation.popAllAndNavigateToHome();
    }
  }

  @override
  bool canHandle(FlowEvent event) => switch (event) {
    RequestBack() => true,
    RequestHome() => true,
    SplashCompleted() => true,
    _ => false,
  };

  @override
  void handle(FlowEvent event) {
    switch (event) {
      case RequestBack():
        _goBack();
      case RequestHome():
        navigation.popAllAndNavigateToHome();
      case SplashCompleted(hasUser: final hasUser):
        if (hasUser) {
          navigation.toHome();
        } else {
          navigation.toAuth();
        }
      default:
        break;
    }
  }
}
