// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AuthScreen]
class AuthRoute extends PageRouteInfo<void> {
  const AuthRoute({List<PageRouteInfo>? children})
    : super(AuthRoute.name, initialChildren: children);

  static const String name = 'AuthRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AuthScreen();
    },
  );
}

/// generated route for
/// [AvatarSelectionScreen]
class AvatarSelectionRoute extends PageRouteInfo<void> {
  const AvatarSelectionRoute({List<PageRouteInfo>? children})
    : super(AvatarSelectionRoute.name, initialChildren: children);

  static const String name = 'AvatarSelectionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AvatarSelectionScreen();
    },
  );
}

/// generated route for
/// [BoardSizeScreen]
class BoardSizeRoute extends PageRouteInfo<BoardSizeRouteArgs> {
  BoardSizeRoute({
    Key? key,
    GameModeType? gameMode,
    int? difficulty,
    String? friendName,
    String? friendAvatar,
    List<PageRouteInfo>? children,
  }) : super(
         BoardSizeRoute.name,
         args: BoardSizeRouteArgs(
           key: key,
           gameMode: gameMode,
           difficulty: difficulty,
           friendName: friendName,
           friendAvatar: friendAvatar,
         ),
         initialChildren: children,
       );

  static const String name = 'BoardSizeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BoardSizeRouteArgs>(
        orElse: () => const BoardSizeRouteArgs(),
      );
      return BoardSizeScreen(
        key: args.key,
        gameMode: args.gameMode,
        difficulty: args.difficulty,
        friendName: args.friendName,
        friendAvatar: args.friendAvatar,
      );
    },
  );
}

class BoardSizeRouteArgs {
  const BoardSizeRouteArgs({
    this.key,
    this.gameMode,
    this.difficulty,
    this.friendName,
    this.friendAvatar,
  });

  final Key? key;

  final GameModeType? gameMode;

  final int? difficulty;

  final String? friendName;

  final String? friendAvatar;

  @override
  String toString() {
    return 'BoardSizeRouteArgs{key: $key, gameMode: $gameMode, difficulty: $difficulty, friendName: $friendName, friendAvatar: $friendAvatar}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BoardSizeRouteArgs) return false;
    return key == other.key &&
        gameMode == other.gameMode &&
        difficulty == other.difficulty &&
        friendName == other.friendName &&
        friendAvatar == other.friendAvatar;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      gameMode.hashCode ^
      difficulty.hashCode ^
      friendName.hashCode ^
      friendAvatar.hashCode;
}

/// generated route for
/// [GameModeScreen]
class GameModeRoute extends PageRouteInfo<void> {
  const GameModeRoute({List<PageRouteInfo>? children})
    : super(GameModeRoute.name, initialChildren: children);

  static const String name = 'GameModeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const GameModeScreen();
    },
  );
}

/// generated route for
/// [GameScreen]
class GameRoute extends PageRouteInfo<GameRouteArgs> {
  GameRoute({Key? key, String? friendAvatar, List<PageRouteInfo>? children})
    : super(
        GameRoute.name,
        args: GameRouteArgs(key: key, friendAvatar: friendAvatar),
        initialChildren: children,
      );

  static const String name = 'GameRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GameRouteArgs>(
        orElse: () => const GameRouteArgs(),
      );
      return GameScreen(key: args.key, friendAvatar: args.friendAvatar);
    },
  );
}

class GameRouteArgs {
  const GameRouteArgs({this.key, this.friendAvatar});

  final Key? key;

  final String? friendAvatar;

  @override
  String toString() {
    return 'GameRouteArgs{key: $key, friendAvatar: $friendAvatar}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GameRouteArgs) return false;
    return key == other.key && friendAvatar == other.friendAvatar;
  }

  @override
  int get hashCode => key.hashCode ^ friendAvatar.hashCode;
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeScreen();
    },
  );
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginScreen();
    },
  );
}

/// generated route for
/// [OnboardingScreen]
class OnboardingRoute extends PageRouteInfo<void> {
  const OnboardingRoute({List<PageRouteInfo>? children})
    : super(OnboardingRoute.name, initialChildren: children);

  static const String name = 'OnboardingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OnboardingScreen();
    },
  );
}

/// generated route for
/// [PlaybookScreen]
class PlaybookRoute extends PageRouteInfo<void> {
  const PlaybookRoute({List<PageRouteInfo>? children})
    : super(PlaybookRoute.name, initialChildren: children);

  static const String name = 'PlaybookRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PlaybookScreen();
    },
  );
}

/// generated route for
/// [SettingsScreen]
class SettingsRoute extends PageRouteInfo<SettingsRouteArgs> {
  SettingsRoute({
    Key? key,
    bool hideProfile = false,
    List<PageRouteInfo>? children,
  }) : super(
         SettingsRoute.name,
         args: SettingsRouteArgs(key: key, hideProfile: hideProfile),
         initialChildren: children,
       );

  static const String name = 'SettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SettingsRouteArgs>(
        orElse: () => const SettingsRouteArgs(),
      );
      return SettingsScreen(key: args.key, hideProfile: args.hideProfile);
    },
  );
}

class SettingsRouteArgs {
  const SettingsRouteArgs({this.key, this.hideProfile = false});

  final Key? key;

  final bool hideProfile;

  @override
  String toString() {
    return 'SettingsRouteArgs{key: $key, hideProfile: $hideProfile}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SettingsRouteArgs) return false;
    return key == other.key && hideProfile == other.hideProfile;
  }

  @override
  int get hashCode => key.hashCode ^ hideProfile.hashCode;
}

/// generated route for
/// [SignupScreen]
class SignupRoute extends PageRouteInfo<void> {
  const SignupRoute({List<PageRouteInfo>? children})
    : super(SignupRoute.name, initialChildren: children);

  static const String name = 'SignupRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SignupScreen();
    },
  );
}

/// generated route for
/// [SplashRouteWrapper]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashRouteWrapper();
    },
  );
}

/// generated route for
/// [StatisticsScreen]
class StatisticsRoute extends PageRouteInfo<void> {
  const StatisticsRoute({List<PageRouteInfo>? children})
    : super(StatisticsRoute.name, initialChildren: children);

  static const String name = 'StatisticsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const StatisticsScreen();
    },
  );
}
