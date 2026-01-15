import 'package:tictac/features/game/domain/entities/game_state.dart';

abstract class NavigationService {
  void toHome();
  void toAuth();
  void toLogin();
  void toSignup();
  void toOnboarding();
  void toAvatarSelection();
  void toGameMode();
  void toBoardSize({
    required GameModeType gameMode,
    int? difficulty,
    String? friendName,
    String? friendAvatar,
  });
  void toGame({String? friendAvatar});
  void replaceWithGame({String? friendAvatar});
  void replaceWithAvatarSelection();
  void toSettings({bool hideProfile = false});
  void toStatistics();
  void toPlaybook();

  void pop();
  bool canPop();
  void popUntilHome();
  void popAllAndNavigateToHome();
  void popAllAndNavigateToAuth();
  void popAllAndNavigateToAvatarSelection();
}
