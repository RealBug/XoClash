import 'package:tictac/core/navigation/coordinator.dart';
import 'package:tictac/core/navigation/flow_events.dart';

class HomeCoordinator extends BaseCoordinator {
  HomeCoordinator(super.navigation);

  @override
  bool canHandle(FlowEvent event) => switch (event) {
    RequestNewGame() => true,
    JoinGameCompleted() => true,
    RequestStatistics() => true,
    RequestSettings() => true,
    RequestPlaybook() => true,
    _ => false,
  };

  @override
  void handle(FlowEvent event) {
    switch (event) {
      case RequestNewGame():
        navigation.toGameMode();
      case JoinGameCompleted():
        navigation.toGame();
      case RequestStatistics():
        navigation.toStatistics();
      case RequestSettings(hideProfile: final hide):
        navigation.toSettings(hideProfile: hide);
      case RequestPlaybook():
        navigation.toPlaybook();
      default:
        break;
    }
  }
}
