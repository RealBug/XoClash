import 'package:tictac/core/navigation/coordinator.dart';
import 'package:tictac/core/navigation/flow_events.dart';

class AuthCoordinator extends BaseCoordinator {
  AuthCoordinator(super.navigation);

  @override
  bool canHandle(FlowEvent event) => switch (event) {
    RequestLogin() => true,
    RequestSignup() => true,
    LoginCompleted() => true,
    SignupCompleted() => true,
    GuestLoginCompleted() => true,
    LogoutCompleted() => true,
    _ => false,
  };

  @override
  void handle(FlowEvent event) {
    switch (event) {
      case RequestLogin():
        navigation.toLogin();
      case RequestSignup():
        navigation.toSignup();
      case LoginCompleted():
        navigation.popAllAndNavigateToHome();
      case SignupCompleted():
        navigation.popAllAndNavigateToAvatarSelection();
      case GuestLoginCompleted():
        navigation.popAllAndNavigateToHome();
      case LogoutCompleted():
        navigation.popAllAndNavigateToAuth();
      default:
        break;
    }
  }
}
