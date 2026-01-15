import 'package:auto_route/auto_route.dart';
import 'package:tictac/core/routing/app_router.dart';
import 'package:tictac/core/services/navigation_service.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';

class NavigationServiceImpl implements NavigationService {
  NavigationServiceImpl(this._router);

  final AppRouter _router;

  @override
  void toHome() {
    _router.push(const HomeRoute());
  }

  @override
  void toAuth() {
    _router.push(const AuthRoute());
  }

  @override
  void toLogin() {
    _router.push(const LoginRoute());
  }

  @override
  void toSignup() {
    _router.push(const SignupRoute());
  }

  @override
  void toOnboarding() {
    _router.push(const OnboardingRoute());
  }

  @override
  void toAvatarSelection() {
    _router.push(const AvatarSelectionRoute());
  }

  @override
  void toGameMode() {
    _router.push(const GameModeRoute());
  }

  @override
  void toBoardSize({
    required GameModeType gameMode,
    int? difficulty,
    String? friendName,
    String? friendAvatar,
  }) {
    _router.push(BoardSizeRoute(
      gameMode: gameMode,
      difficulty: difficulty,
      friendName: friendName,
      friendAvatar: friendAvatar,
    ));
  }

  @override
  void toGame({String? friendAvatar}) {
    _router.push(GameRoute(friendAvatar: friendAvatar));
  }

  @override
  void replaceWithGame({String? friendAvatar}) {
    _router.replace(GameRoute(friendAvatar: friendAvatar));
  }

  @override
  void replaceWithAvatarSelection() {
    _router.replace(const AvatarSelectionRoute());
  }

  @override
  void toSettings({bool hideProfile = false}) {
    _router.push(SettingsRoute(hideProfile: hideProfile));
  }

  @override
  void toStatistics() {
    _router.push(const StatisticsRoute());
  }

  @override
  void toPlaybook() {
    _router.push(const PlaybookRoute());
  }

  @override
  void pop() {
    _router.maybePop();
  }

  @override
  bool canPop() {
    return _router.canPop();
  }

  @override
  void popUntilHome() {
    while (_router.canPop()) {
      _router.innerRouterOf<StackRouter>(HomeRoute.name)?.maybePop() ??
          _router.maybePop();
    }
  }

  @override
  void popAllAndNavigateToHome() {
    _router.popUntilRoot();
    _router.push(const HomeRoute());
  }

  @override
  void popAllAndNavigateToAuth() {
    _router.popUntilRoot();
    _router.push(const AuthRoute());
  }

  @override
  void popAllAndNavigateToAvatarSelection() {
    _router.popUntilRoot();
    _router.push(const AvatarSelectionRoute());
  }
}
