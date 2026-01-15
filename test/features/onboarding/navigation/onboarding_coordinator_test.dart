import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/core/navigation/flow_events.dart';
import 'package:tictac/core/services/navigation_service.dart';
import 'package:tictac/features/onboarding/navigation/onboarding_coordinator.dart';

class MockNavigationService extends Mock implements NavigationService {}

void main() {
  late MockNavigationService mockNavigation;
  late OnboardingCoordinator coordinator;

  setUp(() {
    mockNavigation = MockNavigationService();
    coordinator = OnboardingCoordinator(mockNavigation);
    when(() => mockNavigation.canPop()).thenReturn(true);
  });

  group('canHandle', () {
    test('returns true for RequestOnboarding', () {
      expect(coordinator.canHandle(RequestOnboarding()), isTrue);
    });

    test('returns true for OnboardingUsernameCompleted', () {
      expect(coordinator.canHandle(OnboardingUsernameCompleted()), isTrue);
    });

    test('returns true for RequestAvatarSelection', () {
      expect(coordinator.canHandle(RequestAvatarSelection()), isTrue);
    });

    test('returns true for AvatarSelectionCompleted', () {
      expect(coordinator.canHandle(AvatarSelectionCompleted()), isTrue);
    });

    test('returns true for AvatarSelectionSkipped', () {
      expect(coordinator.canHandle(AvatarSelectionSkipped()), isTrue);
    });

    test('returns false for unhandled events', () {
      expect(coordinator.canHandle(RequestNewGame()), isFalse);
      expect(coordinator.canHandle(RequestLogin()), isFalse);
    });
  });

  group('handle', () {
    test('navigates to onboarding on RequestOnboarding', () {
      coordinator.handle(RequestOnboarding());
      verify(() => mockNavigation.toOnboarding()).called(1);
    });

    test('replaces with avatar selection on OnboardingUsernameCompleted', () {
      coordinator.handle(OnboardingUsernameCompleted());
      verify(() => mockNavigation.replaceWithAvatarSelection()).called(1);
    });

    test('navigates to avatar selection on RequestAvatarSelection', () {
      coordinator.handle(RequestAvatarSelection());
      verify(() => mockNavigation.toAvatarSelection()).called(1);
    });

    test('navigates to home on AvatarSelectionCompleted', () {
      coordinator.handle(AvatarSelectionCompleted());
      verify(() => mockNavigation.popAllAndNavigateToHome()).called(1);
    });

    test('navigates to home on AvatarSelectionSkipped', () {
      coordinator.handle(AvatarSelectionSkipped());
      verify(() => mockNavigation.popAllAndNavigateToHome()).called(1);
    });
  });
}
