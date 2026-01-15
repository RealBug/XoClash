import 'package:tictac/core/navigation/coordinator.dart';
import 'package:tictac/core/navigation/flow_events.dart';

class OnboardingCoordinator extends BaseCoordinator {
  OnboardingCoordinator(super.navigation);

  @override
  bool canHandle(FlowEvent event) => switch (event) {
    RequestOnboarding() => true,
    OnboardingUsernameCompleted() => true,
    RequestAvatarSelection() => true,
    AvatarSelectionCompleted() => true,
    AvatarSelectionSkipped() => true,
    _ => false,
  };

  @override
  void handle(FlowEvent event) {
    switch (event) {
      case RequestOnboarding():
        navigation.toOnboarding();
      case OnboardingUsernameCompleted():
        navigation.replaceWithAvatarSelection();
      case RequestAvatarSelection():
        navigation.toAvatarSelection();
      case AvatarSelectionCompleted():
        navigation.popAllAndNavigateToHome();
      case AvatarSelectionSkipped():
        navigation.popAllAndNavigateToHome();
      default:
        break;
    }
  }
}
