import 'package:tictac/core/navigation/coordinator.dart';
import 'package:tictac/core/navigation/coordinators/navigation_coordinator.dart';
import 'package:tictac/core/navigation/flow_events.dart';
import 'package:tictac/core/services/logger_service.dart';
import 'package:tictac/core/services/navigation_service.dart';
import 'package:tictac/features/auth/navigation/auth_coordinator.dart';
import 'package:tictac/features/game/navigation/game_coordinator.dart';
import 'package:tictac/features/home/navigation/home_coordinator.dart';
import 'package:tictac/features/onboarding/navigation/onboarding_coordinator.dart';

class FlowCoordinator {
  FlowCoordinator(NavigationService navigation, {LoggerService? logger})
    : _coordinators = [
        AuthCoordinator(navigation),
        OnboardingCoordinator(navigation),
        HomeCoordinator(navigation),
        GameCoordinator(navigation),
        NavigationCoordinator(navigation),
      ],
      _logger = logger;

  FlowCoordinator.withCoordinators(
    List<Coordinator> coordinators, {
    LoggerService? logger,
  }) : _coordinators = coordinators,
       _logger = logger;

  final List<Coordinator> _coordinators;
  final LoggerService? _logger;

  void handle(FlowEvent event) {
    for (final coordinator in _coordinators) {
      if (coordinator.canHandle(event)) {
        coordinator.handle(event);
        return;
      }
    }
    _logger?.warning('Unhandled FlowEvent: ${event.runtimeType}');
  }
}
