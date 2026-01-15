import 'package:auto_route/auto_route.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/core/routing/app_router.dart';
import 'package:tictac/core/services/navigation_service_impl.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';

class MockAppRouter extends Mock implements AppRouter {}
class MockStackRouter extends Mock implements StackRouter {}

class FakePageRouteInfo extends Fake implements PageRouteInfo {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakePageRouteInfo());
  });

  late MockAppRouter mockRouter;
  late NavigationServiceImpl navigationService;

  setUp(() {
    mockRouter = MockAppRouter();
    navigationService = NavigationServiceImpl(mockRouter);

    when(() => mockRouter.push(any())).thenAnswer((_) async => {});
    when(() => mockRouter.replace(any())).thenAnswer((_) async => {});
    when(() => mockRouter.maybePop()).thenAnswer((_) async => true);
    when(() => mockRouter.canPop()).thenReturn(true);
    when(() => mockRouter.popUntilRoot()).thenAnswer((_) async => {});
    when(() => mockRouter.innerRouterOf<StackRouter>(any())).thenReturn(null);
  });

  group('NavigationServiceImpl', () {
    test('toHome pushes HomeRoute', () {
      navigationService.toHome();
      verify(() => mockRouter.push(const HomeRoute())).called(1);
    });

    test('toAuth pushes AuthRoute', () {
      navigationService.toAuth();
      verify(() => mockRouter.push(const AuthRoute())).called(1);
    });

    test('toLogin pushes LoginRoute', () {
      navigationService.toLogin();
      verify(() => mockRouter.push(const LoginRoute())).called(1);
    });

    test('toSignup pushes SignupRoute', () {
      navigationService.toSignup();
      verify(() => mockRouter.push(const SignupRoute())).called(1);
    });

    test('toOnboarding pushes OnboardingRoute', () {
      navigationService.toOnboarding();
      verify(() => mockRouter.push(const OnboardingRoute())).called(1);
    });

    test('toAvatarSelection pushes AvatarSelectionRoute', () {
      navigationService.toAvatarSelection();
      verify(() => mockRouter.push(const AvatarSelectionRoute())).called(1);
    });

    test('toGameMode pushes GameModeRoute', () {
      navigationService.toGameMode();
      verify(() => mockRouter.push(const GameModeRoute())).called(1);
    });

    test('toBoardSize pushes BoardSizeRoute with parameters', () {
      navigationService.toBoardSize(
        gameMode: GameModeType.offlineComputer,
        difficulty: 2,
        friendName: 'Bob',
        friendAvatar: 'avatar1',
      );
      verify(
        () => mockRouter.push(any(that: isA<BoardSizeRoute>())),
      ).called(1);
    });

    test('toGame pushes GameRoute', () {
      navigationService.toGame();
      verify(
        () => mockRouter.push(any(that: isA<GameRoute>())),
      ).called(1);
    });

    test('toGame pushes GameRoute with friendAvatar', () {
      navigationService.toGame(friendAvatar: 'avatar2');
      verify(
        () => mockRouter.push(any(that: isA<GameRoute>())),
      ).called(1);
    });

    test('replaceWithGame replaces with GameRoute', () {
      navigationService.replaceWithGame();
      verify(
        () => mockRouter.replace(any(that: isA<GameRoute>())),
      ).called(1);
    });

    test('replaceWithGame replaces with GameRoute and friendAvatar', () {
      navigationService.replaceWithGame(friendAvatar: 'avatar3');
      verify(
        () => mockRouter.replace(any(that: isA<GameRoute>())),
      ).called(1);
    });

    test('replaceWithAvatarSelection replaces with AvatarSelectionRoute', () {
      navigationService.replaceWithAvatarSelection();
      verify(
        () => mockRouter.replace(const AvatarSelectionRoute()),
      ).called(1);
    });

    test('toSettings pushes SettingsRoute', () {
      navigationService.toSettings();
      verify(
        () => mockRouter.push(any(that: isA<SettingsRoute>())),
      ).called(1);
    });

    test('toSettings pushes SettingsRoute with hideProfile', () {
      navigationService.toSettings(hideProfile: true);
      verify(
        () => mockRouter.push(any(that: isA<SettingsRoute>())),
      ).called(1);
    });

    test('toStatistics pushes StatisticsRoute', () {
      navigationService.toStatistics();
      verify(() => mockRouter.push(const StatisticsRoute())).called(1);
    });

    test('toPlaybook pushes PlaybookRoute', () {
      navigationService.toPlaybook();
      verify(() => mockRouter.push(const PlaybookRoute())).called(1);
    });

    test('pop calls router maybePop', () {
      navigationService.pop();
      verify(() => mockRouter.maybePop()).called(1);
    });

    test('canPop returns router canPop', () {
      when(() => mockRouter.canPop()).thenReturn(false);
      expect(navigationService.canPop(), isFalse);
      verify(() => mockRouter.canPop()).called(1);
    });

    test('popUntilHome pops until HomeRoute', () {
      var callCount = 0;
      when(() => mockRouter.canPop()).thenAnswer((_) {
        callCount++;
        return callCount <= 2;
      });
      when(() => mockRouter.innerRouterOf<StackRouter>(HomeRoute.name))
          .thenReturn(null);

      navigationService.popUntilHome();

      verify(() => mockRouter.canPop()).called(greaterThan(0));
    });

    test('popAllAndNavigateToHome clears stack and pushes HomeRoute', () {
      navigationService.popAllAndNavigateToHome();
      verify(() => mockRouter.popUntilRoot()).called(1);
      verify(() => mockRouter.push(const HomeRoute())).called(1);
    });

    test('popAllAndNavigateToAuth clears stack and pushes AuthRoute', () {
      navigationService.popAllAndNavigateToAuth();
      verify(() => mockRouter.popUntilRoot()).called(1);
      verify(() => mockRouter.push(const AuthRoute())).called(1);
    });

    test('popAllAndNavigateToAvatarSelection clears stack and pushes route', () {
      navigationService.popAllAndNavigateToAvatarSelection();
      verify(() => mockRouter.popUntilRoot()).called(1);
      verify(
        () => mockRouter.push(const AvatarSelectionRoute()),
      ).called(1);
    });
  });
}
