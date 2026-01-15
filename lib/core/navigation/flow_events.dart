import 'package:tictac/features/game/domain/entities/game_state.dart';

sealed class FlowEvent {}

// Auth Flow
class RequestLogin extends FlowEvent {}
class RequestSignup extends FlowEvent {}
class LoginCompleted extends FlowEvent {}
class SignupCompleted extends FlowEvent {}
class GuestLoginCompleted extends FlowEvent {}
class LogoutCompleted extends FlowEvent {}

// Onboarding Flow
class RequestOnboarding extends FlowEvent {}
class OnboardingUsernameCompleted extends FlowEvent {}
class RequestAvatarSelection extends FlowEvent {}
class AvatarSelectionCompleted extends FlowEvent {}
class AvatarSelectionSkipped extends FlowEvent {}

// Home Flow
class RequestNewGame extends FlowEvent {}
class JoinGameCompleted extends FlowEvent {}
class RequestStatistics extends FlowEvent {}
class RequestSettings extends FlowEvent {
  RequestSettings({this.hideProfile = false});
  final bool hideProfile;
}

// Game Flow
class GameModeSelected extends FlowEvent {
  GameModeSelected({
    required this.mode,
    this.difficulty,
    this.friendName,
    this.friendAvatar,
  });
  final GameModeType mode;
  final int? difficulty;
  final String? friendName;
  final String? friendAvatar;
}

class GameStarted extends FlowEvent {
  GameStarted({this.friendAvatar});
  final String? friendAvatar;
}

// Settings Flow
class RequestPlaybook extends FlowEvent {}

// Navigation
class RequestBack extends FlowEvent {}
class RequestHome extends FlowEvent {}

// Splash
class SplashCompleted extends FlowEvent {
  SplashCompleted({required this.hasUser});
  final bool hasUser;
}
