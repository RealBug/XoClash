import 'package:tictac/core/navigation/coordinator.dart';
import 'package:tictac/core/navigation/flow_events.dart';

class GameCoordinator extends BaseCoordinator {
  GameCoordinator(super.navigation);

  @override
  bool canHandle(FlowEvent event) => switch (event) {
    GameModeSelected() => true,
    GameStarted() => true,
    _ => false,
  };

  @override
  void handle(FlowEvent event) {
    switch (event) {
      case GameModeSelected(
        mode: final mode,
        difficulty: final diff,
        friendName: final name,
        friendAvatar: final avatar,
      ):
        navigation.toBoardSize(
          gameMode: mode,
          difficulty: diff,
          friendName: name,
          friendAvatar: avatar,
        );
      case GameStarted(friendAvatar: final avatar):
        navigation.replaceWithGame(friendAvatar: avatar);
      default:
        break;
    }
  }
}
